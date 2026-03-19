## 2023-10-27 - [Polkit Configuration Missing]
**Vulnerability:** The system lacks polkit (`security.polkit.enable = true;`) configured for secure graphical privilege escalation.
**Learning:** Polkit is required for secure graphical privilege escalation in the Hyprland environment.
**Prevention:** Explicitly enable polkit rather than relying on insecure passwordless sudo or root shells for GUI applications.

## 2023-10-27 - [Firewall Configuration Missing]
**Vulnerability:** The firewall state does not explicitly define security boundaries and mechanisms (`networking.firewall.enable = true;`).
**Learning:** Explicitly configuring the firewall is required as a defense-in-depth measure.
**Prevention:** Always explicitly define security boundaries rather than relying on framework or OS defaults.
