## 2026-07-03 - OpenSSH Hardening
**Vulnerability:** OpenSSH daemon enabled without explicit secure defaults, risking root login and password brute-force.
**Learning:** Relying on system default OpenSSH configurations can lead to insecure exposure; it must be hardened as a defense-in-depth measure.
**Prevention:** Explicitly disable PermitRootLogin and PasswordAuthentication when enabling OpenSSH.