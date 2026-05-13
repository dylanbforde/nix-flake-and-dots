## 2024-05-13 - Missing PAM integration for NixOS Screen Lockers
**Vulnerability:** The active screen locker (`hyprlock`) lacked explicit PAM integration (`security.pam.services.hyprlock = { };`), leading to authentication failure (either bypassing the lock entirely or locking out users).
**Learning:** In NixOS, screen lockers are not automatically granted PAM authentication rights. They require explicit configuration. Omitting this configuration is a critical security vulnerability for any desktop configuration using screen lockers.
**Prevention:** Always verify that newly added or active screen lockers (like `hyprlock`, `swaylock`) are explicitly defined in `security.pam.services` in the corresponding NixOS configuration file.
