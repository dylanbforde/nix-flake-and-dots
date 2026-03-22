## 2025-02-12 - Explicit Security Boundaries
**Vulnerability:** System configurations relied on implicit security defaults (e.g., firewall configuration and Polkit for secure graphical privilege escalation not explicitly enabled).
**Learning:** In declarative configurations like NixOS, it's critical to define security boundaries explicitly (`networking.firewall.enable = true;`, `security.polkit.enable = true;`) to avoid relying on upstream or framework defaults that might change or differ from the intended security posture.
**Prevention:** Always explicitly define security mechanisms and boundaries rather than relying on assumed default values.
