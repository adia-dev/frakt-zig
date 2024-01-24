const std = @import("std");

const Self = @This();

x: f64 = 0.0,
y: f64 = 0.0,

pub fn init(x: f64, y: f64) Self {
    return .{
        .x = x,
        .y = y,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Point {{ x: {d}, y: {d} }}", .{ self.x, self.y });
}
