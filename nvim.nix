{ config, pkgs, ... }: {
  config = {
    programs.neovim = let
      toLuaFile = file: ''
        lua << EOF
        ${builtins.readFile file}
        EOF
      '';
    in {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        lua-language-server
        typescript-language-server
        pyright
        nil
        rust-analyzer
        haskell-language-server
        ripgrep
        nixfmt-classic
        stylua
        xclip
        nodePackages.prettier
        haskellPackages.cabal-fmt
      ];
      extraLuaConfig = ''
        ${builtins.readFile ./nvim/options.lua}
        ${builtins.readFile ./nvim/mappings.lua}
      '';
      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        {
          plugin = nvim-cmp;
          config = toLuaFile ./nvim/plugin/cmp.lua;
        }
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }

        plenary-nvim
        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvim/plugin/telescope.lua;
        }

        {
          plugin = gruvbox-material;
          config = "colorscheme gruvbox-material";
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          config = toLuaFile ./nvim/plugin/treesitter.lua;
        }

        {
          plugin = conform-nvim;
          config = toLuaFile ./nvim/plugin/conform.lua;
        }

        vim-fugitive

        nerdtree

        repeat
        {
          plugin = leap-nvim;
          config = toLuaFile ./nvim/plugin/leap.lua;
        }
      ];
    };
  };
}
