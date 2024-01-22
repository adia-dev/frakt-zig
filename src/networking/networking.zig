const std = @import("std");
const net = std.net;
const json = std.json;
const ArrayList = std.ArrayList;
const models = @import("../models/models.zig");
const Fragment = @import("../models/fragments/fragments.zig").Fragment;
pub const Worker = @import("worker.zig");

pub const RawResponse = struct {
    total_size: u32 = 0,
    json_size: u32 = 0,
    buffer: std.ArrayList(u8) = undefined,

    pub fn init(allocator: std.mem.Allocator) RawResponse {
        return .{ .buffer = std.ArrayList(u8).init(allocator) };
    }
};

pub fn send_message(allocator: std.mem.Allocator, stream: *net.Stream, json_bytes: []const u8, data: ?[]const u8) !void {
    const json_size: u32 = @intCast(json_bytes.len);
    const data_size: u32 = if (data) |d| @intCast(d.len) else 0;
    const total_size: u32 = json_size + data_size;

    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit();

    var buf_writer = buffer.writer();

    try buf_writer.writeInt(u32, total_size, std.builtin.Endian.Big);
    try buf_writer.writeInt(u32, json_size, std.builtin.Endian.Big);
    try buf_writer.writeAll(json_bytes);

    if (data) |d| try buf_writer.writeAll(d);

    _ = try stream.writeAll(buffer.items);
}

pub fn send_fragment(allocator: std.mem.Allocator, stream: *net.Stream, fragment: *Fragment) !void {
    var buffer = ArrayList(u8).init(allocator);
    defer buffer.deinit();

    try fragment.to_json(buffer.writer());

    try send_message(allocator, stream, buffer.items, null);
}

pub fn read_message_raw(allocator: std.mem.Allocator, stream: *net.Stream) !RawResponse {
    var stream_reader = stream.reader();
    const total_size = try stream_reader.readInt(u32, std.builtin.Endian.Big);
    const json_size = try stream_reader.readInt(u32, std.builtin.Endian.Big);
    const data_size = total_size - json_size;

    var raw_response = RawResponse.init(allocator);
    raw_response.total_size = total_size;
    raw_response.json_size = json_size;

    var buf_writer = raw_response.buffer.writer();

    stream_reader.streamUntilDelimiter(buf_writer, 0, json_size) catch |err| switch (err) {
        error.EndOfStream, error.StreamTooLong => {},
        else => return err,
    };

    stream_reader.streamUntilDelimiter(buf_writer, 0, data_size) catch |err| switch (err) {
        error.EndOfStream, error.StreamTooLong => {},
        else => return err,
    };

    return raw_response;
}

pub fn read_fragment(allocator: std.mem.Allocator, stream: *net.Stream) !Fragment {
    const raw_response = try read_message_raw(allocator, stream);
    const json_bytes = raw_response.buffer.items[0..raw_response.json_size];
    return try Fragment.from_json(allocator, json_bytes);
}
