-- Hyprland Lua configuration
-- Converted from hyprland.conf
-- Refer to https://wiki.hypr.land/Configuring/Start/

local font = "LektonNerdFontMono"
local font_size = 12

--  Base16 Woodland
--  Author: Jay Cornwall (https://jcornwall.com)

local base00 = "#231e18"
local base01 = "#302b25"
-- local base02 = "#48413a"
-- local base03 = "#9d8b70"
-- local base04 = "#b4a490"
-- local base05 = "#cabcb1"
-- local base06 = "#d7c8bc"
-- local base07 = "#e4d4c8"
-- local base08 = "#d35c5c"
-- local base09 = "#ca7f32"
local base0A = "#e0ac16"
-- local base0B = "#b7ba53"
-- local base0C = "#6eb958"
-- local base0D = "#88a4d3"
-- local base0E = "#bb90e2"
-- local base0F = "#b49368"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland,;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.env("GTK_THEME", "Qogir-Round-Dark")
hl.env("XCURSOR_SIZE", "Qogir-dark")
hl.env("XCURSOR_SIZE", "24")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output   = "HDMI-A-1",
  mode     = "3840x2160@60.00",
  position = "0x0",
  scale    = 2,
})
-- hl.monitor({
--     output   = "HDMI-A-1",
--     mode     = "1920x1080@120.000",
--     position = "0x0",
--     scale    = 1,
-- })


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  -- hl.exec_cmd("swaybg -o '*' -i ~/wallpaper/sfondi/Flat/arcify-2560x1600.png -m fill -c '#350066'")
  hl.exec_cmd("waybar --config ~/.config/waybar/config-hyprland --style ~/.config/waybar/style-hyprland.css")

  -- notifications
  hl.exec_cmd("mako")

  -- hyprlock is started by hypridle when needed
  hl.exec_cmd("hypridle")
end)


---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout      = "us",
    kb_variant     = "",
    kb_model       = "",
    kb_options     = "",
    kb_rules       = "",
    repeat_delay   = 240,
    repeat_rate    = 40,

    follow_mouse   = 1,

    sensitivity    = 0, -- -1.0 - 1.0, 0 means no modification.
    natural_scroll = true,

    touchpad       = {
      natural_scroll = false,
    },
  },
})


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    resize_on_border = false,

    gaps_in          = 0,
    gaps_out         = 0,
    border_size      = 0,

    col              = {
      active_border   = base0A,
      inactive_border = base01,
    },

    layout           = "dwindle",
  },

  decoration = {
    rounding = 0,

    blur = {
      enabled = false,
      size    = 3,
      passes  = 1,
    },

    shadow = {
      enabled      = false,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },
  },

  animations = {
    enabled = false,
  },
})

-- on workspace with multiple windows show borders and gaps
hl.workspace_rule({
  workspace = "w[2-100]",
  gaps_out = 12,
  gaps_in = 6,
  border_size = 6
})
hl.workspace_rule({
  workspace = "w[f1-100]",
  gaps_out = 12,
  gaps_in = 6,
  border_size = 6,
})

-- hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
--
-- hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "myBezier" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
-- hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
-- hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
-- hl.animation({ leaf = "workspaces", enabled = false, speed = 3, bezier = "default" })


----------------
---- LAYOUT ----
----------------

hl.config({
  dwindle = {
    -- 0 -> split follows mouse, 1 -> always split to the left (new = left or top) 2 -> always split to the right (new = right or bottom)
    force_split = 2,
    preserve_split = true, -- you probably want this
    permanent_direction_override = true,
  },
})

hl.config({
  master = {
    new_status = "master",
  },
})


----------------
---- DEVICE ----
----------------

-- Example per-device config
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
-- hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd([[
  GTK_THEME=Qogir-Round-Dark QT_QPA_PLATFORM=wayland MOZ_ENABLE_WAYLAND=1 bemenu-run \
  --ignorecase --list 10 --counter always \
  --fn ']] .. font .. " " .. tostring(font_size) .. [[' \
  --center --fixed-height \
  --border 2 --margin 22 --line-height 34 --ch 18 --cw 9 --width-factor 0.6 \
  --bdr ']] .. base0A .. [[' \
  --tf ']] .. base0A .. [[' \
  --hb ']] .. base0A .. [[' \
  --hf ']] .. base00 .. [['
]]))

-- Volume / mute
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Move focus with mainMod + h/j/k/l
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.swap({ direction = "down" }))

hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + s", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + p", hl.dsp.window.pseudo()) -- dwindle

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Toggle to previous workspace
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "previous" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-----------------------
---- MISC -------------
-----------------------

-- controls the VRR (Adaptive Sync) of your monitors. 0 - off, 1 - on, 2 - fullscreen only, 3 - fullscreen with video or game content type [0/1/2/3]
hl.config({
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
    background_color = base00,
    allow_session_lock_restore = true,
    key_press_enables_dpms = true,
    vrr = 3
  }
})


-----------------------
---- RENDER -----------
-----------------------

hl.config({
  render = {
    direct_scanout = 2
  }
})
