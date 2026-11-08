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
config.term = "xterm-256color"

config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font("Monocraft Nerd Font")
-- config.font = wezterm.font("Iosevka")
-- config.font = wezterm.font("Iosevka Custom")
config.cell_width = 1
config.cell_width = 1
config.window_background_opacity = 0.8
config.prefer_egl = true
config.font_size = 10

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


-- color schemes change (Ctrl+Alt+N)
-- https://wezterm.org/colorschemes
-- schemes list
local schemes = {
	"nord",
	"catppuccin-latte",
	"Everforest Dark (Gogh)",
	"Tokyo Night",
	"Gruvbox dark, pale (base16)",
	"Kanagawa (Gogh)",
}

-- pywal auto skin if not using
config.color_schemes = {}
local wal_toml = wezterm.home_dir .. "/.cache/wal/colors-wezterm.toml"
local wal_f = io.open(wal_toml, "r")
if wal_f then
	wal_f:close()
	local ok, loaded = pcall(wezterm.color.load_scheme, wal_toml)
	if ok and loaded then
		loaded.background = "#000000"
		loaded.cursor_bg = "#ffffff"
		loaded.cursor_fg = "#a1a1a1"
		loaded.cursor_border = "#a1a1a1"
		config.color_schemes["pywal"] = loaded
		table.insert(schemes, "pywal")
		wezterm.log_info("pywal16 scheme loaded from " .. wal_toml)
	else
		wezterm.log_info("pywal16 toml load failed")
	end
else
	wezterm.log_info("pywal16 toml not found: " .. wal_toml)
end

-- default scheme
config.color_scheme = "pywal" --change to any on scheme list default is pywal
config.bold_brightens_ansi_colors = false

-- background + cursor override if adding foreground theme gonna bug cus pywal
config.colors = {
	background = "rgba(0, 0, 0, 0.8)", -- 
	cursor_bg = "#ffffff",
	cursor_fg = "#a1a1a1",
	cursor_border = "#a1a1a1",
}

-- mouse: Alt + left mouse to drag terminal
config.mouse_bindings = {
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "ALT",
		action = act.StartWindowDrag,
	},
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
	{ key = "z", mods = "ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "x", mods = "ALT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "c", mods = "ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "v", mods = "ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "l", mods = "ALT", action = act.PaneSelect },
	{ key = "d", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "0", mods = "CTRL", action = act.ShowDebugOverlay },
	{ key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },
	{
		key = "o",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = nil
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
	{
		key = "n",
		mods = "CTRL|ALT",
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
			overrides.colors = nil
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
-- config.window_background_image = "C:/Users/DELL/.config/Wallpapers/16.png"
-- config.window_background_image_hsb = {
-- brightness = 0.1,
-- }

-- wezterm.on("gui-startup", function(cmd)
-- 	local args = {}
-- 	if cmd then
-- 		args = cmd.args
-- 	end
--
-- 	local tab, pane, window = mux.spawn_window(cmd or {})
-- 	-- window:gui_window():maximize()
-- 	-- window:gui_window():set_position(0, 0)
-- end)

return config
