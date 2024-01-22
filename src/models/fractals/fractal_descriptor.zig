pub const Mandelbrot = @import("mandelbrot.zig");
pub const Julia = @import("julia.zig");
const std = @import("std");

pub const Fractal = enum { Julia, Mandelbrot };

pub const FractalDescriptor = union(Fractal) {
    Mandelbrot: Mandelbrot,
    Julia: Julia,

    pub fn to_string(self: FractalDescriptor, allocator: std.mem.Allocator) ![]u8 {
        return switch (self) {
            .Mandelbrot => |*mandelbrot| try mandelbrot.to_string(allocator),
            .Julia => |*julia| try julia.to_string(allocator),
        };
    }
};
