## 2024-05-20 - Explicit Security Boundaries
**Vulnerability:** System was relying on implicit upstream defaults for critical security mechanisms like the firewall and polkit, rather than explicitly defining their state.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (`networking.firewall.enable = true;` and `security.polkit.enable = true;`) to ensure the intended security posture even if upstream defaults change.
**Prevention:** Always explicitly define security boundaries in NixOS configurations instead of relying on defaults.
