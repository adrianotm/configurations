" nord.vim override: Don't set a background color when running in a terminal;
" if (has("autocmd") && !has("gui_running"))
"   augroup colorset
"     autocmd!
"     let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
"     autocmd ColorScheme * call nord#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
"   augroup END
" endif

hi Comment cterm=italic
let g:nord_hide_endofbuffer=1
let g:nord_terminal_italics=1
let g:nord_termcolors=256

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" if (has("termguicolors"))
"   set termguicolors
" endif

colorscheme nord
syntax on
