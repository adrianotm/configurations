" Change these if you want
let g:gitgutter_sign_add               = '+'
let g:gitgutter_sign_delete            = '_'
let g:gitgutter_sign_delete_first_line = '‾'
let g:gitgutter_sign_change            = '~'


" Jump though hunks
nmap <leader>hj <plug>(GitGutterNextHunk)
nmap <leader>hk <plug>(GitGutterPrevHunk)
nmap <leader>hu <plug>(GitGutterUndoHunk)
