{ pkgs, ... }:

let
  stayAwakeToggle = pkgs.writeShellApplication {
    name = "stay-awake-toggle";
    runtimeInputs = with pkgs; [
      coreutils
      libnotify
      procps
      systemd
      wlinhibit
    ];
    text = ''
      state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/stay-awake"
      pid_file="$state_dir/pids"

      mkdir -p "$state_dir"

      notify_status() {
        local message="$1"

        printf '%s\n' "$message"
        if command -v notify-send >/dev/null 2>&1; then
          notify-send --app-name=stay-awake-toggle "Stay Awake" "$message" || true
        fi
      }

      pid_is_running() {
        local pid="$1"

        [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null
      }

      stop_pid_tree() {
        local pid="$1"

        if pid_is_running "$pid"; then
          pkill -TERM -P "$pid" 2>/dev/null || true
          kill "$pid" 2>/dev/null || true
        fi
      }

      stop_inhibitors() {
        local stopped=1

        if [ -f "$pid_file" ]; then
          while read -r _ pid; do
            if pid_is_running "$pid"; then
              stop_pid_tree "$pid"
              stopped=0
            fi
          done < "$pid_file"
        fi

        if pgrep -x wlinhibit >/dev/null 2>&1; then
          pkill -x wlinhibit 2>/dev/null || true
          stopped=0
        fi

        rm -f "$pid_file"
        return "$stopped"
      }

      if stop_inhibitors; then
        notify_status "Off. Normal idle locking and suspend are available."
        exit 0
      fi

      wlinhibit &
      wlinhibit_pid="$!"

      systemd-inhibit \
        --what=idle:sleep \
        --who=stay-awake-toggle \
        --why="Stay Awake shortcut is enabled" \
        sleep infinity &
      systemd_inhibit_pid="$!"

      printf 'wlinhibit %s\nsystemd-inhibit %s\n' "$wlinhibit_pid" "$systemd_inhibit_pid" > "$pid_file"
      notify_status "On. Screen idle and suspend are inhibited."
    '';
  };

  keyShelfShortcuts = pkgs.writeText "keyshelf-shortcuts" ''
    SUPER+Esc        Toggle Stay Awake
    SUPER+H          Show this shortcut dashboard
    SUPER+Enter      Terminal
    SUPER+D          App launcher
    SUPER+B          Browser
    SUPER+E          Files
    SUPER+T          System monitor
    SUPER+M          Spotify
    SUPER+N          Antigravity
    SUPER+L          Lock screen
    SUPER+C          Clipboard history (Niri)
    Print            Screenshot
    SUPER+Print      Region screenshot
    SUPER+Q          Close window (Niri) / quit session (Hyprland)
    SUPER+W          Close window (Hyprland)
    SUPER+F          Fullscreen
    SUPER+Space      Overview (Niri)
    SUPER+V          Toggle floating
    SUPER+Shift+E    Quit Niri
    SUPER+1..0       Switch workspace (Hyprland)
    SUPER+Shift+1..0 Move window to workspace (Hyprland)

    Aliases
    ls               eza --icons
    ll               eza -la
    z                zoxide smart cd
    gs               git status
    ga               git add
    gc               git commit
    gp               git push
  '';

  keyshelf = pkgs.writeShellApplication {
    name = "keyshelf";
    runtimeInputs = with pkgs; [
      coreutils
      fzf
      wofi
    ];
    text = ''
      if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
        cat ${keyShelfShortcuts} | wofi --dmenu --prompt "Shortcuts" >/dev/null || true
      else
        cat ${keyShelfShortcuts} | fzf \
          --header "System Shortcuts & Aliases" \
          --prompt "Search: " \
          --layout=reverse \
          --border \
          --height=100% \
          --preview "echo {}" \
          --preview-window=up:1:wrap
      fi
    '';
  };
in
{
  environment.systemPackages = [
    keyshelf
    pkgs.wlinhibit
    stayAwakeToggle
  ];
}
