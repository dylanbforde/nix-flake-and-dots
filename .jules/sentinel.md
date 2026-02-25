## 2025-05-23 - Rootless Docker and Group Membership

**Vulnerability:** User `dylan` was added to the `docker` group, granting root-equivalent privileges via the Docker socket, despite `rootless` docker being enabled.
**Learning:** Enabling rootless docker does not automatically restrict users from accessing the root daemon if they are also added to the `docker` group. Group membership must be carefully managed to align with the intended privilege model.
**Prevention:** Do not add users to the `docker` group unless absolutely necessary. Rely on rootless docker (`virtualisation.docker.rootless.enable = true`) for user-level container management without root privileges.
