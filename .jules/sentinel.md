## 2025-02-14 - Explicitly Defining Security Boundaries
**Vulnerability:** Relying on defaults for core security configurations, leading to inconsistent firewall states and potential unauthenticated root SSH access.
**Learning:** Core security boundaries like `networking.firewall.enable`, `security.polkit.enable`, and `services.openssh.settings.PermitRootLogin` should always be defined explicitly in NixOS configuration code rather than assumed from framework defaults.
**Prevention:** Ensure new modules and features explicitly declare required security mechanisms during initial PR review.