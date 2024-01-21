const std = @import("std");
const net = std.net;
const json = std.json;
const ArrayList = std.ArrayList;
const models = @import("./models/models.zig");
const Fragments = models.Fragments;
const Fragment = Fragments.Fragment;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var request = Fragments.FragmentRequest{ .worker_name = "adia-dev", .maximal_work_load = 100 };
    var fragment_request = Fragment{ .FragmentRequest = request };
    try fragment_request.print(arena.allocator());

    var arr = ArrayList(u8).init(arena.allocator());
    try json.stringify(fragment_request, .{}, arr.writer());

    std.debug.print("{s}\n", .{arr.items});

    var json_size: u32 = @intCast(arr.items.len);
    var data_size: u32 = 0;
    var total_size: u32 = json_size + data_size;

    var buffer = ArrayList(u8).init(arena.allocator());
    defer buffer.deinit();

    var buf_writer = buffer.writer();

    try buf_writer.writeInt(u32, total_size, std.builtin.Endian.Big);
    try buf_writer.writeInt(u32, json_size, std.builtin.Endian.Big);
    try buf_writer.writeAll(arr.items);

    for (buffer.items) |b| {
        std.debug.print("{d}, ", .{b});
    }

    var stream = try net.tcpConnectToHost(arena.allocator(), "localhost", 8787);

    _ = try stream.writeAll(buffer.items);
}
