## 2024-05-24 - Fix missing PAM config for hyprlock
**Vulnerability:** Screen locker `hyprlock` was missing explicit PAM authentication declaration (`security.pam.services.hyprlock = {}`), failing closed and causing user lockouts.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require an explicit declaration in the configuration to function securely; omitting this causes authentication to fail closed (lockout) or fail open (bypass).
**Prevention:** Always ensure any screen locker binary used has a corresponding `security.pam.services.<locker> = {}` entry in the NixOS module configuration.
