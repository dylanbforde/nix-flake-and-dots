## 2024-05-24 - Missing PAM Authentication Declaration for Screen Locker
**Vulnerability:** The active screen locker (`hyprlock`) was missing its explicit PAM service declaration in the NixOS configuration (`security.pam.services.hyprlock = {};`). It was mistakenly duplicated as `swaylock`.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. Omitting the explicit declaration causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Always ensure that any newly added or active screen locker in the configuration has a corresponding `security.pam.services.<locker> = {};` entry. Use careful string replacement to avoid duplicating or deleting existing entries.
