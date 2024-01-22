const std = @import("std");
const log = @import("core/logging.zig").log;

const networking = @import("./networking/networking.zig");

const models = @import("./models/models.zig");
const Worker = @import("./networking/worker.zig");
const Time = @import("./time/time.zig").Time;
const Color = @import("./color/ansii.zig");

const net = std.net;
const json = std.json;
const ArrayList = std.ArrayList;

const Fragments = models.Fragments;
const Fragment = Fragments.Fragment;

pub const std_options = struct {
    pub const log_level = .debug;
    pub const logFn = log;
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var worker = Worker.init(arena.allocator(), "adia-dev", 150);
    defer worker.deinit();

    // this is so cooooool
    // Color.red("Hello {s}", .{"adia-dev"}, std.log.info);
    // Color.green("Hello {s}", .{"adia-dev"}, std.log.info);
    // Color.yellow("Hello {s}", .{"adia-dev"}, std.log.info);
    // Color.grey("Hello {s}", .{"adia-dev"}, std.log.info);

    try worker.start_worker();
}
