## 2024-04-24 - [Missing PAM Authentication for Screen Locker]
**Vulnerability:** The active screen locker (`hyprlock`) was missing explicit PAM configuration (`security.pam.services.hyprlock = {};`), while an inactive/duplicate entry for `swaylock` existed.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. Omitting the explicit declaration causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Always ensure any active screen locker defined in configuration (e.g., via `hypridle`) has a corresponding `security.pam.services.<locker> = {};` entry.
