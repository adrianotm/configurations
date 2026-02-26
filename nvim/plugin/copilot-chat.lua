-- ./nvim/plugin/copilot-chat.lua
local chat = require("CopilotChat")

chat.setup({
	debug = false, -- Set to true to see debug logs

	-- Customize the chat window appearance
	window = {
		layout = "float", -- Options: 'vertical', 'horizontal', 'float', 'replace'
		width = 0.8,
		height = 0.8,
		border = "rounded",
	},
})

vim.g.mapleader = " "
-- Keymaps
-- Toggle the chat window
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })

-- Explain the current selected code (Visual Mode)
vim.keymap.set("v", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "Copilot Chat Explain" })

-- Review the current selected code (Visual Mode)
vim.keymap.set("v", "<leader>cr", ":CopilotChatReview<CR>", { desc = "Copilot Chat Review" })

vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-Tab>", 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false, silent = true })
vim.keymap.set("i", "<C-j>", "copilot#Next()", { expr = true, silent = true })
vim.keymap.set("i", "<C-k>", "copilot#Previous()", { expr = true, silent = true })

-- Select multiple files via Telescope and send them to Copilot Chat
vim.keymap.set("n", "<leader>cf", function()
	local telescope = require("telescope.builtin")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	telescope.find_files({
		prompt_title = "Add Files to Copilot Chat (<Tab> to multi-select)",
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				-- 1. Grab the picker and selections BEFORE closing the window
				local picker = action_state.get_current_picker(prompt_bufnr)
				local selections = picker:get_multi_selection()
				local files = {}

				-- If the user used <Tab> to select multiple files
				if not vim.tbl_isempty(selections) then
					for _, sel in ipairs(selections) do
						table.insert(files, sel[1])
					end
				else
					-- If the user just pressed Enter on a single file
					local selection = action_state.get_selected_entry()
					if selection then
						table.insert(files, selection[1])
					end
				end

				-- 2. NOW close the telescope window
				actions.close(prompt_bufnr)

				-- 3. Proceed with opening the chat and injecting the tags
				if #files > 0 then
					require("CopilotChat").open()

					local file_tags = "> "
					for _, file in ipairs(files) do
						file_tags = file_tags .. "#file:" .. file .. " "
					end

					vim.schedule(function()
						local keys = vim.api.nvim_replace_termcodes("A" .. file_tags, true, false, true)
						vim.api.nvim_feedkeys(keys, "n", false)
					end)
				end
			end)
			return true
		end,
	})
end, { desc = "Add files to Copilot Chat via Telescope" })
