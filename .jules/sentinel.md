## 2024-05-23 - Screen Locker PAM Authentication Bypass / Lockout

**Vulnerability:** The active screen locker `hyprlock` (configured via `hypridle`) was not granted PAM configuration rights (`security.pam.services.hyprlock = {};`). In NixOS, this either causes an authentication bypass (failing open) or a lockout (failing closed).

**Learning:** NixOS requires explicit PAM declarations for all active screen locker binaries to function securely, even if they are invoked indirectly via tools like `hypridle`. Duplicated entries for an inactive or alternate locker (like `swaylock`) don't inherit to the active one.

**Prevention:** Always verify that every screen locker binary used in the environment (e.g., `hyprlock`, `swaylock`) has a corresponding `security.pam.services.<locker> = {};` entry in the NixOS configuration.
