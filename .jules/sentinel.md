## 2026-06-06 - Missing PAM Configuration for hyprlock
**Vulnerability:** The `hyprlock` screen locker was not explicitly granted PAM authentication rights in `modules/desktop/hyprland/default.nix`, potentially causing authentication to fail closed (lockout) or fail open (bypass).
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require an explicit declaration (e.g., `security.pam.services.<locker> = {};`) to function securely.
**Prevention:** Always ensure explicit PAM service configurations are declared for any screen locker binaries used in the NixOS environment.
