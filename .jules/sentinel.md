## 2024-05-14 - Screen Locker Authentication Bypass / Lockout
**Vulnerability:** The PAM configuration was set for `swaylock` instead of the active screen locker `hyprlock`. Without a PAM module configured for `hyprlock`, it cannot authenticate users, leading to either a permanent lockout or fail-open bypass.
**Learning:** In NixOS, screen lockers are not automatically granted PAM permissions. If you switch from one locker (like `swaylock`) to another (`hyprlock`), you must explicitly configure PAM for the new binary or authentication will fail.
**Prevention:** Always ensure `security.pam.services.<locker>` exactly matches the locker binary configured in the idle daemon (`hypridle`).
