const std = @import("std");
const net = std.net;
const json = std.json;
const ArrayList = std.ArrayList;
const models = @import("../models/models.zig");
const Fragments = models.Fragments;
const Fragment = Fragments.Fragment;
const networking = @import("networking.zig");

const Self = @This();

allocator: std.mem.Allocator = undefined,
worker_name: []const u8,
signature: []const u8 = undefined,
maximal_work_load: u32,
stream: net.Stream = undefined,
inner_stream: net.Stream = undefined,

pub fn init(allocator: std.mem.Allocator, worker_name: []const u8, maximal_work_load: u32) Self {
    return .{
        .allocator = allocator,
        .worker_name = worker_name,
        .maximal_work_load = maximal_work_load,
    };
}

pub fn deinit(self: *Self) void {
    _ = self;
}

pub fn start_worker(self: *Self) !void {
    std.log.info("Worker {s} started !", .{self.worker_name});
    defer std.log.info("Worker {s} has disconnected !", .{self.worker_name});

    self.stream = try networking.connect(self.allocator, "localhost", 8787);
    std.log.info("Worker {s} connected to {s}:{d} !", .{ self.worker_name, "localhost", 8787 });

    try self.send_request();

    const raw_response = try networking.read_message_raw(self.allocator, &self.stream);
    const json_bytes = raw_response.buffer.items[0..raw_response.json_size];
    const signature_bytes = raw_response.buffer.items[raw_response.json_size..];
    var fragment = try Fragment.from_json(self.allocator, json_bytes);

    std.log.debug("{!s}\n", .{fragment.to_string(self.allocator)});

    std.log.debug("Signature: {any}\n", .{signature_bytes});

    var task = fragment.FragmentTask;

    var data_buffer = ArrayList(u8).init(self.allocator);
    defer data_buffer.deinit();

    try data_buffer.appendSlice(signature_bytes);

    var result = try task.perform(data_buffer.writer());

    self.inner_stream = try networking.connect(self.allocator, "localhost", 8787);

    try self.send_result(&result, data_buffer.items, signature_bytes);
}

fn send_result(self: *Self, result: *Fragments.FragmentResult, data: []const u8, signature: []const u8) !void {
    var fragment_buffer = ArrayList(u8).init(self.allocator);
    defer fragment_buffer.deinit();

    var fragment = Fragment{ .FragmentResult = result.* };
    try fragment.to_json(fragment_buffer.writer());

    std.log.debug("{!s}\n", .{fragment.to_string(self.allocator)});
    // std.log.debug("Data: {any}", .{data});

    try networking.send_message(self.allocator, &self.inner_stream, fragment_buffer.items, data, signature);
}

fn send_request(self: *Self) !void {
    var buffer = ArrayList(u8).init(self.allocator);
    defer buffer.deinit();

    var request = Fragments.FragmentRequest{ .worker_name = self.worker_name, .maximal_work_load = self.maximal_work_load };
    var fragment = Fragment{ .FragmentRequest = request };
    try fragment.to_json(buffer.writer());

    try networking.send_message(self.allocator, &self.stream, buffer.items, null, null);
}
