local config = {}

local wezterm = require("wezterm")

config.color_scheme = "Gruvbox Dark (Gogh)"
config.font_size = 20

config.keys = {
	-- ... your other key bindings ...

	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

return config
