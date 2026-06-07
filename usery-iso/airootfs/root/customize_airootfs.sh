#!/usr/bin/env bash
# Runs inside the airootfs chroot AFTER all packages are installed.
# This is the correct place to overwrite package-installed files.
set -euo pipefail

echo "==> [Usery OS] Running post-package customizations..."

# ------------------------------------------------------------------
# 1. Overwrite Calamares settings.conf with our custom branded version
# ------------------------------------------------------------------
mkdir -p /etc/calamares
cat > /etc/calamares/settings.conf << 'EOF'
# Calamares Settings for Usery OS
---
modules-search: [ local, /usr/lib/calamares/modules ]

sequence:
  - show:
    - welcome
    - locale
    - keyboard
    - partition
    - users
    - summary
  - exec:
    - partition
    - mount
    - unpackfs
    - machineid
    - fstab
    - locale
    - keyboard
    - localecfg
    - users
    - displaymanager
    - networkcfg
    - hwclock
    - services-systemd
    - bootloader
    - umount
  - show:
    - finished

brand-image: "/usr/share/backgrounds/usery_wallpaper.png"
style-sidebar-background: "#1a1b26"
style-sidebar-text: "#ffffff"
show-back-on-welcome-page: false
show-cant-exit-after-write: true
EOF

echo "==> [Usery OS] Calamares settings.conf injected."

# ------------------------------------------------------------------
# 2. Create Hyprland Wayland session file so SDDM can find it
# ------------------------------------------------------------------
mkdir -p /usr/share/wayland-sessions
cat > /usr/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

echo "==> [Usery OS] Hyprland Wayland session registered."

# ------------------------------------------------------------------
# 3. Ensure liveuser home is populated from /etc/skel
# ------------------------------------------------------------------
if [ -d /home/liveuser ]; then
    cp -rn /etc/skel/. /home/liveuser/ 2>/dev/null || true
    chown -R liveuser:liveuser /home/liveuser
fi

echo "==> [Usery OS] liveuser home directory populated."

# ------------------------------------------------------------------
# 4. Enable SDDM display manager
# ------------------------------------------------------------------
systemctl enable sddm.service 2>/dev/null || true
systemctl enable NetworkManager.service 2>/dev/null || true

echo "==> [Usery OS] Services enabled."
echo "==> [Usery OS] customize_airootfs.sh done!"
