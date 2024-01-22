const std = @import("std");

const Self = @This();

re: f64,
im: f64,

pub fn init(re: f64, im: f64) Self {
    return .{
        .re = re,
        .im = im,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Complex {{ re: {d:.3}, im: {d:.3} }}", .{ self.re, self.im });
}
