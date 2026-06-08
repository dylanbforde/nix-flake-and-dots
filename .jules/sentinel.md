## 2024-06-08 - [Missing PAM Authentication for Hyprlock]
**Vulnerability:** The screen locker `hyprlock` is not explicitly granted PAM authentication rights in `modules/desktop/hyprland/default.nix`, unlike `swaylock`.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require an explicit declaration in the configuration. Omitting this causes authentication to fail closed (lockout) or fail open (bypass). The configuration was previously relying on `swaylock`'s PAM entry which is explicitly there.
**Prevention:** Always verify that every custom screen locker deployed is explicitly granted PAM authentication rights via `security.pam.services.<locker> = {};`.
