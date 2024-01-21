const std = @import("std");

const Self = @This();

x: f64,
y: f64,

pub fn init(x: f64, y: f64) Self {
    return .{
        .x = x,
        .y = y,
    };
}
