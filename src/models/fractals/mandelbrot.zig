const Self = @This();
const Complex = @import("../complex.zig");

c: Complex,

pub fn generate(self: *Self, x: f64, y: f64) f64 {
    _ = self;
    _ = x;
    _ = y;

    return 1.0;
}
