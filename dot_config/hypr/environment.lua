-- Cursor / Qt / menu prefix
hl.env("XCURSOR_SIZE", "32")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("XDG_MENU_PREFIX", "arch-")

-- NVIDIA: NVENC + Wayland
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

-- Force Wayland backends across toolkits
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Prevent toolkit double-scaling on top of the compositor scale
hl.env("GDK_SCALE", "1")
hl.env("GDK_DPI_SCALE", "1")
hl.env("STEAM_FORCE_DESKTOPUI_SCALING", "1.0")

hl.config({
    input = {
        follow_mouse = 1,
        repeat_delay = 200,
        repeat_rate  = 50,
        sensitivity  = 0,
        kb_layout    = "us",
        kb_options   = "caps:escape",
        touchpad = {
            natural_scroll = true,
        },
    },

    xwayland = {
        force_zero_scaling = true,
    },

    misc = {
        force_default_wallpaper = -1,
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles   = true,
    },

    dwindle = {
        preserve_split = true,
    },
})
