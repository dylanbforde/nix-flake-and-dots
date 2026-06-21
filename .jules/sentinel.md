## 2025-02-18 - Missing PAM Configuration for hyprlock
**Vulnerability:** Screen locker binary `hyprlock` is actively used but lacks explicit PAM configuration (`security.pam.services.hyprlock = {};`). A duplicate entry for `swaylock` was present instead.
**Learning:** In NixOS, screen lockers do not automatically get PAM authentication rights. Missing this declaration causes authentication to fail closed (user lockout) or fail open (bypass).
**Prevention:** Ensure every screen locker binary configured in the system has a corresponding explicit PAM service declaration. Avoid copy-paste errors that result in duplicate configurations.
