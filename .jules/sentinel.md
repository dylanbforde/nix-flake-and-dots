## 2024-04-16 - Missing PAM Configuration for Active Screen Locker
**Vulnerability:** The active screen locker (`hyprlock`) lacked explicit PAM configuration in NixOS, while the legacy `swaylock` configuration was retained. This prevents `hyprlock` from authenticating users correctly, leading to potential lockout or fail-open bypass.
**Learning:** In NixOS, screen lockers are not automatically granted PAM authentication rights. Changing the screen locker binary (e.g., from `swaylock` to `hyprlock`) requires explicitly updating the corresponding `security.pam.services.<locker> = {};` configuration.
**Prevention:** Always verify that the configured PAM service exactly matches the active screen locker binary name in the desktop module.
