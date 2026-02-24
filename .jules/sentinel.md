## 2026-02-24 - Privilege Escalation via Docker Group
**Vulnerability:** User `dylan` was in the `docker` group while `virtualisation.docker.rootless.enable = true` was set.
**Learning:** Adding a user to the `docker` group grants root-equivalent privileges, bypassing the security benefits of rootless Docker configuration.
**Prevention:** Do not add users to the `docker` group. Rely on rootless Docker (enabled via `virtualisation.docker.rootless.enable = true`) which allows unprivileged users to run containers safely.
