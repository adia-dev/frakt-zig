const std = @import("std");
const U8Data = @import("../u8_data.zig");
const Resolution = @import("../resolution.zig");
const Range = @import("../range.zig");
const PixelData = @import("../pixel_data.zig");

const Self = @This();

id: U8Data,
resolution: Resolution,
range: Range,
pixels: PixelData,

pub fn to_string(self: *const Self, allocator: std.mem.Allocator) ![]u8 {
    return try std.fmt.allocPrint(allocator,
        \\FragmentResult {{ id: {d} }}
    , .{self.id.count});
}
