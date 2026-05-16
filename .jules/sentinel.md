## 2024-05-24 - Remove insecure curl to shell execution
**Vulnerability:** Execution of a remote script using `curl | sh` during distrobox container initialization in `modules/programs/shell.nix`.
**Learning:** `curl | sh` is an insecure pattern as it bypasses standard package verification and can execute arbitrary malicious code if the remote server is compromised or connection intercepted. Distrobox mounts the host's `/nix` directory, meaning host packages (like `uv` installed in `modules/programs/dev.nix`) are available inside the container without needing ephemeral install scripts.
**Prevention:** Avoid `curl | sh`. Rely on the Nix package manager to provide dependencies securely to both the host and Distrobox containers.
