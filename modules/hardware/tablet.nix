{ pkgs, ... }:

{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  environment.systemPackages = with pkgs; [
    rnote
    xournalpp
  ];
}
