-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices


config.default_prog = { '/bin/bash' }
config.color_scheme = 'Catppuccin Frappe'
config.font = wezterm.font("Monaspace Argon", { weight = "Regular" })
config.font_rules = {
  {
    italic = true,
    font = wezterm.font("Monaspace Radon", { weight = "Medium" }),
  },
}
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.8
config.harfbuzz_features = { "calt", "dlig", "clig=1", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }

-- and finally, return the configuration to wezterm
return config
