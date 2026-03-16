-- ==========
-- Init
-- ==========

require("settings")
require("keymaps")
require("autocmds")
require("lazy-setup")

-- Setting color theme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Treesitter
require('nvim-treesitter').install { 'lua', 'bash', 'cpp', 'python', 'html', 'css', 'javascript', 'json', 'kitty', 'zsh', 'markdown', 'markdown_inline' }

-- Neo-tree
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neotree' })
