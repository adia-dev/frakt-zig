const std = @import("std");
const Time = @import("../time/time.zig").Time;
const Color = @import("../color/ansii.zig");

pub fn log(comptime level: std.log.Level, comptime scope: @Type(.EnumLiteral), comptime format: []const u8, args: anytype) void {
    _ = scope;

    const timestamp = std.time.timestamp();
    const time = Time.from_unix_timestamp(timestamp + @as(i64, 3600));

    std.debug.getStderrMutex().lock();
    defer std.debug.getStderrMutex().unlock();
    const stderr = std.io.getStdErr().writer();

    // EwWWWWWWEwww
    // TODO: search if it is possible to merge these into a single print call
    nosuspend stderr.print("\x1b[37m{d:0>4}-{d:0>2}-{d:0>2} {d:0>2}:{d:0>2}:{d:0>2}\x1b[0m ", .{ time.year, time.month, time.day, time.hour, time.minute, time.second }) catch return;
    nosuspend stderr.print("{s} ", .{level_to_string(level)}) catch return;
    nosuspend stderr.print(format ++ "\n", args) catch return;
}

fn level_to_string(comptime level: std.log.Level) []const u8 {
    return switch (level) {
        .err => "\x1b[31mERROR\x1b[0m",
        .warn => "\x1b[33mWARNING\x1b[0m",
        .info => "\x1b[34mINFO\x1b[0m",
        .debug => "\x1b[35mDEBUG\x1b[0m",
    };
}
