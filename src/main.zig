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

    var worker = Worker.init(arena.allocator(), "adia-dev", 150);
    defer worker.deinit();

    try worker.start_worker();
}
