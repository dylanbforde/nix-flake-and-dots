## 2026-05-28 - Fix PAM Authentication for Active Screen Locker
**Vulnerability:** Screen locker binaries (e.g., `hyprlock`) were not automatically granted PAM authentication rights in NixOS, and the repository had a duplicate entry for `swaylock` instead of correctly covering `hyprlock`. This caused authentication to fail closed (lockout) or fail open.
**Learning:** In NixOS, any newly added or active screen locker must be explicitly granted PAM authentication rights (`security.pam.services.<locker> = {};`). Both old (`swaylock`) and new (`hyprlock`) lockers that are in use must be covered.
**Prevention:** Always verify that every screen locker configured for use (e.g., in `hypridle` or keybindings) has a corresponding explicit PAM declaration in the configuration.
