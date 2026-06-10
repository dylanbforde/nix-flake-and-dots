## 2024-06-10 - Screen Locker PAM Authentication Missing
**Vulnerability:** Screen locker `hyprlock` was configured as the active screen locker but lacked explicit PAM authentication rights in `modules/desktop/hyprland/default.nix`.
**Learning:** In NixOS, screen locker binaries do not automatically receive PAM authentication rights. They require an explicit declaration (`security.pam.services.<locker> = {};`) to function securely; otherwise, they fail closed or open.
**Prevention:** Always verify that any newly added screen locker has a corresponding PAM service declaration in the NixOS configuration.
