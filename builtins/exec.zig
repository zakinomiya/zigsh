const std = @import("std");
const BuiltinCmd = @import("../cmd.zig").BuiltinCmd;

fn execute(program_name: []const u8, args: [][]const u8, allocator: std.mem.Allocator) u8 {
    var al = std.ArrayList([]const u8).init(allocator);
    al.append(program_name) catch unreachable;
    al.appendSlice(args) catch unreachable;
    defer al.deinit();
    const env_map = std.process.getEnvMap(allocator) catch unreachable;

    const res = std.ChildProcess.exec(.{
        .allocator = allocator,
        .argv = al.toOwnedSlice(),
        .env_map = &env_map,
    }) catch |err| {
        std.debug.print("exec: {s}\n", .{err});
        return 1;
    };

    std.debug.print("{s}\n", .{res.stdout});

    return 0;
}

pub const exec = BuiltinCmd{
    .name = "",
    .execFn = execute,
};
