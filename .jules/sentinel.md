## 2025-03-05 - Missing Polkit Authorization in Wayland
**Vulnerability:** The NixOS configuration uses the Hyprland Wayland compositor but was missing explicit Polkit activation (`security.polkit.enable = true;`).
**Learning:** In Wayland environments, unlike X11, standard prompt mechanisms for GUI privilege escalation often require Polkit. Without it, users may resort to insecure workarounds like passwordless `sudo` or running GUI apps completely as root to bypass permission issues.
**Prevention:** Always explicitly enable and configure Polkit in Wayland environments for granular, secure authorization workflows.
