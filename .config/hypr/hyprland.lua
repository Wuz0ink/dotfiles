-- ~/.config/hypr/hyprland.lua

local home = os.getenv("HOME")

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "DP-1",     mode = "2560x1440@143.973007", position = "0x1440", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60",         position = "0x0",    scale = 1 })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "alacritty"
local browser  = "firefox"
local menu     = "rofi -show drun -show-icons"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl start --user pipewire-pulse")
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("hyprpanel")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd(home .. "/.config/hypr/cycle-wallpaper")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME",            "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE",             "24")
hl.env("HYPRCURSOR_SIZE",          "24")
hl.env("MOZ_ENABLE_WAYLAND",       "1")
hl.env("LIBVA_DRIVER_NAME",        "nvidia")
hl.env("GBM_BACKEND",              "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")
hl.env("NVD_BACKEND",              "direct")
hl.env("XDG_SESSION_TYPE",         "wayland")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "master",
    },

    cursor = {
        no_warps         = true,
        persistent_warps = true,
    },

    decoration = {
        rounding         = 10,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled           = true,
            size              = 3,
            passes            = 1,
            new_optimizations = true,
            vibrancy          = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    master = {
        new_status = "slave",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
        vrr                     = 2,
    },

    input = {
        repeat_delay       = 250,
        repeat_rate        = 50,
        accel_profile      = "flat",
        kb_layout          = "us,se",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "grp:win_space_toggle",
        kb_rules           = "",
        numlock_by_default = true,
        follow_mouse       = 1,
        sensitivity        = 0,
        touchpad = {
            natural_scroll = false,
        },
    },

    binds = {
        allow_workspace_cycles = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    debug = {
        disable_logs = false,
    },

    plugin = {

        -- ["csgo-vulkan-fix"] = {
        --     res_w     = 1280,
        --     res_h     = 960,
        --     class     = "cs2",
        --     fix_mouse = true,
        -- },
    },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "myBezier" })


---------------------
---- KEYBINDINGS ----
---------------------

local mod = "SUPER"

-- General
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q",              hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + E",      hl.dsp.exit())
hl.bind(mod .. " + Z",              hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P",              hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + SHIFT + P",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + F",              hl.dsp.window.fullscreen())
hl.bind(mod .. " + W",              hl.dsp.exec_cmd(home .. "/.config/hypr/cycle-wallpaper"))
hl.bind(mod .. " + S",              hl.dsp.exec_cmd(home .. "/.config/hypr/screenshot"))
hl.bind(mod .. " + BackSpace",      hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Keyboard layout switch (us/se)
hl.bind(mod .. " + Space", function()
    hl.exec_cmd("hyprctl switchxkblayout at-translated-set-2-keyboard next")
    hl.exec_cmd("hyprctl switchxkblayout hfd.cn-usb-device next")
end)

-- Shaders
hl.bind(mod .. " + N", function()
    hl.config({ decoration = { screen_shader = home .. "/.config/hypr/shaders/blue-light.frag" } })
end)
hl.bind(mod .. " + SHIFT + N", function()
    hl.config({ decoration = { screen_shader = "" } })
end)

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +4%"),    { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -4%"),    { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),   { locked = true })

-- Focus with mod + j/k (master layout)
hl.bind(mod .. " + J", hl.dsp.layout("cyclenext"))
hl.bind(mod .. " + K", hl.dsp.layout("cycleprev"))

-- Swap windows with mod + SHIFT + j/k
hl.bind(mod .. " + SHIFT + J", hl.dsp.layout("swapnext"))
hl.bind(mod .. " + SHIFT + K", hl.dsp.layout("swapprev"))

-- Resize master factor with mod + h/l
hl.bind(mod .. " + H", hl.dsp.layout("mfact -0.05"))
hl.bind(mod .. " + L", hl.dsp.layout("mfact +0.05"))

-- Workspace navigation
hl.bind(mod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

for i = 1, 9 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Move/resize windows with mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { drag = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { drag = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "Steam",
    match = { class = "^(steam)$" },
    tile  = true,
})

-- Fix XWayland drag issues
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})


--------------------
---- WORKSPACES ----
--------------------

hl.workspace_rule({ workspace = "1", monitor = "DP-1",     persistent = true, default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1",     persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-1",     persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-1",     persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "DP-1",     persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", persistent = true })
