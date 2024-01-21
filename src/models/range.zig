const std = @import("std");
const Point = @import("point.zig");

const Self = @This();

min: Point,
max: Point,

pub fn init(min: Point, max: Point) Self {
    return .{
        .min = min,
        .max = max,
    };
}
