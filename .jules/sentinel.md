## 2026-06-29 - Missing PAM Configuration for Screen Locker
**Vulnerability:** The `hyprlock` screen locker was active but missing an explicit PAM authentication configuration (`security.pam.services.hyprlock = { };`), leading to potential authentication bypass or lockout.
**Learning:** In NixOS, screen lockers are not automatically granted PAM authentication rights. Each locker must be explicitly declared in the configuration, even if another locker (like `swaylock`) is already configured.
**Prevention:** Ensure every screen locking utility deployed has a corresponding `security.pam.services.<locker> = { };` entry in the system configuration.
