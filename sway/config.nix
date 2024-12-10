# Configures my entire X session but leaves GTK untouched,
# that is better configured through lxappearance manually.
{ config, pkgs, ... }:
let my-theme = import ./theme.nix;
in {
  imports = [ ./wofi.nix ./waybar.nix ];

  # Set up the right set of files, according to:
  # https://github.com/alebastr/sway-systemd/tree/main
  # Make sure to bring in updates from there periodically!
  home.file.".config/systemd/user/sway-session-shutdown.target".source =
    ./systemd-units/sway-session-shutdown.target;

  home.file.".config/systemd/user/sway-session.target".source =
    ./systemd-units/sway-session.target;

  home.file.".config/systemd/user/sway-xdg-autostart.target".source =
    ./systemd-units/sway-xdg-autostart.target;

  # Also copy the session.sh from the same repo into our config directory,
  # so it can be called from our sway startup.
  home.file.".config/sway/session.sh" = {
    source = ./session.sh;
    executable = true;
  };

  home.file.".config/sway/config".source = ./sway-config;
  home.file.".config/sway/binds.sway".source = ./sway-keybinds;
  home.file.".config/sway/theme.sway".text = let c = my-theme.colors;
  in ''
    # class                 border  backgr. text    indica. child_border
    client.focused          ${c.active-border} ${c.active-bg} ${c.active-text} ${c.active-indicator}
    client.focused_inactive ${c.inactive-border} ${c.inactive-bg} ${c.inactive-text}
    client.unfocused        ${c.unfocused-border} ${c.unfocused-bg} ${c.unfocused-text}
    client.urgent           ${c.urgent-border} ${c.urgent-bg} ${c.urgent-text}

    default_border pixel 1
    default_floating_border normal 1
    hide_edge_borders none

    gaps inner 5
    smart_gaps on
  '';

  # I dont want to be engaging in the home-manager switching every time I need to add a new output
  # to sway. Just make me a link! Yet, I can't et mkOutOfStoreSymlink to work yet
  home.file.".config/sway/outputs.sway".source = ./sway-outputs;

  home.file.".config/foot/foot.ini".text = ''
    font=${my-theme.fonts.normal-name}:size=12
  '';
}
