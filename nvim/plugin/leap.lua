vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

-- Optionally, clever bidirectional "s/S" mapping:
-- Uncomment if you want Sneak-style behavior:
--[[
local clever_s = require('leap.user').with_traversal_keys('s', 'S')
vim.keymap.set({'n', 'x', 'o'}, 's', function()
  require('leap').leap { opts = clever_s }
end)
vim.keymap.set({'n', 'x', 'o'}, 'S', function()
  require('leap').leap { backward = true, opts = clever_s }
end)
]]

vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

require("leap").add_default_mappings()
