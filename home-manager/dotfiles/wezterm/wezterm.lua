local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "rose-pine"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14
config.max_fps = 120
config.animation_fps = 120
config.use_dead_keys = true
config.enable_wayland = false
config.window_decorations = "RESIZE"
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2002 }
config.window_padding = { right = 0, top = 0, bottom = 0 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "v",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "CTRL|SHIFT",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "CTRL|SHIFT",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "CTRL|SHIFT",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "CTRL|SHIFT",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		mods = "CTRL|SHIFT",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},

	{
		mods = "LEADER",
		key = "r",
		action = wezterm.action.PromptInputLine({
			description = "Renomear a aba",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

for i = 0, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

return config
