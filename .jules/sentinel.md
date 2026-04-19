## 2024-04-19 - Missing Screen Locker Authentication
**Vulnerability:** The active screen locker (`hyprlock`) lacked an explicit PAM configuration entry, while entries for an unused locker (`swaylock`) were present.
**Learning:** In NixOS, screen locker binaries (like `hyprlock`) are not automatically granted PAM authentication rights. They require an explicit declaration (`security.pam.services.<locker> = {};`) in the configuration. Omitting this causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Always ensure the PAM configuration precisely matches the active screen locker binary deployed on the system.
