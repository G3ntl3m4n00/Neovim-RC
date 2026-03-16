-- =======
-- Keymaps
-- =======

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Built-in file explorer
vim.keymap.set("n", "<leader>ne", ":Ex<CR>", { desc = "Built-In File Explorer" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<Tab>",   ":bn<CR>")
vim.keymap.set("n", "<S-Tab>", ":bp<CR>")
vim.keymap.set("n", "<leader>x", ":bd<CR>")
