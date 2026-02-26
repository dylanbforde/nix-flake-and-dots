## 2024-05-24 - [Privilege Escalation via Docker Group]
**Vulnerability:** User `dylan` was assigned to the `docker` group, which grants root-equivalent privileges via the Docker socket.
**Learning:** Rootless Docker is enabled in `modules/programs/dev.nix`, but adding the user to the `docker` group negates the security benefits by exposing the privileged daemon socket.
**Prevention:** Avoid adding users to the `docker` group. Rely on `virtualisation.docker.rootless.enable = true` for user-level container management without root privileges.
