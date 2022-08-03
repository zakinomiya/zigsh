const std = @import("std");

pub const Env = struct {
    allocator: std.mem.Allocator,
    env: std.StringHashMap([]u8),

    pub fn init(allocator: std.mem.Allocator) Env {
        return Env{
            .allocator = allocator,
            .env = std.StringHashMap([]u8).init(allocator),
        };
    }

    pub fn initEnv(self: Env) void {

    }

    pub fn deinit(self: Env) void {
        self.env.deinit();
    }
};
