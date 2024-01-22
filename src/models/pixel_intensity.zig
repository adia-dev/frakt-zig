const std = @import("std");

const Self = @This();

zn: f32,
count: f32,

pub fn init(zn: f32, count: f32) Self {
    return .{
        .zn = zn,
        .count = count,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "PixelIntensity {{ zn: {d:.2}, count: {d:.2} }}", .{ self.zn, self.count });
}
