## 2024-05-15 - [Missing PAM Authentication Configuration for Screen Lockers]
**Vulnerability:** Screen locker `hyprlock` is missing explicit PAM service configuration (`security.pam.services.hyprlock = {};`).
**Learning:** In NixOS, screen lockers are not automatically granted PAM authentication rights. Missing this explicit declaration causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Always explicitly define security boundaries and authentication mechanisms for screen lockers in NixOS configurations.
