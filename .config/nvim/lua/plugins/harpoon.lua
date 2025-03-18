local M = {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
}

M.dependencies = { 'nvim-lua/plenary.nvim' }

M.config = function()
    local harpoon = require('harpoon'):setup()

    vim.keymap.set('n', ';a', function()
        harpoon:list():add()
    end)
    vim.keymap.set('n', ';e', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<leader>1', function()
        harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<leader>2', function()
        harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<leader>3', function()
        harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<leader>4', function()
        harpoon:list():select(4)
    end)
end

return M
