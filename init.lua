-- ==========
-- Init
-- ==========

require("settings")
require("keymaps")
require("autocmds")
require("lazy-setup")

-- Setting color theme
vim.o.background = "dark"

require("gruvbox").setup({
    terminal_colors = true,
    transparent_mode = true,
})

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


-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "clangd" },
    automatic_installation = true,
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', 'CMakeLists.txt', '.git' },
})

vim.lsp.enable('clangd')


-- Nvim-dap

local dap = require("dap")
local dapui = require("dapui")

-- tell dap to use codelldb or gdb
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/src/", "file")
    end,
    cwd = "${workspaceFolder}/src",
    stopOnEntry = false,
  },
}

-- open/close ui automatically
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end

dapui.setup()

vim.keymap.set("n", "<F5>",  dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)


-- Overseer
require("overseer").setup()
vim.keymap.set("n", "<leader>r", ":OverseerRun<CR>")
vim.keymap.set("n", "<leader>t", ":OverseerToggle<CR>")
