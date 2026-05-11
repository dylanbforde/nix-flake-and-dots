## 2024-05-24 - Missing PAM Authentication for Screen Locker

**Vulnerability:** The active screen locker `hyprlock` lacked an explicit PAM configuration (`security.pam.services.hyprlock = {};`) in `modules/desktop/hyprland/default.nix`, while `swaylock` was defined twice. In NixOS, missing PAM configuration for screen lockers can cause authentication to fail closed (lockout) or fail open (security bypass).
**Learning:** Declarative system configurations require explicit security boundaries and authentication hooks for every active component; a duplicated entry can easily mask a missing critical security configuration.
**Prevention:** Ensure all screen lockers and authentication endpoints have explicit, distinct PAM service definitions mapped in the system configuration to prevent bypasses.

## 2024-05-24 - Insecure Remote Code Execution via curl

**Vulnerability:** Distrobox container initialization functions (`db-cuda` and `db-dev`) in `modules/home/default.nix` downloaded and executed unverified remote scripts. This pattern introduces a significant risk of arbitrary code execution if the remote server or connection is compromised.
**Learning:** Ephemeral shell initialization often bypasses package manager verification and supply chain security controls, allowing unpinned, unhashed code to execute.
**Prevention:** Install dependencies (like `uv`) via the host's package manager (`environment.systemPackages`) to rely on cryptographic verification and immutability, eliminating the need for insecure download-and-execute patterns.

## 2024-05-24 - Insecure SSH Configuration (Password Auth & Root Login)

**Vulnerability:** The OpenSSH daemon in `modules/networking/default.nix` was enabled (`services.openssh.enable = true;`) but lacked explicit security hardening. By default, this allows password authentication and may permit root login depending on the NixOS version, exposing the system to brute-force attacks.
**Learning:** Security mechanisms like SSH should always be explicitly hardened using a defense-in-depth approach, regardless of default configurations, which can change or be overly permissive.
**Prevention:** Explicitly configure `services.openssh.settings` to set `PasswordAuthentication = false` and `PermitRootLogin = "no"`.
