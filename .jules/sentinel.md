## 2024-04-01 - [Missing Polkit Security Boundary]
**Vulnerability:** The NixOS configuration lacked an explicit definition of `security.polkit.enable = true;`.
**Learning:** Polkit is required for secure graphical privilege escalation in Wayland/Hyprland environments. Without it, users may fall back to insecure workarounds like passwordless sudo or running GUI applications directly as root.
**Prevention:** Always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) rather than relying on framework or OS defaults, ensuring intended security posture even if upstream defaults change.
