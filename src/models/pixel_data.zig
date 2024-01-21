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
