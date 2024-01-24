const std = @import("std");
const Logger = @import("core/logger.zig");

const networking = @import("./networking/networking.zig");

const models = @import("./models/models.zig");
const Worker = @import("./networking/worker.zig");
const Time = @import("./time/time.zig").Time;
const Color = @import("./color/ansi.zig");

const net = std.net;
const json = std.json;
const ArrayList = std.ArrayList;

const Fragments = models.Fragments;
const Fragment = Fragments.Fragment;

pub const std_options = struct {
    pub const log_level = .debug;
    pub const logFn = Logger.log;
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var worker = Worker.init(arena.allocator(), "adia-dev", 150);
    defer worker.deinit();

    worker.start_worker() catch |err| {
        std.log.err("Application panicked with an error: {!}", .{err});
    };
}
