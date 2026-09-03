{ pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "dylan";
    group = "users";
    dataDir = "/home/dylan";
    configDir = "/home/dylan/.config/syncthing";

    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = false;

    # Device pairing and the notes folder are created through the Syncthing UI.
    # Keeping these false preserves that state across NixOS rebuilds.
    overrideDevices = false;
    overrideFolders = false;

    settings.options = {
      listenAddresses = [ "tcp://0.0.0.0:22000" ];
      globalAnnounceEnabled = false;
      localAnnounceEnabled = false;
      relaysEnabled = false;
      natEnabled = false;
      urAccepted = -1;
    };
  };

  # Syncthing is reachable only through the existing Tailscale mesh.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22000 ];

  systemd.tmpfiles.rules = [
    "d /home/dylan/.local/share/syncthing-versions 0700 dylan users - -"
    "d /home/dylan/.local/share/syncthing-versions/notes 0700 dylan users - -"
  ];

  home-manager.users.dylan = {
    home.packages = [ pkgs.syncthingtray ];

    # This is a monitor for the existing NixOS-managed Syncthing instance. It
    # must not start or manage a second Syncthing daemon.
    systemd.user.services.syncthingtray = {
      Unit = {
        Description = "Syncthing tray monitor";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.syncthingtray}/bin/syncthingtray --wait --single-instance";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
