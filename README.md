# Mash

A toy shell implementation in the Zig programming language.

## to-be-implemented features  

- [ ] read profile from .mashrc, .mash_profile, etc.
- [ ] enable history and can go back and forward with arrow keys
- [ ] mode vi, emacs

## Notes on shell internals

- Bash sources `/etc/profile` in its initialisation phase, and `/etc/profile` executes `path_helper` (`/usr/libexec/path_helper` on my environment), which is a command to set PATH environment variable.
