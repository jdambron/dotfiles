-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Frappe"

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.9

return config
