## 2026-04-11 - [Security: Update PAM Configuration for Screen Locker]
**Vulnerability:** The active screen locker (`hyprlock`) was missing explicit PAM configuration (`security.pam.services.hyprlock = {}`), and an obsolete `swaylock` configuration was left in its place. This misconfiguration could prevent users from successfully unlocking their system, potentially causing lockouts or forcing unauthenticated reboots.
**Learning:** When migrating to a new screen locker (like from swaylock to hyprlock), explicit PAM configuration must be migrated alongside it. Legacy configuration can cause unintended lockouts.
**Prevention:** Always verify that the active screen locker has corresponding explicit PAM configuration defined to guarantee authentications function as expected.
