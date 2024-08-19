-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.font = wezterm.font({ -- Normal text
	family = "Monaspace Neon",
	harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
})

config.font_rules = {
	{ -- Italic
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Radon",
			style = "Italic",
		}),
	},

	{ -- Bold
		intensity = "Bold",
		italic = false,
		font = wezterm.font({
			family = "Monaspace Krypton",
			weight = "Bold",
		}),
	},

	{ -- Bold Italic
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Xenon",
			style = "Italic",
			weight = "Bold",
		}),
	},
}

config.color_scheme = "Catppuccin Frappe"

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.9

return config
