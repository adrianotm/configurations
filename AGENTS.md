# HOME-MANAGER CONFIG — KNOWLEDGE BASE

**Generated:** 2026-03-12  
**Commit:** c2a7b0a  
**Branch:** home-manager-wayland

## OVERVIEW

NixOS home-manager flake for user `adrian` (x86_64-linux). Manages shell, editor, Wayland/Sway desktop, and OpenCode AI tooling declaratively.

## STRUCTURE

```
home-manager/
├── flake.nix              # Flake entry: pins nixos-unstable + home-manager
├── home.nix               # Root module: packages, file symlinks, imports
├── zsh.nix                # Zsh + Oh My Zsh + direnv + shell aliases
├── tmux.nix               # Tmux (prefix=C-a, vi mode, WSL2-safe socket)
├── nvim.nix               # Neovim + LSPs + plugins (Lua configs in nvim/)
├── nvim/                  # Raw Lua: options.lua, mappings.lua, plugin/*.lua
├── sway/                  # Full Wayland session: sway, waybar, wofi, foot
├── opencode.json          # OpenCode agents, models, permissions (source of truth)
├── oh-my-opencode-slim.json  # oh-my-opencode-slim orchestration plugin config (active)
├── oh-my-openagent.json   # oh-my-openagent model config (NOT in active plugin list — orphaned)
├── skills/                # OpenCode agent skills (SKILL.md per skill)
└── archive/               # Legacy configs — do not import
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add/remove packages | `home.nix` → `home.packages` |
| New symlinked config file | `home.nix` → `home.file."..."` or `xdg.configFile."..."` |
| Shell aliases or env | `zsh.nix` |
| Neovim plugins or LSPs | `nvim.nix` → plugins list or `extraPackages` |
| Neovim Lua config | `nvim/options.lua`, `nvim/mappings.lua`, `nvim/plugin/*.lua` |
| Sway keybindings | `sway/sway-keybinds` (raw sway config, not Nix) |
| Sway outputs/monitors | `sway/sway-outputs` (raw sway config, intentionally not rebuilt on change) |
| Waybar layout/modules | `sway/waybar.nix` |
| Theme colors/fonts | `sway/theme.nix` — single source, imported by waybar.nix + wofi.nix |
| OpenCode model/agent config | `opencode.json` |
| OpenCode skills | `skills/<name>/SKILL.md` + declare in `home.nix` |
| Flake inputs/nixpkgs pin | `flake.nix` |

## CONVENTIONS

**File management pattern:** Two mechanisms used — pick the right one:
- `home.file."<dest>".source = ./path` — copies file into Nix store, then links. Used for configs managed here (opencode.json, skills, systemd units).
- `xdg.configFile."<dest>"` — same mechanism under `~/.config/`. Used in sway/.

**Adding a new OpenCode skill:**
1. Create `skills/<name>/SKILL.md` with valid frontmatter (`name` must match dir name)
2. Add `home.file.".config/opencode/skills/<name>/SKILL.md".source = ./skills/<name>/SKILL.md;` to `home.nix`
3. `git add skills/<name>/SKILL.md` before running `home-manager switch` — flake evaluation is pure, untracked files are invisible to Nix

**Removing an OpenCode plugin (full footprint):** A plugin can leave traces in up to six places. Sweep all that apply:
1. `flake.nix` — remove the input (if it was a flake input, e.g. raw-source plugins)
2. `flake.lock` — run `nix flake lock` to drop the removed input
3. `home.nix` — remove the `home.file."..."` config declaration AND any `home.activation.*` block that installs/patches it. Watch for **unrelated logic colocated in the same activation block** (e.g. a shared dependency for a different plugin) — extract and keep it, don't delete it wholesale.
4. Deployed files under `~/.config/opencode/` — activation-written files (e.g. `plugins/`, config symlinks) are NOT auto-removed; `home.file`-managed symlinks self-clean on the next switch as orphan links
5. `~/.config/opencode/package.json` — remove any dependency the plugin added (this file is intentionally writable/unmanaged; edit with `jq`)
6. Plugin cache + runtime data — `~/.cache/opencode/packages/<plugin>@*/` (orphaned build) and any data dir the plugin created (e.g. `~/.opencode-mem/`). **Data dirs are destructive to remove — confirm first.**
   - `rm` is denied by `opencode.json` permissions; move discarded paths to `/tmp/opencode/` instead.
7. Verify the plugin is gone from `opencode.json`'s `"plugin"` array, then `home-manager build` → `switch`. Also grep `AGENTS.md` for stale references.

**Nix module style:** Each module uses `{ config, pkgs, ... }:` signature. Top-level `config = { ... }` block only used when needed (zsh.nix, nvim.nix). Direct attribute assignment otherwise (tmux.nix, sway/).

**Theme:** Colors and fonts live exclusively in `sway/theme.nix` as a plain Nix attrset (imported with `import ./theme.nix`, not as a module). Don't duplicate color values elsewhere.

**Nixpkgs channel:** `nixos-unstable` — expect occasional breakage on `nix flake update`.

## ANTI-PATTERNS

- **Do not use absolute paths** in `home.file.*.source` — flake evaluation is pure; only store paths work
- **Do not edit files under `~/.config/opencode/` directly** — they are symlinks managed by home-manager and will be overwritten on next switch
- **Do not `nix-collect-garbage`** without checking the switch succeeded first
- **`archive/` is dead code** — do not import `old_sway.nix`; kept for reference only
- **GTK theming is NOT managed here** — configure via `lxappearance` manually (see comment in `sway/config.nix`)
- **`sway/sway-outputs` is intentionally unmanaged by Nix rebuild** — it's a raw file symlinked so monitor configs can be changed without a full switch

## COMMANDS

```bash
# Apply configuration
home-manager switch --flake .

# Update nixpkgs + home-manager inputs
nix flake update

# Check what changed without applying
home-manager build --flake .

# Must run before home-manager switch when adding new files
git add <new-file>
```

## NOTES

- **Branch `home-manager-wayland`** is the active branch — Wayland/Sway specific setup, not a generic base
- tmux `secureSocket = false` is intentional for WSL2 socket compatibility
- `sway/session.sh` is from [alebastr/sway-systemd](https://github.com/alebastr/sway-systemd/tree/main) — keep in sync with upstream periodically
- Shell aliases (`rmh`, `shm`, etc.) are Channable-workspace shortcuts — adjust to your own project dirs
- OpenCode permissions deny `git commit*`, `git push*`, `home-manager switch` is not blocked — agents can rebuild config
