## 2025-04-10 - [Missed PAM Config for Screen Locker]
**Vulnerability:** The legacy `swaylock` PAM configuration was left behind instead of configuring `hyprlock` for PAM authentication, leading to potentially broken screen locking and failure to authenticate on unlock.
**Learning:** When migrating between screen lockers (like swaylock to hyprlock) on NixOS, it's critical to also migrate the `security.pam.services.<locker> = {};` configuration, as PAM won't automatically permit a new locker application.
**Prevention:** Always verify PAM module configurations when changing authentication-related or locking software. Ensure old entries are removed and the new one matches the actual binary name exactly.
