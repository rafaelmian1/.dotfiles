-- Rose-pine Colorscheme

local M = {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 10000,
    lazy = false,
}

M.opts = {
    variant = 'auto', -- Options: 'auto', 'main', 'moon', or 'dawn'
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

    -- Explicit highlight overrides. `gold`/`rose` are warm accents that stay
    -- legible against the cool blues/greens of a Patagonia mountain-and-lake
    -- wallpaper showing through the transparent background.
    highlight_groups = {
        -- Selection: a warm, opaque block so it pops against the wallpaper
        Visual = { fg = 'base', bg = 'gold', inherit = false },
        VisualNOS = { fg = 'base', bg = 'gold', inherit = false },

        -- Telescope: rose/gold borders and a solid panel so popups read
        -- clearly over the transparent, wallpaper-tinted background
        TelescopeNormal = { bg = 'surface' },
        TelescopeBorder = { fg = 'gold', bg = 'surface' },
        TelescopePromptNormal = { bg = 'overlay' },
        TelescopePromptBorder = { fg = 'rose', bg = 'overlay' },
        TelescopePreviewBorder = { fg = 'gold', bg = 'surface' },
        TelescopeResultsBorder = { fg = 'gold', bg = 'surface' },
        TelescopeSelection = { bg = 'highlight_med' },
        TelescopeMatching = { fg = 'gold', bold = true },

        -- lazygit.nvim links these to Normal by default, which makes the
        -- terminal float paint an opaque background.
        LazyGitFloat = { bg = 'NONE' },
        LazyGitBorder = { fg = 'gold', bg = 'NONE' },
    },
}

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
