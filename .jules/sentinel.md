## 2025-02-17 - Missing PAM Configuration for Screen Lockers
**Vulnerability:** The `hyprlock` screen locker was actively configured and used (via `hypridle` and keybinds) but lacked explicitly declared PAM authentication permissions (`security.pam.services.hyprlock = {};`).
**Learning:** In NixOS, screen locker binaries (e.g., `hyprlock`, `swaylock`) are not automatically granted PAM authentication rights. They require explicit declaration in the configuration. Omitting this causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Whenever adding or configuring a new screen locker or display manager in a NixOS configuration, strictly ensure the corresponding `security.pam.services.<locker> = {};` entry is also defined.
