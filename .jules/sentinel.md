## 2024-10-24 - Docker Group Privilege Escalation
**Vulnerability:** User 'dylan' was a member of the 'docker' group, which grants root-equivalent privileges on the host system via the Docker socket.
**Learning:** Even when rootless Docker is enabled (`virtualisation.docker.rootless.enable = true`), adding a user to the 'docker' group bypasses the rootless configuration and exposes the root-ful Docker daemon if it exists or creates confusion.
**Prevention:** Ensure users are not added to the 'docker' group when using rootless Docker. Verify group memberships during user creation.
