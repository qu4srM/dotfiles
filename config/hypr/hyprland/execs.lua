hl.on("hyprland.start", function ()

    -- Start Quickshell
    hl.exec_cmd("qs -c $qsConfig")

    -- Lock / idle
    hl.exec_cmd("hypridle")

    -- Keyring
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")

    -- Audio effects
    hl.exec_cmd("easyeffects --hide-window --service-mode")

    -- Clipboard
    hl.exec_cmd(
        "wl-paste --type text --watch cliphist store"
    )

    hl.exec_cmd(
        "wl-paste --type image --watch cliphist store"
    )

    -- Cursor
    hl.exec_cmd(
        "hyprctl setcursor Bibata-Modern-Classic 24"
    )
end)