local M = {
    'stevearc/oil.nvim',
    lazy = false,
}

M.opts = {}

M.dependencies = { 'nvim-tree/nvim-web-devicons' }

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

return M
