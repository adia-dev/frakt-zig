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
const PixelIntensity = models.PixelIntensity;
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

    while (true) {
        worker.start_worker() catch |err| {
            std.log.err("Application panicked with an error: {!}", .{err});
            return;
        };

        std.log.info("Sleeping a little bit...", .{});
        std.time.sleep(1 * std.time.ns_per_s);
    }

    // const pixel_intensity = PixelIntensity{ .zn = 8.450674, .count = 0.015625 };

    // const zn_u32: u32 = @bitCast(pixel_intensity.zn);
    // const count_u32: u32 = @bitCast(pixel_intensity.count);

    // var arr = ArrayList(u8).init(arena.allocator());
    // defer arr.deinit();

    // var arr_writer = arr.writer();
    // try arr_writer.writeInt(u32, zn_u32, std.builtin.Endian.Big);
    // try arr_writer.writeInt(u32, count_u32, std.builtin.Endian.Big);
    // std.debug.print("Arr [", .{});
    // for (arr.items) |item| {
    //     std.debug.print("{x:0>2}, ", .{item});
    // }
    // std.debug.print("]\n", .{});

    // const bytes = std.mem.toBytes(pixel_intensity);
    // std.log.debug("PixelIntensity: {s}", .{try pixel_intensity.to_string(arena.allocator())});
    // std.debug.print("Bytes: [", .{});
    // for (bytes) |byte| {
    //     std.debug.print("{x:0>2}, ", .{byte});
    // }
    // std.debug.print("]\n", .{});
}
