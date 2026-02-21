## 2025-05-25 - Docker Group Privilege Escalation
**Vulnerability:** User was added to the `docker` group despite `virtualisation.docker.rootless.enable = true`.
**Learning:** Enabling rootless docker in NixOS does not automatically revoke access to the rootful docker socket if the user is manually added to the `docker` group. Membership in the `docker` group is equivalent to root access.
**Prevention:** Verify that users are NOT in the `docker` group when rootless docker is the intended configuration.
