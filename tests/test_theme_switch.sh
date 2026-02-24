#!/bin/bash

# Test setup
TEST_DIR=$(mktemp -d)
export HOME="$TEST_DIR"
mkdir -p "$HOME/wallpapers"
mkdir -p "$HOME/.local/state/nix/profiles/home-manager"
mkdir -p "$HOME/.config/hypr"

# Mock output file
MOCK_LOG="$TEST_DIR/mock.log"

# Mocks
hyprctl() {
    echo "hyprctl $@" >> "$MOCK_LOG"
    if [ "$1" = "hyprpaper" ] && [ "$2" = "listactive" ]; then
        if [ -f "$TEST_DIR/current_wallpaper" ]; then
            echo "wallpaper = $(cat "$TEST_DIR/current_wallpaper")"
        fi
    fi
}

pkill() {
    echo "pkill $@" >> "$MOCK_LOG"
}

killall() {
    echo "killall $@" >> "$MOCK_LOG"
}

# Mock realpath to allow switching 'current profile' state
realpath() {
    if [[ "$1" == *".nix-profile" ]]; then
        echo "${TEST_PROFILE:-$HOME/.nix-profile}"
    else
        # Use system realpath if available, otherwise readlink
        if command -v realpath >/dev/null 2>&1; then
            command realpath "$1"
        else
            readlink -f "$1"
        fi
    fi
}

sleep() {
    :
}

export -f hyprctl
export -f pkill
export -f killall
export -f realpath

# Create dummy activate scripts
mkdir -p "$HOME/.local/state/nix/profiles/home-manager/specialisation/oil-painting"
touch "$HOME/.local/state/nix/profiles/home-manager/activate"
chmod +x "$HOME/.local/state/nix/profiles/home-manager/activate"
cat > "$HOME/.local/state/nix/profiles/home-manager/activate" <<EOF
#!/bin/bash
echo "ACTIVATE: BASE" >> "$MOCK_LOG"
EOF

touch "$HOME/.local/state/nix/profiles/home-manager/specialisation/oil-painting/activate"
chmod +x "$HOME/.local/state/nix/profiles/home-manager/specialisation/oil-painting/activate"
cat > "$HOME/.local/state/nix/profiles/home-manager/specialisation/oil-painting/activate" <<EOF
#!/bin/bash
echo "ACTIVATE: OIL PAINTING" >> "$MOCK_LOG"
EOF

# Source the script
source modules/home/scripts/theme-switch.sh

# Helper assertions
assert_contains() {
    if ! grep -q "$1" "$MOCK_LOG"; then
        echo "FAIL: Log does not contain '$1'"
        echo "Log content:"
        cat "$MOCK_LOG"
        exit 1
    fi
}

assert_not_contains() {
    if grep -q "$1" "$MOCK_LOG"; then
        echo "FAIL: Log contains '$1' but should not"
        echo "Log content:"
        cat "$MOCK_LOG"
        exit 1
    fi
}

clear_log() {
    > "$MOCK_LOG"
}

# TEST 1: Palette switch - default to oil painting
echo "TEST 1: Switch palette (Base -> Oil Painting)"
TEST_PROFILE="$HOME/.nix-profile" # Base profile
clear_log
theme-switch palette
assert_contains "ACTIVATE: OIL PAINTING"
assert_contains "hyprctl reload"
assert_contains "pkill -USR1 kitty"

# TEST 2: Palette switch - oil painting to base
echo "TEST 2: Switch palette (Oil Painting -> Base)"
TEST_PROFILE="$HOME/.nix-profile/specialisation/oil-painting" # Specialisation
clear_log
theme-switch palette
assert_contains "ACTIVATE: BASE"

# TEST 3: Wallpaper switch - no wallpapers
echo "TEST 3: Wallpaper switch (No wallpapers)"
clear_log
if theme-switch wallpaper >/dev/null 2>&1; then
    echo "FAIL: Should have failed with no wallpapers"
    exit 1
fi

# TEST 4: Wallpaper switch - cycle
echo "TEST 4: Wallpaper switch (Cycle)"
touch "$HOME/wallpapers/1.jpg"
touch "$HOME/wallpapers/2.png"
touch "$HOME/wallpapers/3.webp"

# Set current wallpaper to 1.jpg
echo "$HOME/wallpapers/1.jpg" > "$TEST_DIR/current_wallpaper"
clear_log

theme-switch wallpaper
# Should switch to 2.png (alphabetical: 1.jpg, 2.png, 3.webp)
assert_contains "hyprctl hyprpaper wallpaper ,$HOME/wallpapers/2.png"

# Cycle again
echo "$HOME/wallpapers/2.png" > "$TEST_DIR/current_wallpaper"
clear_log
theme-switch wallpaper
assert_contains "hyprctl hyprpaper wallpaper ,$HOME/wallpapers/3.webp"

# Cycle again (loop back to 1)
echo "$HOME/wallpapers/3.webp" > "$TEST_DIR/current_wallpaper"
clear_log
theme-switch wallpaper
assert_contains "hyprctl hyprpaper wallpaper ,$HOME/wallpapers/1.jpg"

echo "ALL TESTS PASSED"
rm -rf "$TEST_DIR"
