--================================== Imports ================================================
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
--=========================== Platform specific configs =====================================
local background_image
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh" }
	background_image = "C:/Users/raequ/.config/wezterm/MillionMonsters-4.jpg"
else
	config.default_prog = { "zsh" }
	-- config.window_decorations = "RESIZE"
	background_image = "/home/raequ/.config/wezterm/MillionMonsters-4.jpg"
end
--================================ Config options ===========================================
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.default_cwd = "C:/Users/raequ/Devel"
config.scrollback_lines = 5000
config.pane_focus_follows_mouse = true
--================================= Font styling ============================================
config.font = wezterm.font("MesloLGSDZ Nerd Font Propo")
config.line_height = 1
config.font_size = 16
--================================ Window styling ===========================================
config.color_scheme = "ayu"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.background = {
	{
		source = { Color="#0f1419"},
		repeat_x = 'Mirror',
		hsb = { brightness = 1, hue = 1.0, saturation = 1},
		width = "101%",
		height = "101%",
		opacity = 1.0,
	},
	{
		source = {File = background_image},
		repeat_x = 'Mirror',
		hsb = {brightness = 1.0, hue = 1.0, saturation = 1.0},
		opacity = 0.05,
	},
}
config.inactive_pane_hsb = {saturation = 0.9, brightness = 0.55,}
--================================ Tab bar styling ==========================================
bar.apply_to_config(config)
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 16
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
--================================ Keybindings ==============================================
config.keys = {
	{key = "c", mods = "LEADER", action = act.ActivateCopyMode},
--=============================== Pane bindings =============================================
	{key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain")},
	{key = "]", mods = "LEADER", action = act.ActivateTabRelative(1)},
	{key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1)},
	{key = ".", mods = "LEADER", action = act.ShowTabNavigator},
	{key = "Q", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({confirm=true})},
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
--============================== Pane bindings ==============================================
	{key = "f", mods = "LEADER", action = act.TogglePaneZoomState },
	{key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up")},
	{key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down")},
	{key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left")},
	{key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right")},
	{key = "v", mods = "LEADER", action = act.SplitVertical({domain="CurrentPaneDomain"})},
	{key = "s", mods = "LEADER", action = act.SplitHorizontal({domain="CurrentPaneDomain"})},
	{key = "q", mods = "LEADER", action = act.CloseCurrentPane({confirm=true})},
	{key = "m", mods = "LEADER", action = act.PaneSelect({mode="SwapWithActiveKeepFocus"})},
	{key = "h", mods = "ALT", action = act.AdjustPaneSize({"Left",5})},
	{key = "j", mods = "ALT", action = act.AdjustPaneSize({"Down",5})},
	{key = "k", mods = "ALT", action = act.AdjustPaneSize({"Up",5})},
	{key = "l",	mods = "ALT", action = act.AdjustPaneSize({"Right",5})},
--================================== Session bindings =======================================
  {key = "/", mods = "LEADER", action = workspace_switcher.switch_workspace()},
	{
		key = "R", mods = "LEADER|SHIFT", action = act.PromptInputLine({
			description = "Enter new name for session",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end 
			end)
		})
	},
}
--==================================== Finishing up =========================================
-- Return the config to wezterm.
return config
