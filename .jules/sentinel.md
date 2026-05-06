
## 2024-05-18 - [Missing PAM Authentication for hyprlock]
**Vulnerability:** The active screen locker (`hyprlock`) was missing explicit PAM configuration (`security.pam.services.hyprlock = {};`), while `swaylock` was defined twice. Without explicit PAM configuration, the screen locker fails closed/open resulting in authentication bypass or lockout vulnerabilities.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require an explicit declaration in the configuration to function securely. The desktop environment here actively uses both `hyprlock` and `swaylock`, so both must be explicitly granted PAM authentication rights.
**Prevention:** Always verify that every installed screen locker has a corresponding `security.pam.services.<locker> = {};` entry in the NixOS configuration.
