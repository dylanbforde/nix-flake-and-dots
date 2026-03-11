## 2024-05-24 - Explicit Security Boundaries
**Vulnerability:** Relying on framework or OS defaults for critical security mechanisms (like firewall and polkit) can lead to unintended insecure states if upstream defaults change.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) rather than relying on framework or OS defaults.
**Prevention:** Always explicitly define security features rather than assuming they are enabled by default.