-- Rose-pine Colorscheme

local M = {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    lazy = false,
}

M.opts = {
    variant = 'moon', -- Options: 'auto', 'main', 'moon', or 'dawn'
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = true,

    -- Highlight groups to override
    groups = {
        -- background = "#232136",
        -- panel = "#2a273f",
        -- border = '#44415a',
        -- comment = '#6e6a86',
        -- link = '#c4a7e7',
        -- punctuation = '#908caa',
    },
}

M.config = function(_, opts)
    require('rose-pine').setup(opts)

    -- Set colorscheme after options (will be overridden by dark-notify if active)
    vim.cmd 'colorscheme rose-pine'
end

M.dependencies = {
    {
        'cormacrelf/dark-notify',
        config = function()
            require('dark_notify').run {
                schemes = {
                    dark = 'rose-pine-moon',
                    light = 'rose-pine-dawn',
                },
            }
        end,
    },
}

return M
