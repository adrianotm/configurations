lua << EOF
require'lspconfig'.hls.setup{}
require'lspconfig'.hls.setup{on_attach=require'completion'.on_attach}
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false,
    }
)
EOF
