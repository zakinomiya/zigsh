const std = @import("std");
const BuiltinCmd = @import("../cmd.zig").BuiltinCmd;

fn changeDirectory(program_name: []const u8, args: [][]const u8, allocator: std.mem.Allocator) u8 {
    _ = program_name;
    const to_dir = if (args.len > 0) args[0] else "/Users/zaki/";
    std.os.chdir(to_dir) catch |err| switch (err) {
        error.FileNotFound => {
            std.debug.print("cd: no such file or directory {s}\n", .{to_dir});
        },
        // TODO
        // AccessDenied,
        // FileSystem,
        // SymLinkLoop,
        // NameTooLong,
        // FileNotFound,
        // SystemResources,
        // NotDir,
        // BadPathName,
        else => {
            std.debug.print("cd: error happened {s}\n", .{to_dir});
        },
    };

    var cur_dir = std.process.getCwdAlloc(allocator) catch unreachable;
    defer allocator.free(cur_dir);
    std.debug.print("{s}\n", .{cur_dir});
    return 0;
}

pub const cd = BuiltinCmd{
    .name = "cd",
    .execFn = changeDirectory,
};
