const std = @import("std");
const Self = @This();
const Complex = @import("../complex.zig");

pub fn generate(self: *Self, x: f64, y: f64) f64 {
    _ = self;
    _ = x;
    _ = y;

    return 1.0;
}

pub fn to_string(_: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Mandelbrot {{}}", .{});
}
