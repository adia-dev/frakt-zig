const Mandelbrot = @import("mandelbrot.zig");

pub const FractalDescriptor = union(enum) {
    mandelbrot: Mandelbrot,
    // julia
};
