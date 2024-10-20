-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- All configs here

-- Color Schemes
-- config.color_scheme = 'AdventureTime'
-- config.color_scheme = 'Batman'
-- config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'Andromeda'
config.color_scheme = 'Aci (Gogh)'

config.window_background_opacity = 0.95
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'AlwaysPrompt'

config.scrollback_lines = 3000

config.default_workspace = "home"


config.use_fancy_tab_bar = true
config.enable_tab_bar = true

-- config.font_size = 16.0
config.font = wezterm.font("FiraCode Nerd Font Mono")

config.keys = {
    {
        key = 'f',
        mods = 'CTRL',
        action = wezterm.action.ToggleFullScreen,
    },
}

config.mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

return config
