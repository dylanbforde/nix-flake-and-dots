## 2024-05-20 - Missing PAM Configuration for Screen Locker
**Vulnerability:** The NixOS configuration used `hyprlock` as the primary screen locker but failed to explicitly declare it in the PAM services list (`security.pam.services.hyprlock = {};`). It incorrectly duplicated `swaylock`.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. If the explicit declaration is omitted, authentication fails closed (lockout) or fails open (bypass depending on configuration). This is a highly specific NixOS security posture feature.
**Prevention:** Always verify that every screen locker binary used (e.g., `hyprlock`, `swaylock`) has a corresponding `security.pam.services.<locker> = {};` entry in the NixOS configuration.
