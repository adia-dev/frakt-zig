const std = @import("std");
const Self = @This();
const Complex = @import("../complex.zig");
const PixelIntensity = @import("../pixel_intensity.zig");

c: Complex,
divergence_threshold_square: f64,

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator, "Julia {{ c: {s}, divergence_threshold_square: {:.2} }}", .{ try self.c.to_string(allocator), self.divergence_threshold_square });
}

pub fn generate(self: Self, max_iterations: u32, x: f64, y: f64) PixelIntensity {
    var z = Complex.init(x, y);

    var i: u32 = 0;
    while (i < max_iterations and z.arg_sq() < self.divergence_threshold_square) {
        z = z.mul(z).add(self.c);
        i += 1;
    }

    const i_f32: f32 = @floatFromInt(i);
    const max_iterations_f32: f32 = @floatFromInt(max_iterations);

    return .{ .zn = @floatCast(z.arg_sq()), .count = i_f32 / max_iterations_f32 };
}
