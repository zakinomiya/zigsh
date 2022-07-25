const std = @import("std");

pub const BuiltinCmd = struct {
    name: []const u8,
    /// execFn always returns a status code and does not return errors.
    /// errors are handled inside the function and printed with suitable error messages according to their types.
    execFn: fn (program_name: []const u8, args: [][]const u8, allocator: std.mem.Allocator) u8,
};
