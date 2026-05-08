## 2024-05-24 - Missing PAM Auth Config for Screen Lockers
**Vulnerability:** The active screen locker `hyprlock` was missing an explicit PAM authentication definition (`security.pam.services.hyprlock = {};`), while the secondary locker `swaylock` was duplicated.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require an explicit declaration to function securely. Omitting this causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Always verify that any screen locker configured for the desktop environment has a corresponding `security.pam.services.<locker> = {};` entry in the system configuration.
