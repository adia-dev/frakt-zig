const std = @import("std");
const U8Data = @import("../u8_data.zig");
const Point = @import("../point.zig");
const FractalDescriptor = @import("../fractals/fractal_descriptor.zig").FractalDescriptor;
const Resolution = @import("../resolution.zig");
const PixelIntensity = @import("../pixel_intensity.zig");
const Range = @import("../range.zig");
const FragmentResult = @import("fragment_result.zig");
const PixelData = @import("../pixel_data.zig");

const Self = @This();

id: U8Data,
fractal: FractalDescriptor,
max_iteration: u32,
resolution: Resolution,
range: Range,

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator,
        \\FragmentTask {{ id: {d}, fractal: {s}, max_iteration: {d}, resolution: {s}, range: {s} }}
    , .{ self.id.count, try self.fractal.to_string(allocator), self.max_iteration, try self.resolution.to_string(allocator), try self.range.to_string(allocator) });
}

pub fn perform(self: Self, writer: anytype) !FragmentResult {
    const pixel_data = self.initialize_buffers();
    try self.calculate_pixels(writer);

    const result = FragmentResult{ .id = self.id, .range = self.range, .resolution = self.resolution, .pixels = pixel_data };

    return result;
}

fn initialize_buffers(
    self: Self,
) PixelData {
    const width: u32 = @intCast(self.resolution.nx);
    const height: u32 = @intCast(self.resolution.ny);

    return PixelData{ .offset = self.id.count, .count = (width * height) };
}

fn calculate_pixels(self: Self, writer: anytype) !void {
    const width: u32 = @intCast(self.resolution.nx);
    const height: u32 = @intCast(self.resolution.ny);

    const res = width * height;

    for (0..(res)) |i| {
        const i_32: u32 = @intCast(i);
        const x: u32 = i_32 % width;
        const y: u32 = i_32 / width;

        const mapped_coords = self.map_coordinates(x, y);
        const pixel_intensity = self.calculate_fractal(mapped_coords.x, mapped_coords.y);

        // BUG: This needs to be turned into Big Endian bytes
        const le_bytes = std.mem.toBytes(pixel_intensity);

        std.log.debug("Bytes: {any}", .{le_bytes});
        std.log.debug("PixelIntensity: {any}", .{pixel_intensity});

        _ = try writer.write(&std.mem.toBytes(pixel_intensity));
    }
}

fn map_coordinates(self: Self, x: u32, y: u32) Point {
    const min = self.range.min;
    const max = self.range.max;

    var mapped_coords = Point{};

    const x_f64: f64 = @floatFromInt(x);
    const y_f64: f64 = @floatFromInt(y);

    const nx_f64: f64 = @floatFromInt(self.resolution.nx);
    const ny_f64: f64 = @floatFromInt(self.resolution.ny);

    mapped_coords.x = min.x + (x_f64 / nx_f64) * (max.x - min.x);
    mapped_coords.y = min.y + (y_f64 / ny_f64) * (max.y - min.y);

    return mapped_coords;
}

fn calculate_fractal(self: Self, x: f64, y: f64) PixelIntensity {
    return switch (self.fractal) {
        .Julia => |julia| julia.generate(self.max_iteration, x, y),
        .Mandelbrot => |mandelbrot| mandelbrot.generate(self.max_iteration, x, y),
    };
}
