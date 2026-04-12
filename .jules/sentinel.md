## 2026-04-12 - [High] Broken Screen Locker PAM Auth
**Vulnerability:** hyprlock screen locker is used but the explicit PAM configuration defines swaylock instead, causing hyprlock to fail authentication and potentially crash or fail securely, locking out the user.
**Learning:** NixOS screen lockers like hyprlock require explicit PAM declarations to securely verify passwords.
**Prevention:** Whenever changing the active screen locker module, update corresponding security.pam.services.* definitions to match.
