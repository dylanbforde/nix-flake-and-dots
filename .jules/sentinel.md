# Sentinel's Journal

## CRITICAL LEARNINGS ONLY

## 2024-03-22 - Explicit Security Boundaries
**Vulnerability:** Relying on defaults for core security features like the firewall and polkit.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) rather than relying on framework or OS defaults, ensuring intended security posture even if upstream defaults change.
**Prevention:** Always verify and explicitly set security settings instead of relying on default OS values.