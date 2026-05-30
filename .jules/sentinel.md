## 2024-05-30 - Hyprlock Missing PAM Configuration Lockout
**Vulnerability:** Missing PAM authentication definition for the active screen locker (`hyprlock`) in NixOS configuration, while a duplicate `swaylock` entry existed.
**Learning:** In NixOS, screen locker binaries are not automatically granted PAM authentication rights. They require explicit declarations in the configuration to function properly. Without this, authentication fails, leading to an unavoidable session lockout.
**Prevention:** Whenever changing or introducing a new screen locker mechanism (like switching from swaylock to hyprlock or adding hyprlock via hypridle), verify that a corresponding `security.pam.services.<locker> = {};` entry is added to explicitly define the authentication rights.
