{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
  ];

  # Home Manager Config
  home-manager.users.dylan = {
    xdg.configFile."kitty/kitty.conf".text = let
      c = config.home-manager.users.dylan.theme.palette;
    in ''
      # Templated Kitty Config
      foreground              ${c.text}
      background              ${c.base}
      selection_foreground    ${c.base}
      selection_background    ${c.rosewater}
      cursor                  ${c.rosewater}
      cursor_text_color       ${c.base}
      url_color               ${c.rosewater}
      active_border_color     ${c.lavender}
      inactive_border_color   ${c.overlay0}
      bell_border_color       ${c.yellow}
      
      active_tab_foreground   ${c.crust}
      active_tab_background   ${c.mauve}
      inactive_tab_foreground ${c.text}
      inactive_tab_background ${c.mantle}
      tab_bar_background      ${c.crust}

      # 16 terminal colors
      color0 ${c.surface1}
      color8 ${c.surface2}
      color1 ${c.red}
      color9 ${c.red}
      color2 ${c.green}
      color10 ${c.green}
      color3 ${c.yellow}
      color11 ${c.yellow}
      color4 ${c.blue}
      color12 ${c.blue}
      color5 ${c.pink}
      color13 ${c.pink}
      color6 ${c.teal}
      color14 ${c.teal}
      color7 ${c.subtext1}
      color15 ${c.subtext0}

      # Other settings
      font_family      JetBrainsMono Nerd Font
      font_size        11.0
      window_padding_width 4
      background_opacity 0.9
    '';
  };
}
