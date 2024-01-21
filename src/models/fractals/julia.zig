const Self = @This();
const Complex = @import("../complex.zig");

c: Complex,
divergence_threshold_square: f64,

pub fn generate(self: *Self, x: f64, y: f64) f64 {
    _ = self;
    _ = x;
    _ = y;

    return 1.0;
}
