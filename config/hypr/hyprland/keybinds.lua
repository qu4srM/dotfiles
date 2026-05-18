require("hyprland.lib")
require("hyprland.variables")

-- Quickshell
hl.bind("SUPER + SUPER_L", hl.dsp.global("quickshell:launcherRelease"))
hl.bind("SUPER + SUPER_R", hl.dsp.global("quickshell:launcherRelease"))


hl.bind(
    "SUPER + Return",
    hl.dsp.exec_cmd(terminal),
    {
        description = "Terminal"
    }
)

hl.bind(
    "SUPER + E",
    hl.dsp.exec_cmd(fileManager),
    {
        description = "File manager"
    }
)

hl.bind(
    "SUPER + Z",
    hl.dsp.exec_cmd(browser),
    {
        description = "Browser"
    }
)

hl.bind(
    "SUPER + C",
    hl.dsp.exec_cmd(codeEditor),
    {
        description = "Code editor"
    }
)
hl.bind(
    "SUPER + SHIFT + G",
    hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/gamemode.sh"),
    {
        description = "Toggle performance mode"
    }
)
hl.bind(
    "SUPER + W",
    hl.dsp.window.close()
)

hl.bind(
    "SUPER + SHIFT + Q",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
    {
        description = "Kill Hyprland"
    }
)

hl.bind(
    "SUPER + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle"
    }),
    {
        description = "Fullscreen"
    }
)

hl.bind(
    "SUPER + D",
    hl.dsp.window.fullscreen({
        mode = "maximized",
        action = "toggle"
    })
)

hl.bind(
    "SUPER + V",
    hl.dsp.window.float({action = "toggle"})
)

hl.bind(
    "SUPER + Tab",
    hl.dsp.global("quickshell:overviewWorkspacesToggle")
)

hl.bind(
    "SUPER + A",
    hl.dsp.global("quickshell:sidebarLeftToggle")
)

hl.bind(
    "SUPER + N",
    hl.dsp.global("quickshell:sidebarRightToggle")
)

hl.bind(
    "SUPER + L",
    hl.dsp.exec_cmd("loginctl lock-session")
)

-- Move windows
hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true
    }
)

hl.bind(
    "SUPER + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true
    }
)

-- Scroll through existing workspaces

hl.bind(
    "SUPER + mouse_down",
    hl.dsp.focus({workspace = "e+1"})
)
hl.bind(
    "SUPER + mouse_up",
    hl.dsp.focus({workspace = "e-1"})
)

-- Move focus 

hl.bind(
    "SUPER + left",
    hl.dsp.focus({direction = "left"})
)
hl.bind(
    "SUPER + right",
    hl.dsp.focus({direction = "right"})
)
hl.bind(
    "SUPER + up",
    hl.dsp.focus({direction = "up"})
)
hl.bind(
    "SUPER + down",
    hl.dsp.focus({direction = "down"})
)

-- Special workspace 
hl.bind(
    "SUPER + S",
    hl.dsp.workspace.toggle_special("magic")
)
hl.bind(
    "SUPER + SHIFT + S",
    hl.dsp.window.move({workspace = "special:magic"})
)

-- Workspace switching
for i = 1, 10 do

    local numberkey = {
        10,11,12,13,14,
        15,16,17,18,19
    }

    hl.bind(
        "SUPER + code:" .. numberkey[i],

        function()
            hl.dispatch(
                hl.dsp.focus({
                    workspace = tostring(i)
                })
            )
        end
    )
end

-- Move to workspace
for i = 1, 10 do

    local numberkey = {
        10,11,12,13,14,
        15,16,17,18,19
    }

    hl.bind(
        "SUPER + SHIFT + code:" .. numberkey[i],

        function()
            hl.dispatch(
                hl.dsp.window.move({
                    workspace = tostring(i)
                })
            )
        end
    )
end

-- Laptop multimedia keys

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5")
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle")
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle")
)
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("qs -c $qsConfig ipc call brightness increment || brightnessctl s 5%+")
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("qs -c $qsConfig ipc call brightness decrement || brightnessctl s 5%-")
)

-- playerctl 
hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause")
)
hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause")
)
hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl prev")
)
hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next")
)


