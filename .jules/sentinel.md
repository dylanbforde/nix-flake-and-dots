## 2024-05-14 - Explicit Security Boundaries
**Vulnerability:** System configurations missing explicit Polkit and Firewall definitions, relying on undocumented or changing OS defaults.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`) rather than relying on framework or OS defaults.
**Prevention:** Explicitly define security boundaries like firewall and polkit to ensure intended security posture even if upstream defaults change.
