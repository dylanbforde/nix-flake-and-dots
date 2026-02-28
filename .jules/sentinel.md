## 2025-02-28 - Missing PAM Configuration for Swaylock
**Vulnerability:** The screen locker `swaylock` was installed and configured via keybindings in Hyprland without explicit PAM (Pluggable Authentication Module) service configuration.
**Learning:** On NixOS, simply installing `swaylock` is insufficient for it to securely lock and unlock a session. Without `security.pam.services.swaylock = {};`, the locker cannot authenticate the user, preventing unlock or crashing securely (fail-closed) depending on configuration.
**Prevention:** Whenever a custom screen locker (like swaylock, swaylock-effects, gtklock, etc.) is added to a Wayland configuration on NixOS, its PAM service must be explicitly declared in the NixOS module to allow secure authentication.
