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
