const std = @import("std");

const Self = @This();

nx: u16,
ny: u16,

pub fn init(nx: u16, ny: u16) Self {
    return .{
        .nx = nx,
        .ny = ny,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Resolution {{ nx: {d}, ny: {d} }}", .{ self.nx, self.ny });
}
