const std = @import("std");

const Self = @This();

offset: u32,
count: u32,

pub fn init(offset: u32, count: u32) Self {
    return .{
        .offset = offset,
        .count = count,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "PixelData {{ offset: {d}, count: {d} }}", .{ self.offset, self.count });
}
