## 2024-05-24 - Fix Missing PAM Configuration for Hyprlock
**Vulnerability:** Screen locker `hyprlock` was used without explicit PAM authentication configuration in `modules/desktop/hyprland/default.nix`, relying instead on a duplicate `swaylock` configuration.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require an explicit declaration (e.g., `security.pam.services.<locker> = {};`). Omitting this causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Always ensure that any configured screen locker has a matching explicit PAM configuration in the NixOS environment.
