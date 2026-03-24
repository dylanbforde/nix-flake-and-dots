## 2024-03-24 - Explicitly define security boundaries
**Vulnerability:** System relies on OS defaults for core security mechanisms (firewall and polkit), which could lead to an unintended and insecure posture if upstream defaults change.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms (like `networking.firewall.enable = true;` and `security.polkit.enable = true;`).
**Prevention:** Always define core security mechanisms explicitly in configuration modules instead of relying on default values.
