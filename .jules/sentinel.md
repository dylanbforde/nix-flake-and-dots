## 2026-04-04 - Enforce Explicit Security Boundaries
**Vulnerability:** Implicit reliance on framework or OS defaults for security mechanisms like firewall, Polkit, and SSH configurations.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) rather than relying on framework or OS defaults, ensuring intended security posture even if upstream defaults change.
**Prevention:** Always explicitly define critical security boundaries such as firewall rules, SSH restrictions (e.g., PermitRootLogin), and privilege escalation frameworks (Polkit) in NixOS configuration modules.
