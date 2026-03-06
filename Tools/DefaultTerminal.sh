#!/bin/bash

# Terminal detection order: specific/modern first, generic fallbacks last.
# kde-ptyxis removed — KDE uses konsole; ptyxis is a GNOME terminal (not KDE).
terms=(
  ptyxis            # GNOME default (Ubuntu 24.10+ / Fedora 41+)
  gnome-terminal    # GNOME classic
  konsole           # KDE Plasma
  xfce4-terminal    # XFCE
  mate-terminal     # MATE desktop
  lxterminal        # LXDE
  qterminal         # LXQt
  tilix             # Popular tiling terminal
  terminator        # Popular multi-pane terminal
  alacritty         # GPU-accelerated
  kitty             # GPU-accelerated (uses direct command, no -e flag)
  foot              # Wayland-native (uses direct command, no -e flag)
  x-terminal-emulator  # Debian/Ubuntu alternatives symlink (fallback)
  xterm             # Universal fallback
)
for t in "${terms[@]}"
do
    if command -v "$t" &>/dev/null
    then
        detected_term=$t
        break
    fi
done
echo $detected_term
