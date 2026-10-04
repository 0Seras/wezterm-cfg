-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
-- config.front_end = "WebGpu"

config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 144
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type

config.font = wezterm.font("JetBrains Mono")
config.cell_width = 1
config.window_background_opacity = 0.8
config.prefer_egl = true
config.font_size = 11

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- tabs
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true

-- config.inactive_pane_hsb = {
-- 	saturation = 0.0,
-- 	brightness = 1.0,
-- }

-- actually apply your config choices
-- keymaps
config.keys = {
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = nil -- back to config.window_background_opacity
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- For example, changing the color scheme:
config.color_scheme = "Gruvbox Dark"
config.colors = {
	cursor_bg = "#ffffff", -- cursor block color
	cursor_fg = "#000000", -- color of the character under the cursor
	cursor_border = "#ffffff", -- cursor outline (matters for bar/underline styles)

	ansi = {
		"#000000", -- black
		"#f87575", -- red
		"#a6ffa6", -- green
		"#ffffff", -- yellow: change this value
		"#6f64ff", -- blue
		"#fd74fd", -- magenta
		"#8ae4ff", -- cyan
		"#ffffff", -- white
	},
	brights = {
		"#555555",
		"#ff5555",
		"#f8faf8",
		"#ffffff",
		"#5555ff",
		"#ff55ff",
		"#ffffff",
		"#ffffff",
	},
}

config.window_frame = {
	font = wezterm.font({ family = "JetBrains Mono", weight = "Regular" }),
	active_titlebar_bg = "#000000",
	-- active_titlebar_bg = "#181616",
}

-- config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_decorations = "NONE | RESIZE"
config.default_prog = { "powershell.exe", "-NoLogo" }
config.initial_cols = 80
return config