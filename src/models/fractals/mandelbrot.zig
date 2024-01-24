const std = @import("std");
const Self = @This();
const Complex = @import("../complex.zig");
const PixelIntensity = @import("../pixel_intensity.zig");

pub fn to_string(_: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Mandelbrot {{}}", .{});
}

pub fn generate(_: Self, max_iterations: u32, x: f64, y: f64) PixelIntensity {
    var z = Complex.init(0.0, 0.0);
    const c = Complex.init(x, y);

    var i: u32 = 0;
    while (i < max_iterations and z.arg_sq() < 4.0) {
        z = z.mul(z).add(c);
        i += 1;
    }

    const i_f32: f32 = @floatFromInt(i);
    const max_iterations_f32: f32 = @floatFromInt(max_iterations);

    return .{ .zn = @floatCast(z.arg_sq()), .count = i_f32 / max_iterations_f32 };
}
