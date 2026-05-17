-- Hyprland Lua configuration
-- Converted from hyprland.conf
-- Refer to https://wiki.hypr.land/Configuring/Start/


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

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
  hl.exec_cmd("swaybg -o '*' -i ~/wallpaper/sfondi/Flat/arcify-2560x1600.png -m fill -c '#350066'")
  hl.exec_cmd("waybar --config ~/.config/waybar/config-hyprland --style ~/.config/waybar/style-hyprland.css")

  -- hl.exec_cmd([[swayidle -w \\
  --        timeout 120 '~/scripts/linux/sway/sway-lock.sh' \\
  --        timeout 130 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \\
  --        before-sleep '~/scripts/linux/sway/sway-lock.sh']])

  -- notifications
  hl.exec_cmd("mako")
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
    resize_on_border = true,

    gaps_in          = 6,
    gaps_out         = 12,
    border_size      = 8,

    col              = {
      active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    layout           = "dwindle",
  },

  decoration = {
    rounding = 4,

    blur = {
      enabled = true,
      size    = 3,
      passes  = 1,
    },

    shadow = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },
  },

  animations = {
    enabled = true,
  },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = false, speed = 3, bezier = "default" })


----------------
---- LAYOUT ----
----------------

hl.config({
  dwindle = {
    preserve_split = true, -- you probably want this
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
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("wofi --show drun"))

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
