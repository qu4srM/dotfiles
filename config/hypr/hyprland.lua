-- Main Hyprland entrypoint

require("hyprland.lib")
--require("hyprland.services")

-- Environment
require("hyprland.env")

if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    require("custom.env")
end

-- Core config
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")



-- User overrides
if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    require("custom.execs")
end

if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    require("custom.general")
end

if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    require("custom.rules")
end

if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
end
