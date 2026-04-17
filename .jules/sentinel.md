## 2024-04-17 - Fix screen locker PAM authentication bypass/lockout
**Vulnerability:** The `hyprlock` screen locker lacks explicit PAM service configuration. The configuration incorrectly sets up PAM for `swaylock` instead of `hyprlock`. Without PAM configuration, `hyprlock` either fails closed (lockout) or fails open (bypass).
**Learning:** Screen locker binaries (e.g., `hyprlock`, `swaylock`) in NixOS are not automatically granted PAM authentication rights and require an explicit declaration (`security.pam.services.<locker> = {};`).
**Prevention:** Always ensure that the screen locker specified in the idle manager configuration has a matching and explicit `security.pam.services` declaration in the system configuration to prevent authentication failures or bypasses.
