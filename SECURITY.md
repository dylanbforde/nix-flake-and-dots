# Security Notes

This repository is public. Do not commit plaintext passwords, tokens, private
keys, auth keys, backup credentials, or decrypted secret files.

Use `gitleaks detect --redact --source .` before pushing local work. Use
`nix flake check` for the repo-level formatting, lint, and working-tree secret
checks.

Future secrets should use `sops-nix` with age recipients. Commit only encrypted
secret files and keep private age keys under `~/.config/sops/age/keys.txt` or
another local, untracked path.
