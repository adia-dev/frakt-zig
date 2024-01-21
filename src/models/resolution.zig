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
