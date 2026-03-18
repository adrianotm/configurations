# SWAY — WAYLAND SESSION

Full Wayland desktop session: sway WM, waybar, wofi launcher, foot terminal.

## STRUCTURE

```
sway/
├── config.nix          # Home-manager module: entry point, imports wofi+waybar, symlinks raw configs
├── theme.nix           # Pure attrset: all colors + fonts — imported with `import ./theme.nix`
├── waybar.nix          # Waybar JSON config + CSS (inline as Nix strings, consumes theme.nix)
├── wofi.nix            # Wofi CSS (inline as Nix string, consumes theme.nix)
├── sway-config         # Raw sway config file (symlinked to ~/.config/sway/config)
├── sway-keybinds       # Raw sway keybinds (symlinked to ~/.config/sway/binds.sway)
├── sway-outputs        # Raw monitor config (symlinked, NOT rebuilt on hm switch — intentional)
├── session.sh          # From alebastr/sway-systemd — starts sway as systemd session
└── systemd-units/      # sway-session*.target files (symlinked to ~/.config/systemd/user/)
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Colors or fonts | `theme.nix` only — single source of truth |
| Waybar modules/layout | `waybar.nix` → `xdg.configFile."waybar/config"` |
| Waybar styling | `waybar.nix` → `xdg.configFile."waybar/style.css"` |
| Wofi styling | `wofi.nix` |
| Sway keybindings | `sway-keybinds` (raw sway syntax) |
| Monitor/output config | `sway-outputs` (edit directly, no rebuild needed) |
| Autostart / systemd | `sway-config` + `systemd-units/` |
| Add a new program to session | `config.nix` — add package + symlink |

## CONVENTIONS

- **Theme consumption:** always `let my-theme = import ./theme.nix;` at top of consuming file — never hardcode hex values
- **Raw vs Nix:** sway config files (`sway-config`, `sway-keybinds`) are raw sway syntax, not Nix — edit directly without Nix wrapping
- **`sway-outputs` bypass:** intentionally uses `xdg.configFile.source` (not `.text`) so monitor config survives `home-manager switch` without triggering a rebuild — do NOT convert to `.text`
- **Systemd units:** from [alebastr/sway-systemd](https://github.com/alebastr/sway-systemd/tree/main) — keep in sync with upstream

## ANTI-PATTERNS

- **Do not duplicate color hex values** outside `theme.nix`
- **Do not manage GTK theming here** — use `lxappearance` manually
- **Do not add `import sway/` to modules outside `home.nix`** — `config.nix` is the sole entry
