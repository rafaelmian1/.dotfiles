-- Rosé Pine Colorscheme

local M = {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 10000,
    lazy = false,
}

M.opts = {
    -- 'auto' follows 'background', which dark-notify sets: moon when dark,
    -- dawn when light.
    variant = 'auto',
    dark_variant = 'moon',

    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        migrations = true,
    },

    styles = {
        bold = true,
        italic = false,
        transparency = true,
    },

    highlight_groups = {
        -- Telescope: one continuous surface, borders tinted to match so the
        -- picker reads as a single panel rather than a stack of boxes.
        TelescopeNormal = { bg = 'surface', fg = 'text' },
        TelescopeBorder = { bg = 'surface', fg = 'surface' },
        TelescopePromptNormal = { bg = 'overlay' },
        TelescopePromptBorder = { bg = 'overlay', fg = 'overlay' },
        TelescopePromptTitle = { bg = 'overlay', fg = 'gold' },
        TelescopeResultsNormal = { bg = 'surface', fg = 'subtle' },
        TelescopeResultsBorder = { bg = 'surface', fg = 'surface' },
        TelescopePreviewNormal = { bg = 'surface' },
        TelescopePreviewBorder = { bg = 'surface', fg = 'surface' },
        TelescopeSelection = { bg = 'highlight_med' },
        TelescopeMatching = { fg = 'gold', bold = true },

        -- lazygit.nvim links these to Normal by default, which paints the
        -- terminal float against the wrong surface.
        LazyGitFloat = { bg = 'surface' },
        LazyGitBorder = { bg = 'surface', fg = 'surface' },

        -- Floats and completion share the panel background so documentation
        -- windows sit flush against the menu they belong to.
        NormalFloat = { bg = 'surface' },
        FloatBorder = { bg = 'surface', fg = 'surface' },
        FloatTitle = { bg = 'surface', fg = 'gold' },

        Pmenu = { bg = 'surface', fg = 'subtle' },
        PmenuSel = { bg = 'highlight_med', fg = 'none' },
        PmenuSbar = { bg = 'surface' },
        PmenuThumb = { bg = 'highlight_high' },
    },
}

M.config = function(_, opts)
    require('rose-pine').setup(opts)
    vim.cmd.colorscheme 'rose-pine'
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
