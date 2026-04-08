{ pkgs, ... }:

let
  keyshelf = pkgs.writeShellScriptBin "keyshelf" ''
    # Path to hyprland config
    HYPR_CONF="$HOME/nixos-config/modules/desktop/hyprland/hyprland.conf"
    
    # Parse Hyprland bindings
    HYPR_KEYS=$(grep '^bind' "$HYPR_CONF" | grep 'exec' | sed -E 's/^bind[a-z]*\s*=\s*([^,]+),\s*([^,]+),\s*exec,\s*(.*)$/󱕷 \1+\2  ➜  \3/' | sed 's/\$mod/ALT/g')
    
    # Parse Bash aliases (from home.nix or common places)
    # For now, let's just use some common ones and the ones we know
    ALIASES=(
      "󰋜 ls     ➜  eza --icons"
      "󰋜 ll     ➜  eza -la"
      "󰋜 z      ➜  zoxide (smart cd)"
      "󰋜 gs     ➜  git status"
      "󰋜 ga     ➜  git add"
      "󰋜 gc     ➜  git commit"
      "󰋜 gp     ➜  git push"
    )
    
    # Combine and show in fzf
    (echo "$HYPR_KEYS"; printf "%s\n" "''${ALIASES[@]}") | \
      ${pkgs.fzf}/bin/fzf --header "System Shortcuts & Aliases" \
             --prompt "Search: " \
             --layout=reverse \
             --border \
             --height=100% \
             --preview "echo {}" \
             --preview-window=up:1:wrap
  '';
in
{
  environment.systemPackages = [ keyshelf ];
}
