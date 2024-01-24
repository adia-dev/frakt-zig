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

pub fn arg_sq(self: Self) f64 {
    return self.re * self.re + self.im * self.im;
}

pub fn sin(self: Self) Self {
    const re = self.re.sin() * self.im.cosh();
    const im = self.re.cos() * self.im.sinh();
    return .{ .re = re, .im = im };
}

pub fn add(self: Self, rhs: Self) Self {
    return Self{
        .re = self.re + rhs.re,
        .im = self.im + rhs.im,
    };
}

pub fn mul(self: Self, rhs: Self) Self {
    return .{
        .re = self.re * rhs.re - self.im * rhs.im,
        .im = self.re * rhs.im + self.im * rhs.re,
    };
}
