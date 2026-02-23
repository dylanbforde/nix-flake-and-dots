# Sentinel Journal

## 2026-02-23 - Rootless Docker Privilege Escalation
**Vulnerability:** User `dylan` was in the `docker` group, which grants access to the rootful Docker socket (`/var/run/docker.sock`), effectively providing root privileges without authentication.
**Learning:** Rootless Docker (`virtualisation.docker.rootless.enable = true`) isolates containers per-user. Adding the user to the `docker` group bypasses this isolation and exposes the system-wide root daemon.
**Prevention:** Remove users from the `docker` group when using rootless Docker. Ensure they interact with their user-specific daemon.
