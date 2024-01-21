const std = @import("std");
const net = std.net;
const json = std.json;
const ArrayList = std.ArrayList;
const models = @import("../models/models.zig");
const Fragments = models.Fragments;
const Fragment = Fragments.Fragment;
const networking = @import("networking.zig");

pub fn start_worker() !void {}

pub fn send_request(allocator: std.mem.Allocator, stream: *net.Stream, request: *Fragments.FragmentRequest) !void {
    var fragment_request = Fragment{ .FragmentRequest = request.* };

    var json_bytes = ArrayList(u8).init(allocator);
    try json.stringify(fragment_request, .{}, json_bytes.writer());

    try networking.send_message(allocator, stream, json_bytes.items, null);
}
