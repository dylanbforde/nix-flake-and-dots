## 2024-05-14 - Explicit Security Boundaries in NixOS
**Vulnerability:** Core security services (firewall, polkit, ssh settings) were missing explicit configurations, implicitly relying on defaults.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) rather than relying on framework or OS defaults, ensuring intended security posture even if upstream defaults change.
**Prevention:** Always explicitly define core security boundaries in NixOS configurations.
