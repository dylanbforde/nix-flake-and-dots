## 2024-05-18 - Missing PAM Authentication for Screen Locker
**Vulnerability:** The active screen locker (`hyprlock`, configured via `hypridle`) lacked an explicit PAM configuration declaration (`security.pam.services.hyprlock = {};`). The configuration redundantly defined PAM rules for `swaylock` twice instead.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. Omitting the explicit declaration causes the locker to fail closed (locking users out) or fail open depending on configuration.
**Prevention:** Whenever a new screen locker (like `hyprlock`) is introduced or switched to, verify that the corresponding PAM authentication rights are explicitly granted in the security configurations.
