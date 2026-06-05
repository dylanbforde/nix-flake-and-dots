## 2024-06-05 - Missing PAM authentication rights for screen locker
**Vulnerability:** Screen locker binaries (e.g., `hyprlock`) are not automatically granted PAM authentication rights in NixOS. Omitting this declaration causes authentication to fail closed (lockout) or fail open (bypass).
**Learning:** `hyprlock` was configured as the active screen locker via `hypridle`, but lacked the explicit `security.pam.services.hyprlock = {};` declaration in `modules/desktop/hyprland/default.nix`.
**Prevention:** Always verify that every configured screen locker binary explicitly possesses a corresponding PAM service declaration to ensure secure operation and prevent lockouts.
