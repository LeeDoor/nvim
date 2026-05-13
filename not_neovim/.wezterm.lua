local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = 'Apple System Colors'
config.font = wezterm.font('Iosevka Nerd Font', {})
config.keys = {
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
}

table.insert(config.keys, {
  key = 'r',
  mods = 'CTRL|SHIFT',
  action = act.RotatePanes 'Clockwise',
})

for i = 1, 8 do
  table.insert(config.keys, {
    key = 'F' .. tostring(i),
    action = act.ActivateTab(i - 1),
  })
end
for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action.MoveTab(i - 1),
  })
end

return config