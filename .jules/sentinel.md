## 2026-04-30 - Fix Missing PAM Configuration for Screen Lockers
**Vulnerability:** Screen lockers (e.g., hyprlock) in NixOS without an explicit PAM configuration fail to authenticate properly, which can lead to authentication bypass or user lockout.
**Learning:** NixOS does not automatically inherit default PAM rules for third-party screen lockers. Each locker requires explicit declaration (`security.pam.services.<locker> = {};`).
**Prevention:** Whenever a new screen locker or authentication mechanism is added to a NixOS configuration, ensure its corresponding PAM service is explicitly defined.
