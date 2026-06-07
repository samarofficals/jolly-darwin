# Usery OS - Auto-start Hyprland on TTY1
# This ensures the desktop launches even if SDDM fails
if [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    export LIBGL_ALWAYS_SOFTWARE=1
    export XDG_SESSION_TYPE=wayland
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    export MOZ_ENABLE_WAYLAND=1
    exec Hyprland
fi
