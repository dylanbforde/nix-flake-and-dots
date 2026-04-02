## 2026-04-02 - Explicitly define security boundaries
**Vulnerability:** Core security boundaries like `networking.firewall.enable` and `security.polkit.enable` were not explicitly defined, leaving the system to rely on default behavior.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms. Relying on framework or OS defaults can lead to an unintended security posture if upstream defaults change.
**Prevention:** Always set explicit boolean values for security-critical options (e.g., firewall, polkit, etc.) in the NixOS modules rather than assuming default enablement.
