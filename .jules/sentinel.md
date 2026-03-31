## 2024-05-24 - Explicit Security Boundaries

**Vulnerability:** System configurations relied on NixOS default security boundaries (like implicitly trusting the firewall or falling back to rootless/unrestricted methods for graphical escalation).
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) rather than relying on framework or OS defaults. This ensures intended security posture even if upstream defaults change.
**Prevention:** Always explicitly define security features like firewalls and polkit in core module files to enforce a defense-in-depth posture, ensuring that an update or upstream change won't inadvertently disable critical protection layers.
