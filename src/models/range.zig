const std = @import("std");
const Point = @import("point.zig");

const Self = @This();

min: Point,
max: Point,

pub fn init(min: Point, max: Point) Self {
    return .{
        .min = min,
        .max = max,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Range {{ min: {s}, max: {s} }}", .{ try self.min.to_string(allocator), try self.max.to_string(allocator) });
}
