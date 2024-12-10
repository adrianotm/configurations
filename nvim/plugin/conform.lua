local options = {
	formatters_by_ft = {
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		-- python = { "ruff_fix", "ruff_format" },
		-- haskell = { "fourmolu" },
		-- ihaskell = { "fourmolu" },
		cabal = { "cabal_fmt" },
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		nix = { "nixfmt" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		async = false,
		lsp_fallback = false,
	},
}

require("conform").setup(options)
