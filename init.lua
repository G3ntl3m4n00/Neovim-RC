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
require("overseer").setup({
  templates = { "builtin" },
})

vim.keymap.set("n", "<leader>r", function()
  local file = vim.fn.expand("%:p")       -- full path to current file
  local out = vim.fn.expand("%:p:r")      -- same path without extension
  local task = require("overseer").new_task({
    cmd = { "g++", "-std=c++23", file, "-o", out },
    name = "build current file",
    components = { "default" },
  })
  task:start()
  require("overseer").open({ enter = false })
end)

vim.keymap.set("n", "<leader>t", ":OverseerToggle<CR>")


-- Cmp

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"]     = cmp.mapping.select_next_item(),
    ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },
})

-- diagnostics display
vim.diagnostic.config({
  virtual_text = true,       -- shows error inline at end of line
  signs = true,              -- shows icons in the sign column
  underline = true,          -- underlines the problematic code
  update_in_insert = false,  -- only update when leaving insert mode
})

-- Conform
require("conform").setup({
  formatters_by_ft = {
    cpp = { "clang-format" },
    c   = { "clang-format" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Autopairs

require("nvim-autopairs").setup()
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
