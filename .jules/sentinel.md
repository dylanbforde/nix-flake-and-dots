## 2024-03-26 - Missing Explicit Security Boundaries
**Vulnerability:** System configurations relied on OS defaults for critical security components (Firewall and Polkit).
**Learning:** Security posture in infrastructure-as-code must be explicitly declarative. Upstream defaults can change unexpectedly, leading to a degraded security posture if not explicitly defined.
**Prevention:** Always define core security boundaries (like `networking.firewall.enable` and `security.polkit.enable`) even if they mirror current defaults, to ensure defense-in-depth and resilience against upstream changes.
