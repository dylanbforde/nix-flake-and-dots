## 2024-06-13 - Missing PAM Authentication for Screenlocker
**Vulnerability:** The screen locker `hyprlock` was configured to lock the screen but lacked explicit PAM authentication configuration (`security.pam.services.hyprlock = { };`), leading to potential lockout or authentication bypass.
**Learning:** In NixOS, screen locker binaries do not automatically receive PAM authentication rights; they must be explicitly declared in the configuration, otherwise they fail securely (lockout) or insecurely (bypass).
**Prevention:** Always explicitly define `security.pam.services.<locker> = {};` for any active screen locker configured in the system.
