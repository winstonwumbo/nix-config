-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.default_prog = { '/var/home/ruyu/.nix-profile/bin/fish', '-l' }
config.color_scheme = 'Tokyo Night Moon'

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = false

config.enable_scroll_bar = true
config.scrollback_lines = 10000
config.hide_mouse_cursor_when_typing = false
config.window_close_confirmation = 'NeverPrompt'

config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

-- and finally, return the configuration to wezterm
return config
