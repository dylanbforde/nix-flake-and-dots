## 2026-05-17 - Missing PAM configuration for active screen locker
**Vulnerability:** The primary screen locker (`hyprlock`) lacked explicit PAM authentication rights in the NixOS configuration, while `swaylock` was defined twice. Without this PAM entry, `hyprlock` fails authentication, leading to either lockout or fail-open bypass on the lock screen.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights; they require an explicit `security.pam.services.<locker> = {}` declaration to function securely.
**Prevention:** Always verify that the screen locker referenced in idle daemons and keybinds has a corresponding `security.pam.services` entry in the system configuration.
