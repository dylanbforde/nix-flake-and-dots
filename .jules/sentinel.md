## 2026-04-25 - Fix missing PAM authentication configuration for hyprlock
**Vulnerability:** The active screen locker (`hyprlock`) lacked explicit PAM configuration (`security.pam.services.hyprlock = {};`) while an inactive/secondary one (`swaylock`) had it duplicated. In NixOS, screen lockers lacking this declaration fail to authenticate, causing lockout (fail closed) or potential bypass (fail open).
**Learning:** In NixOS, PAM authentication rights are not automatically granted to screen locker binaries. Any added locker requires an explicit configuration declaration.
**Prevention:** Whenever a new screen locker or PAM-dependent tool is added to the NixOS configuration, ensure an explicit `security.pam.services.<locker> = {};` entry is defined.
