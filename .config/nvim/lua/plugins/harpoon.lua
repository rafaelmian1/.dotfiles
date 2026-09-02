local M = {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
}

M.dependencies = { 'nvim-lua/plenary.nvim' }

M.config = function()
    -- harpoon loads files via vim.fn.bufload(), which raises E325 when another nvim
    -- instance has the file open (bypassing nvim's default "ignore swap from running
    -- nvim" handler). Suppress the swap ATTENTION prompt while selecting.
    local default_select = require('harpoon.config').get_default_config().default.select
    local harpoon = require('harpoon'):setup {
        default = {
            select = function(...)
                local shortmess = vim.o.shortmess
                vim.opt.shortmess:append 'A'
                local ok, err = pcall(default_select, ...)
                vim.o.shortmess = shortmess
                if not ok then
                    vim.notify(tostring(err), vim.log.levels.ERROR)
                end
            end,
        },
    }

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
