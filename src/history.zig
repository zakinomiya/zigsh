const std = @import("std");
const Profile = @import("./profile.zig").Profile;

pub const History = struct {
    buf: std.ArrayList(u8),
    profile: *Profile,

    pub fn init(allocator: std.mem.Allocator, profile: *Profile) History {
        return History{
            .buf = std.ArrayList(u8).init(allocator),
            .profile = Profile.default(),
        };
    }
};
