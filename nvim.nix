{ config, pkgs, ... }:
{
  config = {
    programs.neovim =
      let
        toLuaFile = file: builtins.readFile file;
      in
      {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;
        withPython3 = true;
        withRuby = true;
        extraPackages = with pkgs; [
          lua-language-server
          typescript-language-server
          pyright
          nil
          rust-analyzer
          haskell-language-server
          ripgrep
          nixfmt
          stylua
          xclip
          haskellPackages.cabal-fmt
          eslint
        ];
        initLua = ''
          ${builtins.readFile ./nvim/options.lua}
          ${builtins.readFile ./nvim/mappings.lua}
        '';
        plugins = with pkgs.vimPlugins; [
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          {
            type = "lua";
            plugin = nvim-cmp;
            config = toLuaFile ./nvim/plugin/cmp.lua;
          }
          {
            type = "lua";
            plugin = nvim-lspconfig;
            config = toLuaFile ./nvim/plugin/lsp.lua;
          }
          plenary-nvim
          {
            type = "lua";
            plugin = telescope-nvim;
            config = toLuaFile ./nvim/plugin/telescope.lua;
          }

          {
            plugin = gruvbox-material;
          }
          {
            type = "lua";
            plugin = conform-nvim;
            config = toLuaFile ./nvim/plugin/conform.lua;
          }

          vim-fugitive
          vim-polyglot

          nerdtree

          vim-repeat
          {
            type = "lua";
            plugin = leap-nvim;
            config = toLuaFile ./nvim/plugin/leap.lua;
          }
        ];
      };
  };
}
