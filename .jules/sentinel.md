## 2026-05-29 - [Fix hyprlock PAM authentication bypass risk]
**Vulnerability:** Missing `security.pam.services.hyprlock = { };` entry in `modules/desktop/hyprland/default.nix`.
**Learning:** In NixOS, screen locker binaries (e.g., `hyprlock`) are not automatically granted PAM authentication rights. Omitting explicit declaration causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Ensure explicit PAM service declarations are included for all screen lockers added to the system.
