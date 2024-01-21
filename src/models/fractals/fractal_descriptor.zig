pub const Mandelbrot = @import("mandelbrot.zig");
pub const Julia = @import("julia.zig");

pub const Fractal = enum { Julia, Mandelbrot };

pub const FractalDescriptor = union(Fractal) {
    Mandelbrot: Mandelbrot,
    Julia: Julia,
    // julia
};
