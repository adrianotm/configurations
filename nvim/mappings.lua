local map = vim.keymap.set

map("n", "<C-x>", ":nohl<CR>")

local opts = { noremap = true, silent = true }
map("n", "<leader>e", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>q", vim.diagnostic.setloclist, opts)
map({ "n", "v", "i" }, "<C-S>", ":w<CR>", opts)

map("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope find files" })
map("n", "<leader>fw", require("telescope.builtin").live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Telescope help tags" })
map("n", "<leader>gr", require("telescope.builtin").lsp_references, { desc = "Telescope help tags" })

map("n", "<leader>gs", ":Git<CR>", opts)
map("n", "<leader>gc", ":Gcommit<CR>", opts)
map("n", "<leader>gp", ":Git push origin<CR>", opts)
map("n", "<leader>ga", ":Gw<CR>", opts)
map("n", "<leader>gA", ":Git add .<CR>", opts)
map("n", "<leader>gf", ":Git pull<CR>", opts)
map("n", "<leader>gd", ":Gdiff<CR>", opts)
map("n", "<leader>gB", ":Git blame<CR>", opts)

map("n", "<leader>n", ":NERDTreeFind<CR>", opts)
map("n", "<C-n>", ":NERDTreeToggle<CR>", opts)
