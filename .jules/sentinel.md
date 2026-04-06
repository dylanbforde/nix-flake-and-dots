## 2024-04-06 - Explicit Security Boundaries

**Vulnerability:** Core security mechanisms (firewall, polkit, ssh root login restrictions) were missing explicit configurations, implicitly trusting upstream or OS defaults.
**Learning:** Relying on defaults is risky as they can change without notice. Explicitly defining security controls like `networking.firewall.enable = true;`, `security.polkit.enable = true;`, and `services.openssh.settings.PermitRootLogin = "no";` creates a defined defense-in-depth posture that persists regardless of OS updates.
**Prevention:** Always explicitly define security boundaries and mechanisms rather than relying on framework or OS defaults. Ensure PRs adding features that could elevate privileges explicitly define the required security frameworks.
