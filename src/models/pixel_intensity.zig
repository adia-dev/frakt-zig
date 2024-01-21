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
