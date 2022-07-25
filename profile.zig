const PromptSettings = struct {
    print_cwd: bool,
};

pub const Profile = struct {
    prompt_settings: PromptSettings,

    pub fn default() Profile {
        return .{
            .prompt_settings = .{
                .print_cwd = true,
            },
        };
    }
};
