## 2024-05-18 - [Defense in Depth] Explicit Security Boundaries in NixOS

**Vulnerability:** Core security mechanisms like the firewall (`networking.firewall.enable`) and Polkit (`security.polkit.enable`) were implicitly relying on OS or upstream framework defaults rather than being explicitly declared.
**Learning:** In declarative systems like NixOS, relying on defaults for critical security boundaries introduces the risk that upstream changes could silently disable these protections. For example, if a future NixOS release changes the default firewall state or if Hyprland stops pulling in Polkit by default, the system would become vulnerable without any code changes in this repository.
**Prevention:** Always explicitly define core security boundaries (`networking.firewall.enable = true;`, `security.polkit.enable = true;`, etc.) in the system configuration to ensure the intended security posture is maintained regardless of upstream defaults.
