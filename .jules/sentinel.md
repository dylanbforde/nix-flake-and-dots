## 2024-05-10 - Explicit PAM Authorization for hyprlock
**Vulnerability:** `hyprlock` was the active screen locker (configured via `hypridle`) and had keybinds (`$mod + L`), but its PAM module was not explicitly enabled. In NixOS, this results in failing authentication, either locking out the user or failing open.
**Learning:** In NixOS, screen locker binaries (like `hyprlock` and `swaylock`) are not automatically granted PAM authentication rights. They require an explicit declaration (`security.pam.services.<locker> = {};`) in the configuration.
**Prevention:** Whenever a new screen locker or PAM-dependent graphical application is added, explicitly ensure a `security.pam.services.<service>` entry exists.
