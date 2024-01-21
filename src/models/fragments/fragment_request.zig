const std = @import("std");

const Self = @This();

worker_name: []const u8,
maximal_work_load: u32,

pub fn init(worker_name: []const u8, maximal_work_load: u32) Self {
    return .{ .worker_name = worker_name, .maximal_work_load = maximal_work_load };
}

pub fn print(self: *const Self, allocator: std.mem.Allocator) !void {
    _ = try std.fmt.allocPrint(allocator,
        \\FragmentRequest {{ worker_name: {s}, maximal_work_load: {d} }}
    , .{ self.worker_name, self.maximal_work_load });
}
