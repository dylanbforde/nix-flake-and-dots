# Sentinel Journal

## 2025-05-18 - Docker Group Privilege Escalation
**Vulnerability:** Adding a user to the `docker` group in NixOS grants root privileges via the system-wide docker socket.
**Learning:** Even if `virtualisation.docker.rootless.enable = true` is set, being in the `docker` group allows access to the rootful daemon, bypassing the intended isolation. This creates a privilege escalation path where a user can mount the root filesystem.
**Prevention:** Ensure users are NOT in the `docker` group when rootless docker is the intended configuration. Instead, rely on the rootless daemon or use `sudo` for administrative tasks.
