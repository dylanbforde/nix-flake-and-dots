## 2024-05-24 - Explicitly define SSH security boundaries
**Vulnerability:** OpenSSH server did not explicitly define the root login policy, leaving it reliant on upstream OS defaults, which might unexpectedly change or differ across platforms.
**Learning:** Security posture (such as SSH daemon settings) should be explicitly defined rather than implicitly trusted from defaults to maintain a verifiable secure state.
**Prevention:** Always explicitly define critical security configuration attributes in NixOS modules, such as `services.openssh.settings.PermitRootLogin = "no"`.