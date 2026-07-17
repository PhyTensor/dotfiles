---------------------
---- KEYBINDINGS -----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local terminal    = "kitty"
local fileManager = "yazi"
local menu        = "wofi --show drun"

--------------------
---- NIRI-STYLE ----
----  (SUPER)   ----
--------------------

local super = "SUPER"

hl.bind(super .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(super .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(super .. " + Q", hl.dsp.window.close())
hl.bind(super .. " + SHIFT + E", hl.dsp.exit())

-- Screenlock (uncommented from niri's commented-out bind)
-- hl.bind(super .. " + X", hl.dsp.exec_cmd("hyprlock"))

-- Vim-style focus movement (H/L left/right, A/D as alts)
hl.bind(super .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(super .. " + A", hl.dsp.focus({ direction = "left" }))
hl.bind(super .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(super .. " + D", hl.dsp.focus({ direction = "right" }))

-- Move window left/right
hl.bind(super .. " + CTRL + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(super .. " + CTRL + L", hl.dsp.window.move({ direction = "right" }))

-- Focus monitor (Vim-style)
hl.bind(super .. " + SHIFT + H", hl.dsp.focus({ monitor = "left" }))
hl.bind(super .. " + SHIFT + L", hl.dsp.focus({ monitor = "right" }))
hl.bind(super .. " + SHIFT + J", hl.dsp.focus({ monitor = "down" }))
hl.bind(super .. " + SHIFT + K", hl.dsp.focus({ monitor = "up" }))

-- Workspace navigation (N = next/scroll-down, P = prev/scroll-up)
hl.bind(super .. " + N", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(super .. " + P", hl.dsp.focus({ workspace = "e-1" }))

-- Move window to next/prev workspace
hl.bind(super .. " + CTRL + N", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(super .. " + CTRL + P", hl.dsp.window.move({ workspace = "-1" }))

-- Switch to workspace [1-9] / move window to workspace [1-9]
for i = 1, 9 do
    hl.bind(super .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(super .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end

-- Fullscreen (toggle between workspace/monitor fullscreen)
hl.bind(super .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(super .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Toggle floating
hl.bind(super .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Screenshots
hl.bind("Print",                        hl.dsp.exec_cmd("grim"))
hl.bind("CTRL + Print",                 hl.dsp.exec_cmd("grim -g \"$(slurp)\""))
-- hl.bind("ALT + Print",               hl.dsp.exec_cmd("grim -g \"$(slurp -o)\""))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


---------------------
---- ALT-STYLE ----
----  (Legacy)  ----
---------------------

local alt = "ALT"

hl.bind(alt .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(alt .. " + C", hl.dsp.window.close())
hl.bind(alt .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(alt .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(alt .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(alt .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(alt .. " + P", hl.dsp.window.pseudo())
hl.bind(alt .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(alt .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(alt .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(alt .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(alt .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(alt .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(alt .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

hl.bind(alt .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(alt .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(alt .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(alt .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(alt .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(alt .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
