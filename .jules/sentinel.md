## 2026-06-09 - Missing PAM Configuration for Screen Lockers
**Vulnerability:** Missing PAM explicit declaration for `hyprlock` screen locker.
**Learning:** In NixOS, screen locker binaries like `hyprlock` and `swaylock` are not automatically granted PAM authentication rights. Omitting the explicit declaration (`security.pam.services.<locker> = {};`) causes authentication to either fail closed (user lockout) or fail open (authentication bypass).
**Prevention:** Always ensure any screen locker binary used in the desktop environment has a corresponding `security.pam.services.<locker> = {};` entry in the NixOS configuration.
