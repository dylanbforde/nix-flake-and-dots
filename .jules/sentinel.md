## 2024-05-24 - Missing PAM Auth for Screen Lockers
**Vulnerability:** The active screen locker (`hyprlock`) lacked an explicit PAM authentication declaration (`security.pam.services.hyprlock = {};`), which can lead to users being locked out or authentication failing open.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require an explicit declaration in the configuration to function securely.
**Prevention:** Always explicitly define PAM authentication rights for any screen locker binary used in the environment.
