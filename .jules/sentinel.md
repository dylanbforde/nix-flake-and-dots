## 2025-01-20 - Hardened OpenSSH Configuration
**Vulnerability:** OpenSSH default settings could allow root login or password authentication, posing a security risk.
**Learning:** In NixOS, OpenSSH should be explicitly hardened by setting `PermitRootLogin = "no"` and `PasswordAuthentication = false` in `services.openssh.settings` as a defense-in-depth measure.
**Prevention:** Ensure explicit configuration of these settings for all OpenSSH service deployments.
