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
maximal_work_load: u32,
stream: net.Stream = undefined,

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

pub fn connect(self: *Self, host: []const u8, port: u16) !void {
    self.stream = try net.tcpConnectToHost(self.allocator, host, port);
}

pub fn start_worker(self: *Self) !void {
    try self.connect("localhost", 8787);

    try self.send_request();
    var fragment = try networking.read_fragment(self.allocator, &self.stream);

    std.debug.print("{!s}", .{fragment.to_string(self.allocator)});
}

fn send_request(self: *Self) !void {
    var buffer = ArrayList(u8).init(self.allocator);
    defer buffer.deinit();

    var request = Fragments.FragmentRequest{ .worker_name = self.worker_name, .maximal_work_load = self.maximal_work_load };
    var fragment = Fragment{ .FragmentRequest = request };
    try fragment.to_json(buffer.writer());

    try networking.send_message(self.allocator, &self.stream, buffer.items, null);
}
