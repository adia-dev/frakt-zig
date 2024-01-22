const std = @import("std");

pub const FragmentRequest = @import("fragment_request.zig");
pub const FragmentResult = @import("fragment_result.zig");
pub const FragmentTask = @import("fragment_task.zig");

pub const Fragment = union(enum) {
    FragmentTask: FragmentTask,
    FragmentRequest: FragmentRequest,
    FragmentResult: FragmentResult,

    pub fn to_string(self: Fragment, allocator: std.mem.Allocator) ![]u8 {
        return switch (self) {
            .FragmentTask => |*task| try task.to_string(allocator),
            .FragmentRequest => |*request| try request.to_string(allocator),
            .FragmentResult => |*result| try result.to_string(allocator),
        };
    }

    pub fn from_json(allocator: std.mem.Allocator, json: []const u8) !Fragment {
        return try std.json.parseFromSliceLeaky(Fragment, allocator, json, .{ .ignore_unknown_fields = true });
    }

    pub fn to_json(fragment: Fragment, writer: anytype) !void {
        try std.json.stringify(fragment, .{}, writer);
    }
};
