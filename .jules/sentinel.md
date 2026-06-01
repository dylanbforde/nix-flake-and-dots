## 2026-06-01 - Missing PAM configuration for screen lockers
**Vulnerability:** The screen locker `hyprlock` was missing explicit PAM configuration, which can cause it to fail closed and lock users out.
**Learning:** In NixOS, screen locker binaries (like `hyprlock`, `swaylock`) are not automatically granted PAM authentication rights. They require an explicit declaration (e.g., `security.pam.services.<locker> = {};`).
**Prevention:** Ensure any added screen locker is explicitly granted PAM configuration alongside others to function securely.
