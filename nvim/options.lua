vim.g.mapleader = " "
vim.g.maplocalheader = " "

vim.o.clipboard = "unnamedplus"

vim.o.splitbelow = true

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smarttab = true
vim.o.expandtab = true

vim.o.colorcolumn = "100"

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- Polyglot/regex-based highlighting improvements
vim.g.python_highlight_all = 1
vim.g.rust_fold = 1
vim.g.rustfmt_autosave = 1
vim.g.haskell_enable_quantification = 1
vim.g.haskell_enable_recursivedo = 1
vim.g.haskell_enable_arrowsyntax = 1
vim.g.haskell_enable_pattern_synonyms = 1
vim.g.haskell_enable_typeroles = 1
vim.g.haskell_enable_static_pointers = 1
vim.g.haskell_backpack = 1
vim.g.lua_folding = 1
vim.g.html5_event_handler_attributes_complete = 1
vim.g.css_color_names = 1
vim.g.javascript_plugin_jsdoc = 1

-- Colorscheme (centralized)
vim.cmd("colorscheme gruvbox-material")
