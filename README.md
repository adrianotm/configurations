# Home Manager Flake Configuration

## Usage

- **Update to the latest nixpkgs/home-manager:**
  ```
  nix flake update
  ```
- **Rebuild/apply configuration:**
  ```
  home-manager switch --flake .
  ```
- **Add/remove packages:**
  Edit `home.nix`, then run the above switch command.

## Structure
- `flake.nix`: Flake entrypoint, pins nixpkgs and Home Manager source
- `home.nix`: Main home configuration, imports...
  - `zsh.nix`: Zsh prompt, Oh My Zsh, aliases, completion, etc.
  - `nvim.nix`: Neovim plugins/LS/extra packages
  - `sway/`: Sway, Waybar, Wofi, and theming, all modularized
- `archive/old_sway.nix`: Legacy sway config kept for reference only
