-- Tokyo Night Colorscheme

local M = {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    priority = 10000,
    lazy = false,
}

M.opts = {
    -- 'night' is the darkest variant; dark-notify swaps to 'day' below.
    style = 'night',
    light_style = 'day',
    transparent = false,
    terminal_colors = true,

    styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
        -- Floats and sidebars share the darker background so popups read as
        -- a distinct surface rather than blending into the editor.
        sidebars = 'dark',
        floats = 'dark',
    },

    sidebars = { 'qf', 'help', 'terminal', 'trouble' },
    dim_inactive = false,
    lualine_bold = false,

    on_highlights = function(hl, c)
        -- Telescope: one continuous surface, borders tinted to match so the
        -- picker reads as a single panel.
        hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
        hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopePromptNormal = { bg = c.bg_highlight }
        hl.TelescopePromptBorder = { bg = c.bg_highlight, fg = c.bg_highlight }
        hl.TelescopePromptTitle = { bg = c.bg_highlight, fg = c.orange }
        hl.TelescopeResultsNormal = { bg = c.bg_dark, fg = c.fg_dark }
        hl.TelescopeResultsBorder = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopePreviewNormal = { bg = c.bg_dark }
        hl.TelescopePreviewBorder = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopeSelection = { bg = c.bg_visual }
        hl.TelescopeMatching = { fg = c.orange, bold = true }

        -- lazygit.nvim links these to Normal by default, which makes the
        -- terminal float paint against the wrong surface.
        hl.LazyGitFloat = { bg = c.bg_dark }
        hl.LazyGitBorder = { bg = c.bg_dark, fg = c.bg_dark }
    end,
}

M.config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight'
end

M.dependencies = {
    {
        'cormacrelf/dark-notify',
        config = function()
            require('dark_notify').run {
                schemes = {
                    dark = 'tokyonight-night',
                    light = 'tokyonight-day',
                },
            }
        end,
    },
}

return M
