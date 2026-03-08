## 2024-05-24 - Explicit Security Defaults in NixOS

**Vulnerability:** Upstream OS defaults can change silently, inadvertently weakening the system's security posture (e.g., firewall becoming disabled, or Polkit privileges escalating improperly).
**Learning:** In a declarative system like NixOS, relying on implied defaults for critical security boundaries (such as `networking.firewall.enable = true;` and `security.polkit.enable = true;`) is a risk.
**Prevention:** Always explicitly define security boundaries and mechanisms in the system configuration to ensure the intended security posture is strictly enforced, regardless of changes to upstream defaults.
