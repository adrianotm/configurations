{ config, pkgs, ... }:
let my-theme = import ./theme.nix;
in {
  home.file.".config/waybar/config".text = ''
        {
          "layer": "bottom",
          "position": "top",

          // If height property would be not present, it'd be calculated dynamically
          "height": 32,

          "modules-left": [
              "sway/workspaces",
              "sway/mode"
          ],
          "modules-center": [
              "sway/window"
          ],
          "modules-right": [
              "network",
              "memory",
              "cpu",
              "temperature",
              "backlight",
              "pulseaudio",
              "battery",
              "tray",
              "clock#date",
              "clock#time",
              "custom/notification",
              "inhibitor"
          ],

          "backlight": {
              "format": " {percent}%",
              "interval": 2,
              "on-scroll-up": "brightnessctl set +2%",
              "on-scroll-down": "brightnessctl set 2%-"
          },

          "battery": {
              "interval": 10,
              "states": {
                  "warning": 35,
                  "critical": 15
              },
              // Connected to AC
              "format": " {icon} {capacity}%", // Icon: bolt
              // Not connected to AC
              "format-discharging": "{icon} {capacity}%",
              "format-icons": [
                  "", // Icon: battery-full
                  "", // Icon: battery-three-quarters
                  "", // Icon: battery-half
                  "", // Icon: battery-quarter
                  ""  // Icon: battery-empty
              ],
              "tooltip": true
          },

          "clock#time": {
              "interval": 10,
              "format": "{:%H:%M}",
              "tooltip": false
          },

          "clock#date": {
            "interval": 10,
            "format": " {:%e %b %Y}", // Icon: calendar-alt
            "tooltip-format": "{:%e %B %Y}",
            "locale": "en_US.UTF-8",
            "timezone": "Europe/Amsterdam",
          },

          "cpu": {
              "interval": 3,
              "format": " {usage}%", // Icon: microchip
              "states": {
                "warning": 70,
                "critical": 90
              },
          },

          "custom/keyboard-layout": {
            "exec": "swaymsg -t get_inputs | grep -m1 'xkb_active_layout_name' | cut -d '\"' -f4 | cut -d ' ' -f1",
            // Interval set only as a fallback, as the value is updated by signal
            "interval": 10,
            "format": " {}", // Icon: keyboard
            // Signal sent by Sway key binding (~/.config/sway/key-bindings)
            "signal": 1, // SIGHUP
            "tooltip": false,
            "on-click": "swaymsg input type:keyboard xkb_switch_layout next",
            "on-scroll-up": "swaymsg input type:keyboard xkb_switch_layout next",
            "on-scroll-down": "swaymsg input type:keyboard xkb_switch_layout prev",
          },

          "memory": {
              "interval": 3,
              "format": "Mem: {}%", // Icon: memory
              "states": {
                  "warning": 70,
                  "critical": 90
              }
          },

          "network": {
              "interval": 3,
              "format-wifi": "  {essid}", // Icon: wifi
              "format-ethernet": "🖧  {ifname}: {ipaddr}/{cidr}", // Icon: ethernet
              "format-disconnected": "⚠  Disconnected",
              "tooltip-format": "{ifname}: {ipaddr} (signal: {signalStrength}%)"
          },

          "pulseaudio": {
              "scroll-step": 2,
              "format": "{icon} {volume}%",
              "format-bluetooth": "{icon} {volume}%",
              "format-muted": "󰖁 Muted", // Icon: volume-mute
              "format-icons": {
                 "headphones": "",
                 "handsfree": "",
                 "headset": "",
                 "phone": "",
                 "portable": "",
                 "car": "",
                 "default": ["", ""]
              },
              "on-click": "pactl set-sink-mute @DEFAULT_SINK@ toggle",
              "on-click-right": "pavucontrol",
              "scroll-step": 1,
              "tooltip": true
          },

          "sway/mode": {
              "format": "<span style=\"italic\"> {}</span>", // Icon: expand-arrows-alt
              "tooltip": false
          },

          "sway/window": {
              "format": "{}",
              "max-length": 120
          },

          "sway/workspaces": {
              "all-outputs": false,
              "disable-scroll": true,
              "format": "{icon} {name}",
              "format-icons": {
                  "1:WWW": "", // Icon: firefox-browser
                  "2:Editor": "", // Icon: code
                  "3:Terminals": "", // Icon: terminal
                  "4:Mail": "", // Icon: mail
                  "8:Documents": "", // Icon: book
                  "9:Multimedia": "", // Icon: music
                  "urgent": "",
                  "focused": "",
                  "default": ""
              }
          },

          "temperature": {
            "critical-threshold": 75,
            "interval": 3,
            "format": "{icon} {temperatureC}°C",
            "format-icons": [
                "", // Icon: temperature-empty
                "", // Icon: temperature-quarter
                "", // Icon: temperature-half
                "", // Icon: temperature-three-quarters
                ""  // Icon: temperature-full
            ],
            "tooltip": true
          },

          "tray": {
              "icon-size": 21,
              "spacing": 10
          },

          "custom/notification": {
            "tooltip": false,
            "format": "{icon}",
            "format-icons": {
              "notification": "<span foreground='red'><sup></sup></span>",
              "none": "",
              "dnd-notification": "<span foreground='red'><sup></sup></span>",
              "dnd-none": "",
              "inhibited-notification": "<span foreground='red'><sup></sup></span>",
              "inhibited-none": "",
              "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
              "dnd-inhibited-none": ""
            },
            "return-type": "json",
            "exec-if": "which swaync-client",
            "exec": "swaync-client -swb",
            "on-click": "swaync-client -t -sw",
            "on-click-right": "swaync-client -d -sw",
            "escape": true
          },

          "inhibitor": {
    	"what": "idle",
    	"format": "{icon}",
    	"format-icons": {
    		"activated": "",
    		"deactivated": ""
    	}
          }
        }
  '';

  home.file.".config/waybar/style.css".text = ''
    @keyframes blink-warning {
        70% { color: white; }
        to { color: white; background-color: orange; }
    }

    @keyframes blink-critical {
        70% { color: white; }
        to { color: white; background-color: red; }
    }

    /* Reset all styles */
    * {
        border: none;
        border-radius: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
    }

    #waybar {
        background-color: ${my-theme.colors.unfocused-bg};
        color: ${my-theme.colors.active-text}; 
        font-family: ${my-theme.fonts.normal-name};
        font-size: 14px;
    }

    /* Module Styles */

    #backlight,
    #battery,
    #clock,
    #cpu,
    #custom-keyboard-layout,
    #idle_inhibitor,
    #memory,
    #mode,
    #network,
    #pulseaudio,
    #temperature,
    #tray {
        margin-left: 18px;
    }

    #backlight {
        /* No styles */
    }

    #battery {
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #battery.warning { color: orange; }
    #battery.critical { color: red; }
    #battery.warning.discharging {
        animation-name: blink-warning;
        animation-duration: 3s;
    }

    #battery.critical.discharging {
        animation-name: blink-critical;
        animation-duration: 2s;
    }

    #clock {
        /* No styles */
    }

    #clock.time {
        margin-left: 12px;
        margin-right: 12px;
        min-width: 60px;
    }

    #custom-notification {
      margin-right: 12px;
    }

    #inhibitor {
      margin-right: 12px;
    }

    #cpu {
      /* No styles */
    }

    #cpu.warning { color: orange; }
    #cpu.critical { color: red; }
    #custom-keyboard-layout { margin-left: 22px; }

    #memory {
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #memory.warning { color: orange; }
    #memory.critical {
        color: red;
        animation-name: blink-critical;
        animation-duration: 2s;
    }

    #mode {
        color: ${my-theme.colors.urgent-text};
        background-color: ${my-theme.colors.urgent-bg};
        margin-left: 0;
        /* To compensate for the top border and still have vertical centering */
        padding: 0 16px;
    }

    #network { /* No styles */ }
    #network.disconnected { color: orange; }

    #pulseaudio { /* No styles */ }
    #pulseaudio.muted { /* No styles */ }

    #temperature { /* No styles */ }
    #temperature.critical { color: red; }

    #tray { /* No styles */ }

    #window {
        margin-left: 32px;
        margin-right: 32px;
    }

    #workspaces button {
        border-top: 2px solid transparent;
        /* To compensate for the top border and still have vertical centering */
        padding-bottom: 2px;
        padding-left: 15px;
        padding-right: 18px;
        color: ${my-theme.colors.inactive-text};
    }

    #workspaces button:hover {
        /* Reset all hover styles */
        background: inherit;
        box-shadow: inherit;
        text-shadow: inherit;
    }

    #workspaces button.visible {
        border-color: ${my-theme.colors.inactive-border};
        color: ${my-theme.colors.inactive-text}; 
        background-color: ${my-theme.colors.inactive-bg}; 
    }

    #workspaces button.focused {
        border-color: ${my-theme.colors.active-border};
        color: ${my-theme.colors.active-text};
        background-color: ${my-theme.colors.active-bg};
    }

    #workspaces button.urgent {
        border-color: ${my-theme.colors.urgent-border};
        color: ${my-theme.colors.urgent-text};
        background-color: ${my-theme.colors.urgent-bg};
    }'';

}
