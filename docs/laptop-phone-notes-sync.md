# Laptop, phone, and desktop notes sync

The canonical Obsidian vault is `/home/dylan/notes`. The laptop and Android
phone synchronize that directory in both directions through Syncthing over
Tailscale. The desktop is a receive-only replica and recovery target. Code
repositories remain outside this rollout.

## Laptop preparation completed on 2026-08-31

- A full pre-pairing snapshot is stored at
  `/home/dylan/.local/share/notes-sync-bootstrap/notes-pre-pairing-2026-08-31`.
- The current laptop configuration was copied from `.obsidian` to
  `.obsidian-laptop`.
- The laptop has opened the vault with `.obsidian-laptop`; its current layout
  and plugin configuration are being written there.
- The laptop ignore rules are installed in `/home/dylan/notes/.stignore`.
- Syncthing has been initialized and the Android phone is paired. Device IDs
  and Tailscale addresses remain in the live Syncthing configuration rather
  than this public repository.
- Folder `dylan-notes-v1` already points at `/home/dylan/notes` as
  **Send & Receive**, with staggered one-year versioning stored outside the
  vault.

Do not remove the snapshot until phone synchronization and recovery have both
passed the acceptance checks.

## Before pairing

1. In Obsidian, set **Settings > Files and Links > Override config folder** to
   `.obsidian-laptop`, relaunch, and verify the existing plugins and settings.
2. Put these rules in the phone's Syncthing ignore patterns:

   ```text
   (?d)/.git
   (?d)/.obsidian
   (?d)/.trash
   (?d).DS_Store
   (?d)Thumbs.db
   (?d)*.tmp
   (?d)*.part
   ```

The separate `.obsidian-laptop` and `.obsidian-mobile` directories are not
ignored. The vault's 693 MiB `.git` directory remains local to the laptop.

## Pairing

1. Open the laptop UI at `http://127.0.0.1:8384`.
2. Install Tailscale and Syncthing-Fork on Android and allow unrestricted
   background/battery operation.
3. Pair the devices using their Syncthing device IDs and fixed Tailscale
   addresses:
   - Laptop from phone: `tcp://<laptop-tailscale-name>:22000`
   - Phone from laptop: `tcp://<phone-tailscale-name>:22000`
4. Share the already configured `dylan-notes-v1` folder with the phone. Accept
   it into an empty shared-storage
   directory such as `Documents/Obsidian/notes`, also as **Send & Receive**.
5. Perform the first synchronization while the phone is charging on Wi-Fi.
6. Open the completed Android folder as an existing Obsidian vault, set its
   override config folder to `.obsidian-mobile`, and relaunch Obsidian.

## Acceptance checks

- A laptop-created note reaches Android and an Android-created note reaches the
  laptop.
- `.git`, `.obsidian`, and `.trash` do not appear on the other device.
- Changing the mobile layout does not modify `.obsidian-laptop`.
- Deleting a disposable note on Android creates a recoverable version on the
  laptop.
- Synchronization reconnects after rebooting both devices.

Keep the untouched safety copy until a later desktop replica or offline backup
has been configured and tested.

## Desktop replica bootstrap

The desktop configuration enables the same Tailscale-only Syncthing service and
creates these paths:

```text
/srv/syncthing/notes
/srv/syncthing/.versions/notes
```

After turning on the desktop:

1. Pull this repository and rebuild `nixos-desktop`.
2. Run `sudo tailscale up --force-reauth --ssh` if the desktop's Tailscale key
   has expired.
3. Open `http://127.0.0.1:8384` on the desktop.
4. Pair the desktop and laptop using their live device IDs and fixed Tailscale
   hostnames. Leave **Introducer** and **Auto Accept** disabled.
5. On the laptop, share `dylan-notes-v1` with the desktop.
6. Accept the folder on the desktop with path `/srv/syncthing/notes` and folder
   type **Receive Only**.
7. Add the same ignore patterns used on the laptop, especially `.git`,
   `.obsidian`, and `.trash`.
8. Enable **Staggered File Versioning** on the desktop folder, set the versions
   path to `/srv/syncthing/.versions/notes`, and retain versions for 365 days.
9. Let the initial synchronization finish, then verify that `.git` is absent
   and test recovery by deleting a disposable note from the phone.

The desktop is a replica, not another authoring peer. Do not use **Override
Changes** during normal operation; that action would intentionally push local
desktop contents back toward the laptop and phone.

## Handwritten notes

Xournal++ documents live below `/home/dylan/notes/30 Handwritten`, one directory
per document. Keep the editable `.xopp`, any original background PDF, the
flattened PDF export, and an optional companion Markdown note together.

After saving a document in Xournal++, run:

```bash
notes-export-pdf "/home/dylan/notes/30 Handwritten/subject/document/document.xopp"
```

The command produces `document-annotated.pdf` beside the source. It locks each
document, exports through a temporary file, and refuses to publish the result
if the `.xopp` changed during export.

## Syncthing tray

The laptop configuration installs SyncthingTray 2.0.3 and starts it with the
graphical session. It monitors the existing NixOS-managed Syncthing daemon; it
does not launch a second daemon. The first launch may ask to confirm the local
Syncthing configuration at `http://127.0.0.1:8384`.

## Git LFS

Git LFS 3.7.1 is laptop-only because the vault's `.git` directory is excluded
from Syncthing. `/home/dylan/notes/.gitattributes` sends newly added or modified
PDFs through Git LFS while Syncthing continues sending complete working-tree
PDFs to Android.

Existing PDF history has not been rewritten. Do not run `git lfs migrate` until
there is a separately verified backup and the remote LFS capacity has been
checked.
