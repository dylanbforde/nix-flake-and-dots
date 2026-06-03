## 2024-06-03 - Explicitly define OpenSSH configuration
**Vulnerability:** The SSH daemon configuration relied on system defaults for `PermitRootLogin`, which can silently leave the system vulnerable to root login attacks if upstream defaults change.
**Learning:** Core security boundaries and mechanisms (like `PermitRootLogin = "no";`) must be explicitly defined rather than relying on framework or OS defaults to ensure the intended security posture is maintained.
**Prevention:** Always explicitly set secure configuration values for critical services in NixOS, specifically utilizing `services.openssh.settings` for OpenSSH options to avoid deprecation warnings while ensuring security.
