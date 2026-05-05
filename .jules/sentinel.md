## 2026-05-05 - Fix hyprlock PAM authentication bypass/lockout
**Vulnerability:** The active screen locker (`hyprlock`) lacked an explicit PAM configuration, which in NixOS causes authentication to fail closed (lockout) or fail open (bypass).
**Learning:** Screen locker binaries in NixOS are not automatically granted PAM authentication rights and require explicit declaration (`security.pam.services.<locker> = {};`).
**Prevention:** Always ensure any screen locker used in the desktop environment has a corresponding PAM service declaration in the NixOS configuration.
