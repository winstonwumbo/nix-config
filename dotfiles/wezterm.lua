-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night Moon'

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = false

config.enable_scroll_bar = true
config.scrollback_lines = 10000
config.hide_mouse_cursor_when_typing = false
config.window_close_confirmation = 'NeverPrompt'

-- and finally, return the configuration to wezterm
return config
