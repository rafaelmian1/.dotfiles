local M = { 'nvim-lualine/lualine.nvim' }

M.dependencies = { 'nvim-tree/nvim-web-devicons' }

M.config = function()
    local lualine = require 'lualine'
    local lazy_status = require 'lazy.status'

    lualine.setup {
        options = {
            theme = 'auto',
        },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch' },
            lualine_c = {
                {
                    'filename',
                    path = 1,
                },
            },
            lualine_x = {
                {
                    lazy_status.updates,
                    cond = lazy_status.has_updates,
                    color = { fg = '#ff9e64' },
                },
                { 'filetype' },
            },
        },
    }
end

return M
