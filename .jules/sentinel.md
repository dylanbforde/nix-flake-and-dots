## 2024-05-24 - Explicitly Define Security Boundaries
**Vulnerability:** Relying on OS or framework defaults for critical security mechanisms (like firewall and polkit) can lead to silent failures if upstream defaults change.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms rather than relying on framework or OS defaults, ensuring intended security posture.
**Prevention:** Always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) in configuration files.
