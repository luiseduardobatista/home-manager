local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.window_decorations = "RESIZE"
config.color_scheme = "Gruvbox Dark (Gogh)"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.show_tabs_in_tab_bar = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.enable_tab_bar = false
config.max_fps = 165
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.colors = {}
config.keys = {
	{
		mods = "LEADER",
		key = "v",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		mods = "CTRL|SHIFT",
		key = "m",
		action = act.TogglePaneZoomState,
	},
}

return config
