## 2024-05-26 - Screen Locker Authentication Bypass/Lockout Risk
**Vulnerability:** The active screen locker `hyprlock` is not explicitly granted PAM authentication rights in the NixOS configuration. This causes authentication to fail closed (user lockout) or fail open (bypass) when attempting to unlock the screen.
**Learning:** In NixOS, screen locker binaries (e.g., `hyprlock`, `swaylock`) are not automatically granted PAM authentication rights. They require an explicit declaration (e.g., `security.pam.services.<locker> = {};`) in the configuration to function securely.
**Prevention:** Always explicitly define PAM authentication rights for any screen locker introduced into the system configuration. Ensure no duplicate entries overwrite or obscure necessary configurations.
