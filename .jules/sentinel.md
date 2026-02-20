## 2025-05-23 - [Privilege Escalation via Docker Group]
**Vulnerability:** User `dylan` was in the `docker` group despite rootless docker being enabled.
**Learning:** Adding users to the `docker` group gives them root-equivalent access to the host, defeating the purpose of rootless docker.
**Prevention:** Ensure users are not added to `docker` group when `virtualisation.docker.rootless.enable = true`. Instead, rely on the rootless socket.
