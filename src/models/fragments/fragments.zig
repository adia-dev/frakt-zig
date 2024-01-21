const std = @import("std");

pub const FragmentRequest = @import("fragment_request.zig");
pub const FragmentTask = @import("fragment_task.zig");

pub const Fragment = union(enum) {
    // task: FragmentTask,
    FragmentRequest: FragmentRequest,

    pub fn print(self: Fragment, allocator: std.mem.Allocator) !void {
        switch (self) {
            .FragmentRequest => |*request| {
                try request.print(allocator);
            },
        }
    }
};
