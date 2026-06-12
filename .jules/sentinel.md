## 2026-06-12 - Missing PAM Authentication Service for Screen Locker
**Vulnerability:** The `hyprlock` screen locker was missing its explicit PAM authentication service declaration (`security.pam.services.hyprlock = { };`), while `swaylock` was incorrectly duplicated.
**Learning:** In NixOS, screen locker binaries do not inherit PAM authentication rights automatically. Missing this declaration causes the locker to fail closed (lockout) or fail open (bypass), leading to a critical security issue.
**Prevention:** Whenever adding or modifying screen lockers in NixOS configurations, ensure the corresponding `security.pam.services.<locker> = {};` entry is explicitly declared and unique.
