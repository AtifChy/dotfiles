local wezterm = require("wezterm")
local config = wezterm.config_builder()

local colors = {
	background = "#1e222a",
	foreground = "#d7dae0",

	tab_background = "#282c34",
	hover_foreground = "#abb2bf",

	black = "#3f4451",
	red = "#e06c75",
	green = "#98c379",
	yellow = "#d19a66",
	blue = "#61afef",
	magenta = "#c678dd",
	cyan = "#56b6c2",
	white = "#d7dae0",

	bright_black = "#5a6374",
	bright_red = "#ff7a7c",
	bright_green = "#a5e075",
	bright_yellow = "#e5c07b",
	bright_blue = "#4dc4ff",
	bright_magenta = "#de73ff",
	bright_cyan = "#4cd1e0",
	bright_white = "#e6e6e6",
}

local target = wezterm.target_triple
if target:match("windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	config.default_domain = "WSL:Arch"
end

-- config.window_close_confirmation = "NeverPrompt"
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
	"wsl.exe",
	"wslhost.exe",
	"conhost.exe",
}

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.window_frame = {
	active_titlebar_bg = colors.background,
	active_titlebar_fg = colors.foreground,
	inactive_titlebar_bg = colors.background,
	inactive_titlebar_fg = colors.foreground,
}

config.window_padding = {
	left = 10,
	right = 10,
	top = 12,
	bottom = 0,
}

config.initial_rows = 36
config.initial_cols = 110

config.use_resize_increments = true

-- config.color_scheme = "OneDark (base16)"
config.colors = {
	foreground = colors.foreground,
	background = colors.background,

	-- cursor_fg = colors.background,
	-- cursor_bg = colors.foreground,
	cursor_border = colors.background,

	selection_fg = "none",
	selection_bg = "rgba(255, 255, 255, 0.2)",

	scrollbar_thumb = colors.black,
	split = colors.black,

	ansi = {
		colors.black,
		colors.red,
		colors.green,
		colors.yellow,
		colors.blue,
		colors.magenta,
		colors.cyan,
		colors.white,
	},
	brights = {
		colors.bright_black,
		colors.bright_red,
		colors.bright_green,
		colors.bright_yellow,
		colors.bright_blue,
		colors.bright_magenta,
		colors.bright_cyan,
		colors.bright_white,
	},
}

config.colors.tab_bar = {
	background = "none",

	active_tab = {
		bg_color = colors.tab_background,
		fg_color = colors.blue,
		intensity = "Bold",
	},

	inactive_tab = {
		bg_color = colors.background,
		fg_color = colors.bright_black,
	},
	inactive_tab_hover = {
		bg_color = colors.tab_background,
		fg_color = colors.hover_foreground,
	},

	new_tab = {
		bg_color = colors.background,
		fg_color = colors.bright_black,
	},
	new_tab_hover = {
		bg_color = colors.black,
		fg_color = colors.blue,
	},
}

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

config.force_reverse_video_cursor = true

config.window_background_opacity = 0
config.win32_system_backdrop = "Mica"

config.font_size = 11
config.font = wezterm.font_with_fallback({
	{
		family = "Operator Mono SSm Lig",
		weight = "Medium",
	},
	{
		family = "Symbols Nerd Font Mono",
		scale = 0.85,
	},
	"JetBrains Mono",
	"Segoe UI Symbol",
	"Segoe UI Emoji",
})
config.font_rules = {
	{
		intensity = "Half",
		italic = false,
		font = wezterm.font("Operator Mono SSm Lig", {
			weight = "Medium",
			foreground = colors.bright_black,
		}),
	},
	{
		intensity = "Half",
		italic = true,
		font = wezterm.font("Operator Mono SSm Lig", {
			weight = "Medium",
			style = "Italic",
			foreground = colors.bright_black,
		}),
	},
}

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500
config.animation_fps = 5

config.cursor_thickness = 1
config.underline_position = -2
config.underline_thickness = 2
config.strikethrough_position = "0.5cell"

-- config.tab_bar_at_bottom = true
-- config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false
config.tab_max_width = 24

config.keys = {
	{
		key = "q",
		mods = "SHIFT|CTRL",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
}

return config

-- wezterm tab title for retro tab bar
--
-- local function tab_title(tab_info)
-- 	local title = tab_info.tab_title
-- 	-- if the tab title is explicitly set, take that
-- 	if title and #title > 0 then
-- 		return title
-- 	end
-- 	-- Otherwise, use the title from the active pane
-- 	-- in that tab
-- 	return tab_info.active_pane.title
-- end
--
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local title = tab_title(tab)
--
-- 	-- ensure that the titles fit in the available space,
-- 	-- and that we have room for the edges.
-- 	local title_left = (tab.tab_index + 1) .. ":"
--
-- 	local function truncate_right(_title, _max_width)
-- 		if #_title > _max_width then
-- 			return _title:sub(1, _max_width - 1) .. "…"
-- 		end
-- 		return _title
-- 	end
--
-- 	title = truncate_right(title, max_width - #title_left - 3)
--
-- 	return {
-- 		{ Text = " " },
-- 		{ Text = title_left .. " " .. title },
-- 		{ Text = " " },
-- 	}
-- end)
