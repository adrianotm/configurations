{ config, pkgs, lib, ... }:

{
  nixpkgs = { config = { allowUnfree = true; }; };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    thefuck
    gnome-tweaks

    font-awesome
    nerd-fonts.caskaydia-cove
    nerd-fonts.hack
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables = { EDITOR = "nvim"; };

  home.sessionPath = [ "$HOME/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [ ./zsh.nix ./nvim.nix ./sway/config.nix ];
}
