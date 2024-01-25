const std = @import("std");

const Self = @This();

count: u32,
offset: u32,

pub fn init(offset: u32, count: u32) Self {
    return .{
        .count = count,
        .offset = offset,
    };
}

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "U8Data {{ count: {d}, offset: {d} }}", .{ self.count, self.offset });
}
