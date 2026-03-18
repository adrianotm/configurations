# NVIM — NEOVIM CONFIGURATION

Neovim managed by home-manager. Plugin configs in Lua files loaded via `toLuaFile` helper in `nvim.nix`.

## STRUCTURE

```
nvim.nix            # home-manager module: plugins list, LSP packages, toLuaFile helper
nvim/
├── options.lua     # Editor settings, colorscheme (gruvbox-material), vim-polyglot flags
├── mappings.lua    # All keymaps — leader=<Space>
└── plugin/
    ├── cmp.lua         # nvim-cmp completion config
    ├── lsp.lua         # LSP attach config (shared across all servers)
    ├── telescope.lua   # Fuzzy finder setup
    ├── conform.lua     # Formatter config (conform-nvim)
    ├── leap.lua        # Leap motion config
    └── copilot-chat.lua # CopilotChat setup
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add/remove plugin | `nvim.nix` → `plugins` list |
| Add LSP server | `nvim.nix` → `extraPackages` (the Nix package) + `nvim/plugin/lsp.lua` (server setup) |
| Add formatter | `nvim.nix` → `extraPackages` + `nvim/plugin/conform.lua` |
| Change keybindings | `nvim/mappings.lua` |
| Editor options | `nvim/options.lua` |
| Completion behavior | `nvim/plugin/cmp.lua` |

## CONVENTIONS

- **`toLuaFile` pattern:** plugin Lua configs live in `nvim/plugin/<name>.lua` and are inlined via the `toLuaFile` helper in `nvim.nix`. Always add both: the plugin entry in `nvim.nix` and its Lua file.
- **`initLua`** loads `options.lua` then `mappings.lua` unconditionally — plugin-specific setup goes in `plugin/` only
- **Leader key:** `<Space>` — set in `options.lua`
- **Colorscheme:** `gruvbox-material` — set in `options.lua`, do not override elsewhere
- **Indent:** 2-space, expandtab — enforced globally in `options.lua`

## LSPs MANAGED

`lua-language-server`, `typescript-language-server`, `pyright`, `nil` (Nix), `rust-analyzer`, `haskell-language-server`

## ANTI-PATTERNS

- **Do not use `vimscript` blocks** — all config is Lua
- **Do not add plugin config inline in `nvim.nix`** beyond the `toLuaFile` call — keep Lua in `nvim/plugin/`
- **treesitter was intentionally removed** (see commit c2a7b0a) — do not re-add without consideration
