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

-- color schemes (Ctrl+Alt+N)
-- https://wezterm.org/colorschemes
local schemes = {
	"nord",
	"catppuccin-mocha",
	"Everforest Dark (Gogh)",
	"Gruvbox Dark",
}

-- base scheme terminal
config.color_scheme = "Gruvbox Dark"
bold_brightens_ansi_colors = false

config.colors = {
	foreground = "#ECEFF4", -- text color
	cursor_bg = "#ffffff", -- cursor block color
	cursor_fg = "#202621", -- color of the character under the cursor
	cursor_border = "#ffffff", -- cursor outline (matters for bar/underline styles)
}

-- keymaps
config.keys = {
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "z",
		mods = "ALT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "x",
		mods = "ALT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "c",
		mods = "ALT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "v",
		mods = "ALT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "l", mods = "ALT", action = act.PaneSelect },
	{ key = "d", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "0", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "o",
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
	{
		key = "n",
		mods = "CTRL|ALT",
		-- cycle through color schemes
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			local current = overrides.color_scheme or window:effective_config().color_scheme
			local idx = 0
			for i, name in ipairs(schemes) do
				if name == current then
					idx = i
					break
				end
			end
			overrides.color_scheme = schemes[idx % #schemes + 1]
			window:set_config_overrides(overrides)
		end),
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
