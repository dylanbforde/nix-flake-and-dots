## 2024-03-24 - Explicit Security Boundaries
**Vulnerability:** Implicit reliance on OS/NixOS defaults for critical security settings like firewall state and SSH password authentication.
**Learning:** Framework or OS defaults can silently change upstream. A core security pattern for this repository is to always explicitly define security boundaries and mechanisms.
**Prevention:** Explicitly configure security settings like `networking.firewall.enable = true;` and `services.openssh.settings.PasswordAuthentication = false;` to ensure intended security posture regardless of defaults.
