--[[ ========================================================================================
                                        Imports
=========================================================================================]]--

local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

--[[ ========================================================================================
                                    Utility functions
=========================================================================================]]--

local function themeCycler(window, _)
	local allSchemes = wezterm.color.get_builtin_schemes()
	local currentMode = wezterm.gui.get_appearance()
	local currentScheme = window:effective_config().color_scheme
	local darkSchemes = {}
	local lightSchemes = {}

	for name, scheme in pairs(allSchemes) do
		if scheme.background then
			local bg = wezterm.color.parse(scheme.background) -- parse into a color object
			---@diagnostic disable-next-line: unused-local
			local h, s, l, a = bg:hsla() -- and extract HSLA information
			if l < 0.4 then
				table.insert(darkSchemes, name)
			else
				table.insert(lightSchemes, name)
			end
		end
	end
	local schemesToSearch = currentMode:find("Dark") and darkSchemes or lightSchemes

	for i = 1, #schemesToSearch, 1 do
		if schemesToSearch[i] == currentScheme then
			local overrides = window:get_config_overrides() or {}
			overrides.color_scheme = schemesToSearch[i + 1]
			wezterm.log_info("Switched to: " .. schemesToSearch[i + 1])
			window:set_config_overrides(overrides)
			return
		end
	end
end

--[[ ========================================================================================
                                Session manager functions
=========================================================================================]]--

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
  local workspace_state = resurrect.workspace_state
  
  workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
    window = window,
    relative = true,
    restore_text = true,
    on_pane_restore = resurrect.tab_state.default_on_pane_restore,
  })
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
  local workspace_state = resurrect.workspace_state
  resurrect.save_state(workspace_state.get_workspace_state())
end)

--[[ ========================================================================================
                                Platform specific configs
=========================================================================================]]--

local background_image

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh" }
	background_image = "C:/Users/raequ/.config/wezterm/MillionMonsters-4.jpg"
	resurrect.change_state_save_dir("C:/Users/raequ/.config/wezterm/session_state/")
else
	config.default_prog = { "zsh" }
	-- config.window_decorations = "RESIZE"
	background_image = "/home/raequ/.config/wezterm/MillionMonsters-4.jpg"
end

--[[ ========================================================================================
                                    Config options
=========================================================================================]]--

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.default_cwd = "~/Devel"
config.scrollback_lines = 5000
config.pane_focus_follows_mouse = true

--[[ ========================================================================================
                                    Font styling
=========================================================================================]]--

config.font = wezterm.font("MesloLGSDZ Nerd Font Propo")
config.line_height = 1
config.font_size = 13

--[[ ========================================================================================
                                    Window styling
=========================================================================================]]--

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
		width = "100%",
		height = "100%",
		opacity = 1.0,
	},
	{
		source = { File = background_image },
		repeat_x = 'Mirror',
		hsb = { brightness = 1.0, hue = 1.0, saturation = 1.0 },
		opacity = 0.05,
	},
}

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.55,
}

--[[ ========================================================================================
                                   Tab bar styling
=========================================================================================]]--
bar.apply_to_config(config)
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 16
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
-- config.colors = {
-- 	tab_bar = {

-- 		background = "#131621",

-- 			active_tab = {
-- 				bg_color = "#2d3640",
-- 				fg_color = "#bfbdb6",
-- 				italic = false,
-- 			},
-- 			inactive_tab = {
-- 				bg_color = "#0f1419",
-- 				fg_color = "#5c6773",
-- 			}
-- 	}
-- }

--[[ ========================================================================================
                                   Multiplexing
=========================================================================================]]--

config.unix_domains = {
	{
		name = "unix",
	},
}

config.default_gui_startup_args = { "connect", "unix" }

--[[ ========================================================================================
                                   Keybindings
=========================================================================================]]--

config.keys = {
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	{
		key = "f",
		mods = "ALT",
		action = act.TogglePaneZoomState,
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = ",",
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
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	{
		key = "&",
		mods = "LEADER|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "4",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "2",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "q",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "h",
		mods = "ALT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "j",
		mods = "ALT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{ key = "k", mods = "ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{
		key = "l",
		mods = "ALT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		-- |
		key = "{",
		mods = "LEADER|SHIFT",
		action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	{
		key = "a",
		mods = "LEADER",
		action = act.AttachDomain("unix"),
	},

	-- Detach from muxer
	{
		key = "d",
		mods = "LEADER",
		action = act.DetachDomain({ DomainName = "unix" }),
	},
	-- Rename current session
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for session",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
	-- Show list of sessions
  {
    key = "s",
    mods = "LEADER",
    action = workspace_switcher.switch_workspace(),
  },
	  {
	    key = "S",
	    mods = "LEADER|SHIFT",
	    action = wezterm.action_callback(function(win, pane)
	        resurrect.save_state(resurrect.workspace_state.get_workspace_state())
	        resurrect.window_state.save_window_action()
	    end),
	  },
    {
    key = "L",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_load(win, pane, function(id, label)
        local type = string.match(id, "^([^/]+)") -- match before '/'
        id = string.match(id, "([^/]+)$") -- match after '/'
        id = string.match(id, "(.+)%..+$") -- remove file extension
        local state
        if type == "workspace" then
          state = resurrect.load_state(id, "workspace")
          resurrect.workspace_state.restore_workspace(state, {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        elseif type == "window" then
          state = resurrect.load_state(id, "window")
          resurrect.window_state.restore_window(pane:window(), state, {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
            -- uncomment this line to use active tab when restoring
            -- tab = win:active_tab(),
          })
        end
      end)
    end),
  },
}

-- Return the config to wezterm.
return config
