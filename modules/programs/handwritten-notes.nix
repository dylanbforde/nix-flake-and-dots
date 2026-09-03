{ pkgs, ... }:

let
  notesExportPdf = pkgs.writeShellApplication {
    name = "notes-export-pdf";
    runtimeInputs = with pkgs; [
      coreutils
      libnotify
      util-linux
      xournalpp
    ];
    text = ''
            usage() {
              cat <<'EOF'
      Usage: notes-export-pdf PATH/TO/DOCUMENT.xopp

      Export a Xournal++ document below ~/notes/30 Handwritten to a sibling
      DOCUMENT-annotated.pdf. The editable .xopp file is never modified.
      EOF
            }

            if [ "$#" -ne 1 ]; then
              usage >&2
              exit 2
            fi

            handwritten_root="$HOME/notes/30 Handwritten"
            source_path="$(realpath -e -- "$1")"

            case "$source_path" in
              "$handwritten_root"/*.xopp) ;;
              *)
                printf 'error: input must be a .xopp file below %s\n' "$handwritten_root" >&2
                exit 2
                ;;
            esac

            source_dir="$(dirname -- "$source_path")"
            source_file="$(basename -- "$source_path")"
            document_name="''${source_file%.xopp}"
            output_path="$source_dir/$document_name-annotated.pdf"

            runtime_root="''${XDG_RUNTIME_DIR:-/tmp}"
            lock_dir="$runtime_root/notes-export-pdf-$UID"
            mkdir -p -- "$lock_dir"
            chmod 0700 "$lock_dir"
            lock_key="$(printf '%s' "$source_path" | sha256sum | cut -d' ' -f1)"

            exec 9>"$lock_dir/$lock_key.lock"
            if ! flock --nonblock 9; then
              printf 'error: an export is already running for %s\n' "$source_path" >&2
              exit 1
            fi

            source_state_before="$(stat --format='%s:%Y' -- "$source_path")"
            temporary_pdf="$(mktemp --tmpdir="$source_dir" ".''${document_name}-annotated.XXXXXX.pdf")"
            cleanup() {
              rm -f -- "$temporary_pdf"
            }
            trap cleanup EXIT HUP INT TERM

            if ! xournalpp --create-pdf="$temporary_pdf" "$source_path"; then
              notify-send --app-name="Xournal++" "PDF export failed" "$source_file" 2>/dev/null || true
              exit 1
            fi

            source_state_after="$(stat --format='%s:%Y' -- "$source_path")"
            if [ "$source_state_before" != "$source_state_after" ]; then
              printf 'error: %s changed during export; save it and try again\n' "$source_path" >&2
              notify-send --app-name="Xournal++" "PDF export deferred" "$source_file changed during export" 2>/dev/null || true
              exit 1
            fi

            if [ ! -s "$temporary_pdf" ]; then
              printf 'error: Xournal++ produced an empty PDF\n' >&2
              exit 1
            fi

            mv -f -- "$temporary_pdf" "$output_path"
            trap - EXIT HUP INT TERM

            notify-send --app-name="Xournal++" "PDF exported" "$output_path" 2>/dev/null || true
            printf '%s\n' "$output_path"
    '';
  };
in
{
  home-manager.users.dylan.home.packages = [ notesExportPdf ];

  systemd.tmpfiles.rules = [
    "d '/home/dylan/notes/30 Handwritten' 0750 dylan users - -"
  ];
}
