local M = {}

M.plugins = {
    {
        'zbirenbaum/copilot.lua',
        dependencies = {
            'copilotlsp-nvim/copilot-lsp',
        },
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
    {
        'olimorris/codecompanion.nvim',

        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },

        opts = {
            opts = {
                log_level = 'DEBUG', -- or "TRACE"
            },
        },
    },
}

return M.plugins
