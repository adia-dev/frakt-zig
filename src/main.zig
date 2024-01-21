const std = @import("std");
const net = std.net;
const json = std.json;
const ArrayList = std.ArrayList;
const models = @import("./models/models.zig");
const Fragments = models.Fragments;
const Fragment = Fragments.Fragment;
const Worker = @import("./networking/worker.zig");
const networking = @import("./networking/networking.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var stream = try net.tcpConnectToHost(arena.allocator(), "localhost", 8787);

    var request = Fragments.FragmentRequest{ .worker_name = "adia-dev", .maximal_work_load = 100 };
    try Worker.send_request(arena.allocator(), &stream, &request);

    var raw_response = try networking.read_message_raw(arena.allocator(), &stream);

    std.debug.print("total_size: {d}\n", .{raw_response.total_size});
    std.debug.print("json_size: {d}\n", .{raw_response.json_size});
    std.debug.print("bytes: {s}\n", .{raw_response.buffer.items});

    var fragment = try json.parseFromSliceLeaky(Fragment, arena.allocator(), raw_response.buffer.items[0..raw_response.json_size], .{ .ignore_unknown_fields = true });
    std.debug.print("\n{any}", .{fragment.FragmentTask});
}
