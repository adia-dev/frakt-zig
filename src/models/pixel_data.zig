const std = @import("std");

const Self = @This();

offset: f32,
count: f32,

pub fn init(offset: f32, count: f32) Self {
    return .{
        .offset = offset,
        .count = count,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "PixelData {{ offset: {d:.2}, count: {d:.2} }}", .{ self.offset, self.count });
}
