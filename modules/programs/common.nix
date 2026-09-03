{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  codexCli = inputs.codex-cli-nix.packages.${system}.default;
  codexDesktop = inputs.codex-desktop-linux.packages.${system}.codex-desktop;
  codexDesktopReopen = pkgs.writeShellApplication {
    name = "codex-desktop-reopen";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.niri
      pkgs.procps
    ];
    text = ''
      state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/codex-desktop"
      app_pid_file="$state_dir/app.pid"
      webview_pid_file="$state_dir/webview.pid"

      pid_cmdline_matches() {
        local pid="$1"
        local pattern="$2"

        [ -n "$pid" ] || return 1
        [ -r "/proc/$pid/cmdline" ] || return 1
        tr '\0' ' ' < "/proc/$pid/cmdline" | grep -q "$pattern"
      }

      stop_pid() {
        local pid="$1"

        kill "$pid" 2>/dev/null || return 0
        for _ in $(seq 1 40); do
          kill -0 "$pid" 2>/dev/null || return 0
          sleep 0.1
        done
        kill -9 "$pid" 2>/dev/null || true
      }

      codex_window_exists() {
        if [ "''${XDG_CURRENT_DESKTOP:-}" = "niri" ] && command -v niri >/dev/null 2>&1; then
          niri msg windows 2>/dev/null | grep -q 'App ID: "codex-desktop"'
          return
        fi

        return 0
      }

      if ! codex_window_exists; then
        if [ -f "$app_pid_file" ]; then
          app_pid="$(cat "$app_pid_file" 2>/dev/null || true)"
          if pid_cmdline_matches "$app_pid" "codex-desktop"; then
            stop_pid "$app_pid"
          fi
        fi

        if [ -f "$webview_pid_file" ]; then
          webview_pid="$(cat "$webview_pid_file" 2>/dev/null || true)"
          if pid_cmdline_matches "$webview_pid" "webview-server.py"; then
            stop_pid "$webview_pid"
          fi
        fi

        rm -f "$app_pid_file" "$webview_pid_file"
      fi

      exec ${codexDesktop}/bin/codex-desktop "$@"
    '';
  };
in
{
  environment.systemPackages =
    (with pkgs; [
      unstable.antigravity-ide
      unstable.nordvpn
      codexCli
      brave
      git
      xfce.thunar
      xfce.thunar-archive-plugin
      btop
      spotify
      fzf
      zoxide
      eza
      ripgrep
      fd
      discord
      vlc
      pavucontrol
      imv
      zathura
      yazi
      unzip
      jq
      playerctl
      obsidian
      rclone
      tmux
    ])
    ++ lib.optionals (config.networking.hostName != "nixos-laptop") [
      codexDesktop
      codexDesktopReopen
    ];

  # Thunar
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar.enable = true;

  home-manager.users.dylan = lib.mkIf (config.networking.hostName != "nixos-laptop") {
    home.file.".local/share/applications/codex-desktop.desktop".text = ''
      [Desktop Entry]
      Name=Codex Desktop
      Comment=Run Codex Desktop on Linux
      Exec=${codexDesktopReopen}/bin/codex-desktop-reopen %u
      Icon=codex-desktop
      Terminal=false
      Type=Application
      Categories=Development;
      MimeType=x-scheme-handler/codex;x-scheme-handler/codex-browser-sidebar;
      StartupNotify=true
      StartupWMClass=Codex
      X-GNOME-WMClass=Codex
    '';
  };

  # Cloud storage
  systemd.user.services.rclone-onedrive = {
    description = "Mount OneDrive with rclone";
    wantedBy = [ "default.target" ];
    after = [ "graphical-session.target" ];
    environment.PATH = lib.mkForce (
      "/run/wrappers/bin:"
      + lib.makeBinPath [
        pkgs.coreutils
        pkgs.findutils
        pkgs.gnugrep
        pkgs.gnused
        pkgs.systemd
        pkgs.fuse3
      ]
    );

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/OneDrive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount onedrive: %h/OneDrive --config=%h/.config/rclone/rclone.conf --vfs-cache-mode writes";
      ExecStop = "/run/wrappers/bin/fusermount3 -uz %h/OneDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # Gaming
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # CLI Tools config
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
