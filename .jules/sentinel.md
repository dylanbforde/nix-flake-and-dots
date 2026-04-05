## 2024-05-14 - Replace curl | sh with native package managers
**Vulnerability:** External script execution using `curl | sh` poses a severe security risk by executing arbitrary untrusted code without verification.
**Learning:** Development environments initialized via distrobox used insecure script pipelining instead of native package flags.
**Prevention:** Always use native `--additional-packages` flags in provisioning tools to ensure verified package installations rather than curling executable scripts.
## 2024-05-14 - Explicitly define security boundaries like Polkit
**Vulnerability:** Missing explicit Polkit configuration (`security.polkit.enable = true;`) relies on OS defaults which could leave the system without secure graphical privilege escalation, potentially leading to insecure passwordless sudo workarounds.
**Learning:** A core security pattern for this repository is to always explicitly define security boundaries and mechanisms rather than relying on framework or OS defaults.
**Prevention:** Always explicitly define `security.polkit.enable = true;` and similar security boundaries in `modules/core/system.nix`.
