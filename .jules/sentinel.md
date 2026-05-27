## 2026-05-27 - Screen Locker PAM Authentication Bypass/Lockout Risk
**Vulnerability:** Screen locker binaries (e.g., `hyprlock`) were not explicitly granted PAM authentication rights (duplicate `swaylock` entry instead), which causes authentication to fail closed (lockout) or fail open (bypass).
**Learning:** In NixOS, screen lockers do not automatically inherit PAM authentication rights. Omitting explicit declaration (`security.pam.services.<locker> = {};`) introduces a critical auth bypass or user lockout vulnerability.
**Prevention:** Always verify that every active screen locker (e.g., both `swaylock` and `hyprlock` if both are used) is explicitly granted PAM configuration in the NixOS modules (e.g., `modules/desktop/hyprland/default.nix`).
