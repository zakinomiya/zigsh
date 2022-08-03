const PromptSettings = struct {
    print_cwd: bool,
};

pub const Profile = struct {
    prompt_settings: PromptSettings,

    pub fn init() Profile {
        return Profile.default();
    }

    fn default() Profile {
        return .{
            .prompt_settings = .{
                .print_cwd = true,
            },
        };
    }
};
