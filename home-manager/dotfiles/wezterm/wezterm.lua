local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "tokyonight_night"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14

config.colors = {
	background = "#000",
}

config.window_decorations = "NONE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- tab bar
config.hide_tab_bar_if_only_one_tab = true
-- config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false

config.max_fps = 120
config.animation_fps = 120

config.use_dead_keys = false

-- config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2002 }

local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	-- O mod foi alterado para LEADER para consistência,
	-- mantendo a lógica da sua função original.
	local mods = (resize_or_move == "resize") and "LEADER|SHIFT" or "LEADER"
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				local vim_mods = (resize_or_move == "resize") and "CTRL|SHIFT" or "CTRL"
				win:perform_action({ SendKey = { key = key, mods = vim_mods } }, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.keys = {
	-- { mods = "LEADER", key = "c", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	-- { mods = "LEADER", key = "q", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	-- { mods = "LEADER", key = "b", action = wezterm.action.ActivateTabRelative(-1) },
	-- { mods = "LEADER", key = "n", action = wezterm.action.ActivateTabRelative(1) },
	-- { mods = "LEADER", key = "|", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- { mods = "LEADER", key = "-", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- { mods = "LEADER", key = "m", action = wezterm.action.TogglePaneZoomState },
	-- {
	-- 	mods = "LEADER",
	-- 	key = "r",
	-- 	action = wezterm.action.PromptInputLine({
	-- 		description = "Renomear a aba",
	-- 		action = wezterm.action_callback(function(window, pane, line)
	-- 			if line then
	-- 				window:active_tab():set_title(line)
	-- 			end
	-- 		end),
	-- 	}),
	-- },
	--
	-- -- move between split panes
	-- split_nav("move", "h"),
	-- split_nav("move", "j"),
	-- split_nav("move", "k"),
	-- split_nav("move", "l"),
	--
	-- -- resize panes
	-- split_nav("resize", "h"),
	-- split_nav("resize", "j"),
	-- split_nav("resize", "k"),
	-- split_nav("resize", "l"),
}

-- leader + number to activate that tab
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " LEADER"
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	-- arrow color based on if tab is first pane
	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Foreground = { Color = "#1e1e2e" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

return config
