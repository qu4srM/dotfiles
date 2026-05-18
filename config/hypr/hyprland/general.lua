-- Monitor
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1"
})

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "swipe",
    action = "move"
},{
    fingers = 4,
    direction = "pinch",
    action = "float"
})

hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace"
})

hl.gesture({
    fingers = 4,
    direction = "up",
    action = function()
        hl.dispatch(
            hl.dsp.global("quickshell:overviewWorkspacesToggle")
        )
    end
})

hl.gesture({
    fingers = 4,
    direction = "down",
    action = function()
        hl.dispatch(
            hl.dsp.global("quickshell:overviewWorkspacesToggle")
        )
    end
})
-- Main config
hl.config({

    general = {
        gaps_in = 4,
        gaps_out = 5,
        gaps_workspaces = 50,

        border_size = 2,

        col = {
            active_border = "rgba(44464f77)",
            inactive_border = "rgba(1a1b2033)"
        },

        resize_on_border = true,
        no_focus_fallback = true,
        allow_tearing = true,

        snap = {
            enabled = true,
            window_gap = 4,
            monitor_gap = 5,
            respect_gaps = true
        }
    },

    decoration = {

        rounding_power = 1,
        rounding = 20,

        blur = {
            enabled = true,
            size = 2,
            passes = 1,
            new_optimizations = true,
            special = false,
            ignore_opacity = false,
            noise = 0.05, -- 0.01
            contrast = 0.89,
            vibrancy = 0.5,
            xray = false,
            brightness = 1,
            popups = true,
            popups_ignorealpha = 0.6,
            input_methods = true,
            input_methods_ignorealpha = 0.8
        },

        shadow = {
            enabled = true,
            range = 18,
            offset = {0, 2},
            render_power = 3,
            color = "rgba(1a1a1aaf)"
        },

        dim_inactive = true,
        dim_strength = 0.025,
        dim_special = 0.07
    },

    animations = {
        enabled = true
    },

    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false
    },

    input = {

        kb_layout = "latam",
        numlock_by_default = true,

        repeat_delay = 250,
        repeat_rate = 35,

        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.7
        }
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = "rgba(121318FF)",
        --vfr = 1,
        vrr = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_swallow = false,
        --swallow_regex = (foot|kitty|allacritty|Alacritty),
        --new_window_takes_over_fullscreen = 2,
        allow_session_lock_restore = true,
        session_lock_xray = true,
        initial_workspace_tracking = false,
        focus_on_activate = true
    },
    xwayland = {
        force_zero_scaling = true
    }
    
})

-- Curves
hl.curve("expressiveDefaultSpatial", {
    type = "bezier",
    points = {
        {0.38, 1.21},
        {0.22, 1.00}
    }
})

hl.curve("emphasizedDecel", {
    type = "bezier",
    points = {
        {0.05, 0.7},
        {0.1, 1}
    }
})

-- Window animations
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "popin 80%"
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2,
    bezier = "emphasizedDecel",
    style = "popin 90%"
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 3,
    bezier = "emphasizedDecel",
    style = "slide"
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "expressiveDefaultSpatial",
    style = "slide"
})
