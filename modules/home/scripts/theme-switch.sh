# Advanced Theme Switcher
theme-switch() {
  local cmd="$1"
  local wp_path="$HOME/wallpapers"

  # Path to the base Home Manager profile
  local hm_base="$HOME/.local/state/nix/profiles/home-manager"

  case "$cmd" in
    palette)
      # Find the true base and spec paths
      local hm_real=$(realpath "$hm_base")
      if [[ "$hm_real" == *"specialisation"* ]]; then
        hm_real=$(realpath "$hm_real/../../")
      fi

      local spec_activate="$hm_real/specialisation/oil-painting/activate"
      local base_activate="$hm_real/activate"

      # Check if we are currently in a specialisation profile
      local active_profile=$(realpath "$HOME/.nix-profile")
      local is_spec=0
      if [[ "$active_profile" == *"specialisation"* ]]; then is_spec=1; fi

      if [ "$is_spec" -eq 0 ] && [ -f "$spec_activate" ]; then
        echo "🎨 Switching to Oil Painting palette..."
        "$spec_activate"
      else
        echo "🎨 Switching to Vaporwave (Base) palette..."
        "$base_activate"
      fi

      # Post-switch reloads
      echo "🔄 Refreshing applications..."
      hyprctl reload >/dev/null 2>&1
      pkill -USR1 kitty 2>/dev/null

      # Cleanly restart Waybar to avoid duplicates
      pkill -9 waybar 2>/dev/null
      killall -9 waybar 2>/dev/null
      sleep 0.3
      hyprctl dispatch exec waybar
      ;;
    wallpaper)
      # Get current wallpaper filename
      local current_wp=$(hyprctl hyprpaper listactive 2>/dev/null | grep "=" | awk '{print $NF}' | head -n1)
      [ -z "$current_wp" ] && current_wp=$(grep "wallpaper =" ~/.config/hypr/hyprpaper.conf | cut -d',' -f2 | xargs)
      local current_name=$(basename "$current_wp")

      # Get all images in the wallpapers folder
      shopt -s nullglob
      local wps=("$wp_path"/*.jpg "$wp_path"/*.jpeg "$wp_path"/*.png "$wp_path"/*.webp)
      shopt -u nullglob

      local count=${#wps[@]}
      if [ "$count" -eq 0 ]; then
        echo "No wallpapers found in $wp_path. Contents:"
        ls -F "$wp_path"
        return 1
      fi

      local next_wp=""
      for i in "${!wps[@]}"; do
        local name=$(basename "${wps[$i]}")
        if [ "$name" = "$current_name" ]; then
          local next_idx=$(( (i + 1) % count ))
          next_wp="${wps[$next_idx]}"
          break
        fi
      done

      # Fallback if no match or first run
      if [ -z "$next_wp" ]; then
        next_wp="${wps[0]}"
        if [ "$(basename "$next_wp")" = "$current_name" ] && [ "$count" -gt 1 ]; then
           next_wp="${wps[1]}"
        fi
      fi

      echo "Found $count images. Current: $current_name -> Switching to: $(basename "$next_wp")"
      hyprctl hyprpaper preload "$next_wp"
      hyprctl hyprpaper wallpaper ",$next_wp"
      ;;
    *)
      echo "Usage: theme-switch [palette|wallpaper]"
      ;;
  esac
}
