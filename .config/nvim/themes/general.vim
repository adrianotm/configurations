" configure nvcode-color-schemes
" let g:nvcode_termcolors=256

syntax on
filetype plugin indent on

" colorscheme gruvbox
" autocmd vimenter * ++nested colorscheme gruvbox

" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

" Theme
syntax enable
set background=dark
" Set contrast.
" This configuration option should be placed before `colorscheme gruvbox-material`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'medium'
colorscheme gruvbox-material
