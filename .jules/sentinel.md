## 2024-06-14 - Screen Locker PAM Authentication Bypass/Lockout
**Vulnerability:** The active screen locker `hyprlock` was missing an explicit PAM service declaration in the NixOS configuration (`security.pam.services.hyprlock = {};`), while `swaylock` was duplicated.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. Omitting the explicit declaration causes authentication to fail closed (user lockout) or fail open (bypass). Both lockers must be explicitly granted PAM rights if used.
**Prevention:** Always explicitly define `security.pam.services.<locker> = {};` for any screen locker introduced into the desktop environment configuration.
