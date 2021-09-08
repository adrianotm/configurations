" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Gruvbox theme that works with 5.0
    Plug 'sainnhe/gruvbox-material'
    " Telescope (fzf)
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'airblade/vim-rooter'
    " Sneak
    Plug 'justinmk/vim-sneak'
    " Airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Which key
    Plug 'liuchengxu/vim-which-key'
    " Comments
    Plug 'tpope/vim-commentary'
    " NERDTree
    Plug 'preservim/nerdtree'
    " Buffers
    Plug 'qpkorr/vim-bufkill'
    " Git
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
    " Stratify
    Plug 'mhinz/vim-startify'
    " Haskell syntax
    Plug 'neovimhaskell/haskell-vim'
    " 0.5 nvim
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':tsupdate'}  " we recommend updating the parsers on update
    Plug 'nvim-lua/completion-nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'glepnir/lspsaga.nvim'
     
    " Tmux
    Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
