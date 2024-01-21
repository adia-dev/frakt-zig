const std = @import("std");

pub const FragmentRequest = @import("fragment_request.zig");
pub const FragmentResult = @import("fragment_result.zig");
pub const FragmentTask = @import("fragment_task.zig");

pub const Fragment = union(enum) {
    FragmentTask: FragmentTask,
    FragmentRequest: FragmentRequest,
    FragmentResult: FragmentResult,

    pub fn print(self: Fragment, allocator: std.mem.Allocator) !void {
        switch (self) {
            .FragmentTask => |*task| {
                try task.print(allocator);
            },
            .FragmentRequest => |*request| {
                try request.print(allocator);
            },
        }
    }
};
