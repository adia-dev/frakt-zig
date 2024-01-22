// \x1b[30m	foreground black
// \x1b[31m	foreground red
// \x1b[32m	foreground green
// \x1b[33m	foreground yellow
// \x1b[34m	foreground blue
// \x1b[35m	foreground magenta
// \x1b[36m	foreground cyan
// \x1b[37m	foreground white
// \x1b[40m	background black
// \x1b[41m	background red
// \x1b[42m	background green
// \x1b[43m	background yellow
// \x1b[44m	background blue
// \x1b[45m	background magenta
// \x1b[46m	background cyan
// \x1b[47m	background white

pub const AnsiiColorCode = enum {
    reset,
    foreground_black,
    foreground_red,
    foreground_green,
    foreground_yellow,
    foreground_blue,
    foreground_magenta,
    foreground_cyan,
    foreground_white,
    background_black,
    background_red,
    background_green,
    background_yellow,
    background_blue,
    background_magenta,
    background_cyan,
    background_white,
    count,
};

// TODO: REFACTOR THISSSSS

pub fn red(comptime base_format: []const u8, args: anytype, comptime callback: fn (comptime format: []const u8, args: anytype) void) void {
    const colored_format = "\x1b[31m" ++ base_format ++ "\x1b[0m";
    callback(colored_format, args);
}

pub fn green(comptime base_format: []const u8, args: anytype, comptime callback: fn (comptime format: []const u8, args: anytype) void) void {
    const colored_format = "\x1b[32m" ++ base_format ++ "\x1b[0m";
    callback(colored_format, args);
}

pub fn yellow(comptime base_format: []const u8, args: anytype, comptime callback: fn (comptime format: []const u8, args: anytype) void) void {
    const colored_format = "\x1b[33m" ++ base_format ++ "\x1b[0m";
    callback(colored_format, args);
}

pub fn grey(comptime base_format: []const u8, args: anytype, comptime callback: fn (comptime format: []const u8, args: anytype) void) void {
    const colored_format = "\x1b[37m" ++ base_format ++ "\x1b[0m";
    callback(colored_format, args);
}
