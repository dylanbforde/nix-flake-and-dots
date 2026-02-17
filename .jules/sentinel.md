## 2026-02-17 - Docker Group Privilege Escalation
**Vulnerability:** The user `dylan` was a member of the `docker` group, which grants full access to the Docker daemon socket (`/var/run/docker.sock`). This allows any process running as the user to gain root privileges on the host system without authentication.
**Learning:** Adding users to the `docker` group is a dangerous convenience pattern that bypasses the security model. Rootless Docker is a viable, secure alternative that isolates containers and does not require root privileges for the daemon.
**Prevention:** Avoid adding users to the `docker` group. Use `virtualisation.docker.rootless.enable = true` to allow users to run Docker containers securely. If system-level Docker is required, use `sudo` to audit and restrict access.
