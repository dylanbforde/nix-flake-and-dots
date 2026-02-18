## 2026-02-18 - Rootless Docker Misconfiguration
**Vulnerability:** User was added to the `docker` group, granting root access via the system-wide docker socket, bypassing the security benefits of the enabled `rootless` docker configuration.
**Learning:** Enabling rootless docker in NixOS (`virtualisation.docker.rootless.enable = true`) does not automatically revoke access to the system-wide daemon if the user is explicitly added to the `docker` group.
**Prevention:** Always verify user group memberships when configuring rootless services to ensure privilege separation is maintained.
