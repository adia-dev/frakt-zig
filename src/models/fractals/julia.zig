const std = @import("std");
const Self = @This();
const Complex = @import("../complex.zig");

c: Complex,
divergence_threshold_square: f64,

pub fn generate(self: *Self, x: f64, y: f64) f64 {
    _ = self;
    _ = x;
    _ = y;

    return 1.0;
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Julia {{ c: {s}, divergence_threshold_square: {:.2} }}", .{ try self.c.to_string(allocator), self.divergence_threshold_square });
}
