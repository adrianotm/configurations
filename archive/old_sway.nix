{ config, lib, pkgs, ... }:

let
  lockCmd = "swaylock -f -F -e -k -c 000000";

  dunstifyVolumeDecrease = "(pactl set-sink-volume @DEFAULT_SINK@ -2%)";
  dunstifyVolumeIncrease = "(pactl set-sink-volume @DEFAULT_SINK@ +2%)";
  dunstifyVolumeMute = "(pactl set-sink-mute @DEFAULT_SINK@ toggle)";

  dunstifyBrightnessDecrease = "(brightnessctl set 1%-)";
  dunstifyBrightnessIncrease = "(brightnessctl set 1%+)";

  grimScreenshotSave =
    "(~/.nix-profile/bin/slurp | ~/.nix-profile/bin/grim -g - - | ~/.nix-profile/bin/wl-copy && ~/.nix-profile/bin/wl-paste > ~/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png'))";
  grimScreenshotClipboard =
    "(~/.nix-profile/bin/slurp | ~/.nix-profile/bin/grim -g - - | ~/.nix-profile/bin/wl-copy)";

  swayidle = "~/.nix-profile/bin/swayidle " + "-d " + # debug logs
    "-w " + # wait for command to finish before releasing lock
    "before-sleep '${lockCmd}' " + ''
      timeout 135 '~/.nix-profile/bin/swaymsg "output * dpms off"' 	resume '~/.nix-profile/bin/swaymsg "output * dpms on"' ''
    + # turn screens on in the 15 seconds after
    "timeout 150 '${lockCmd}'"; # lock screen after 150 seconds of inactivity

in {
  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    programs.foot = {
      enable = true;
      settings = { main = { font = "Cascadia Code:size=12"; }; };
    };

    # Also copy the session.sh from the same repo into our config directory,
    # so it can be called from our sway startup.
    home.file.".config/sway/session.sh" = {
      source = ./sway/session.sh;
      executable = true;
    };

    home.file.".config/systemd/user/sway-session-shutdown.target".source =
      ./sway/sway-session-shutdown.target;

    # home.file.".config/systemd/user/sway-session.target".source =
    #   ./sway/sway-session.target;
    #
    home.file.".config/systemd/user/sway-xdg-autostart.target".source =
      ./sway/sway-xdg-autostart.target;

    wayland.windowManager = {

      sway = {
        enable = true;

        config = {
          menu = "PATH=~/.nix-profile/bin:$PATH wofi --show drun";
          modifier = "Mod4";

          bars = [ ];

          focus = { followMouse = "always"; };

          fonts = {
            names = [ "Cascadia Code" ];
            size = 12.0;
          };

          gaps = {
            inner = 5;
            smartGaps = true;
          };

          input = {
            "type:keyboard" = {
              xkb_layout = "us,mk";
              xkb_numlock = "enabled";
              xkb_options = "grp:alt_shift_toggle,caps:escape";
            };

            "type:touchpad" = {
              tap = "enabled";
              dwt = "enabled";
            };

          };

          keybindings = let
            menu = config.wayland.windowManager.sway.config.menu;
            mod = config.wayland.windowManager.sway.config.modifier;
            terminal = config.wayland.windowManager.sway.config.terminal;
          in lib.mkOptionDefault {
            "${mod}+d" = "exec ${menu}";
            "${mod}+Return" = "exec ${terminal}";
            "${mod}+Ctrl+l" = "exec ${lockCmd}";
            "XF86AudioRaiseVolume" = "exec ${dunstifyVolumeIncrease}";
            "XF86AudioLowerVolume" = "exec ${dunstifyVolumeDecrease}";
            "XF86AudioMute" = "exec ${dunstifyVolumeMute}";
            "XF86AudioMicMute" =
              "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86MonBrightnessDown" = "exec ${dunstifyBrightnessDecrease}";
            "XF86MonBrightnessUp" = "exec ${dunstifyBrightnessIncrease}";
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
            "Ctrl+Print" = "exec ${grimScreenshotClipboard}";
            "Ctrl+Shift+Print" = "exec ${grimScreenshotSave}";
          };

          output = {
            "eDP-1" = {
              resolution = "1920x1080";
              pos = "320 1440";
            };
            "Iiyama North America PL3288UH 1169612412790" = {
              resolution = "3840x2160";
              pos = "2240 1440";
            };
            "Dell Inc. DELL SE3223Q D3XRKK3" = {
              resolution = "3840x2160";
              pos = "2240 1440";
            };
            "Dell Inc. DELL SE3223Q BK6SKK3" = {
              resolution = "3840x2160";
              pos = "2240 1440";
            };
            "Dell Inc. DELL SE3223Q D5CSKK3" = {
              resolution = "3840x2160";
              pos = "2240 1440";
            };
          };

          startup = [
            {
              always = true;
              command = "${swayidle}";
            }
            {
              # restart waybar
              always = true;
              command = "systemctl --user enable --now waybar.service";
            }
            {
              # restart waybar
              command = "exec /home/adrian/.config/sway/session.sh";
            }
          ];

          window = {
            border = 5;
            titlebar = false;
            commands = [{
              command = "inhibit_idle fullscreen";
              criteria = {
                class = ".*";
                app_id = ".*";
              };
            }];
          };
        }; # config

        wrapperFeatures = { gtk = true; };
      };
    };
  };
}
