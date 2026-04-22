## 2026-04-22 - Missing PAM Authorization For Screen Locker
**Vulnerability:** NixOS screen lockers (like `hyprlock`) fail to authenticate users if not explicitly granted PAM authentication rights, leading to either total lockout or authentication bypass depending on the failure mode. The configuration had duplicate PAM declarations for `swaylock` but missed `hyprlock`.
**Learning:** NixOS declarative security requires explicit authentication boundary declarations. Do not assume lock binaries inherit default authentication mechanisms without checking the security module.
**Prevention:** Verify all custom display managers or screen lockers have corresponding `security.pam.services.<locker> = {};` declarations.
