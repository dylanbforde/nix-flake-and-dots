## 2024-05-18 - Explicit Security Boundaries
**Vulnerability:** Silent reliance on upstream framework or OS defaults for security mechanisms like firewalls and polkit authorization.
**Learning:** Depending on implicit defaults creates a brittle security posture. If upstream defaults change, the application may inadvertently become vulnerable without any code changes in this repository.
**Prevention:** Always explicitly define security boundaries and mechanisms (e.g., `networking.firewall.enable = true;`, `security.polkit.enable = true;`) in the configuration files to ensure the intended security posture is maintained regardless of upstream changes.
