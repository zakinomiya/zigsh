const std = @import("std");
const BuiltinCmd = @import("./cmd.zig").BuiltinCmd;
const exec = @import("./builtins/exec.zig").exec;
const cd = @import("./builtins/cd.zig").cd;
const Profile = @import("./profile.zig").Profile;

const max_line_length: usize = 4095;

fn readLine(reader: anytype, buf: []u8) !?[]u8 {
    return try reader.readUntilDelimiterOrEof(buf, '\n');
}

pub const Shell = struct {
    profile: Profile,
    builtin_commands: []const BuiltinCmd,
    exec: BuiltinCmd,
    cwd: *[]const u8,
    allocator: std.mem.Allocator,

    fn getCmd(self: Shell, program_name: []const u8) *const BuiltinCmd {
        for (self.builtin_commands) |cmd| {
            if (std.mem.eql(u8, cmd.name, program_name)) {
                return &cmd;
            }
        }
        return &self.exec;
    }

    fn getCwd(self: Shell) ![]u8 {
        var cur_dir = try std.process.getCwdAlloc(self.allocator);
        return cur_dir;
    }

    fn printPrompt(self: Shell) void {
        var array_list = std.ArrayList(u8).init(self.allocator);
        defer array_list.deinit();

        if (self.profile.prompt_settings.print_cwd) {
            array_list.appendSlice(self.cwd.*[0..]) catch unreachable;
        }
        std.debug.print("{s} > ", .{array_list.toOwnedSlice()});
    }

    fn mainLoop(self: Shell, reader: anytype) !void {
        while (true) {
            self.cwd.* = try self.getCwd();
            self.printPrompt();

            var buf: [max_line_length]u8 = undefined;
            const line = readLine(reader, &buf) catch |err| switch (err) {
                error.StreamTooLong => {
                    std.debug.print("command too long.\n", .{});
                    continue;
                },
                else => {
                    std.debug.print("ERR: {s}\n", .{err});
                    continue;
                },
            };
            if (line == null) continue;

            var l = line.?;
            var args_list = std.ArrayList([]const u8).init(self.allocator);
            defer args_list.deinit();

            var token_iterator = std.mem.tokenize(u8, l, " ");
            const program_name = token_iterator.next() orelse continue;

            while (token_iterator.next()) |token| {
                try args_list.append(token);
            }

            _ = self.getCmd(program_name)
                .execFn(program_name, args_list.items, self.allocator);
        }
    }
};

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var stdin = std.io.getStdIn();
    var profile = Profile.default();

    const shell = Shell{
        .profile = profile,
        .builtin_commands = &[_]BuiltinCmd{cd},
        .exec = exec,
        .allocator = arena.allocator(),
        .cwd = &try std.process.getCwdAlloc(arena.allocator()),
    };

    try shell.mainLoop(stdin.reader());
}
