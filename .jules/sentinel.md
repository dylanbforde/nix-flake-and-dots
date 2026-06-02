## 2024-05-18 - Explicitly disable OpenSSH Root Login
**Vulnerability:** NixOS default settings might implicitly allow or configure root login via SSH in non-standard ways depending on the OpenSSH version/configuration, or fail open to public keys which should be fully prohibited for defence-in-depth unless explicitly needed.
**Learning:** We should explicitly configure security boundaries such as prohibiting SSH root login (`PermitRootLogin = "no";`), similar to explicitly defining firewall and polkit states.
**Prevention:** Make sure `PermitRootLogin = "no";` is always defined explicitly in `services.openssh.settings` when enabling the ssh daemon.
