local M = {}

M.plugins = {
    {
        'alexghergh/nvim-tmux-navigation',
        event = 'VeryLazy',
        config = function()
            local nvim_tmux_nav = require 'nvim-tmux-navigation'
            nvim_tmux_nav.setup {
                disable_when_zoomed = true,
                keybindings = {
                    left = '<C-h>',
                    down = '<C-j>',
                    up = '<C-k>',
                    right = '<C-l>',
                },
            }
        end,
    },
    {
        'aserowy/tmux.nvim',
        config = function()
            local tmux = require 'tmux'

            vim.keymap.set('n', '<M-h>', tmux.resize_left, { desc = 'Resize window left' })
            vim.keymap.set('n', '<M-j>', tmux.resize_bottom, { desc = 'Resize window down' })
            vim.keymap.set('n', '<M-k>', tmux.resize_top, { desc = 'Resize window up' })
            vim.keymap.set('n', '<M-l>', tmux.resize_right, { desc = 'Resize window right' })

            return tmux.setup {
                copy_sync = {
                    enable = false,
                },
                resize = {
                    enable_default_keybindings = false,
                },
            }
        end,
    },
}

return M.plugins
