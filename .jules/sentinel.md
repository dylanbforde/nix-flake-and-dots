## 2025-02-23 - Hardened OpenSSH Defaults in NixOS
**Vulnerability:** The NixOS OpenSSH configuration relied on system defaults, leaving password authentication and root login potentially enabled, which significantly increases the risk of brute-force attacks and unauthorized access.
**Learning:** In NixOS configurations, it's critical to proactively harden services by explicitly defining security-sensitive settings (like `PermitRootLogin` and `PasswordAuthentication`) rather than trusting upstream or module defaults.
**Prevention:** Always verify and explicitly set secure defaults within the `services.openssh.settings` attribute when enabling SSH, adopting a defense-in-depth approach.
