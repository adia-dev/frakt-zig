const std = @import("std");
const U8Data = @import("../u8_data.zig");
const FractalDescriptor = @import("../fractals/fractal_descriptor.zig");
const Resolution = @import("../resolution.zig");
const Range = @import("../range.zig");

const Self = @This();

id: U8Data,
fractal: FractalDescriptor,
max_iteration: u32,
resolution: Resolution,
range: Range,

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator,
        \\FragmentTask {{ id: {d} }}
    , .{self.id.count});
}
