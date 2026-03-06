## 2024-05-18 - Missing Explicit Security Configurations
**Vulnerability:** Defense-in-depth mechanisms (Firewall and Polkit) were implicitly configured or missing entirely in the NixOS modules (`modules/networking/default.nix` and `modules/core/system.nix`).
**Learning:** In highly declarative environments like NixOS, relying on framework or OS defaults for critical security mechanisms is an anti-pattern. If defaults change in upstream `nixpkgs`, the system might be left exposed silently. Furthermore, without explicit configuration, other engineers cannot determine the intended security posture.
**Prevention:** Always explicitly define security boundaries and mechanisms (`networking.firewall.enable = true;`, `security.polkit.enable = true;`). Treat "implicit security" as "no security".
