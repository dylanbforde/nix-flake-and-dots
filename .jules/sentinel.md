## 2024-05-28 - Missing PAM Configuration for hyprlock
**Vulnerability:** The screen locker `hyprlock` is used by the desktop environment but lacked an explicit PAM configuration declaration (`security.pam.services.hyprlock = {};`), unlike `swaylock`. This causes the authentication process to fail.
**Learning:** In NixOS, screen lockers are not automatically granted PAM authentication rights. Without explicit definitions, locker binaries fail securely (lockout) or insecurely (bypass). Both lockers must be configured if both are in use.
**Prevention:** Whenever adding or configuring a new lock screen application in NixOS configurations, always ensure an explicit PAM service entry is added for the executable.
