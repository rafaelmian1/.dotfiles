-- Everforest Colorscheme

local M = {
    'neanias/everforest-nvim',
    name = 'everforest',
    priority = 10000,
    lazy = false,
}

M.config = function()
    local everforest = require 'everforest'

    everforest.setup {
        -- 'hard' | 'medium' | 'soft' — how much contrast between background
        -- and foreground. 'medium' is the upstream default.
        background = 'medium',
        transparent_background_level = 0,
        italics = false,
        disable_italic_comments = true,
        sign_column_background = 'none',
        ui_contrast = 'low',
        dim_inactive_windows = false,

        diagnostic_text_highlight = false,
        diagnostic_virtual_text = 'coloured',
        diagnostic_line_highlight = false,

        spell_foreground = false,
        show_eob = true,
        float_style = 'bright',
        inlay_hints_background = 'none',

        on_highlights = function(hl, palette)
            -- Telescope: one continuous surface, borders tinted to match so
            -- the picker reads as a single panel.
            hl.TelescopeNormal = { bg = palette.bg_dim, fg = palette.fg }
            hl.TelescopeBorder = { bg = palette.bg_dim, fg = palette.bg_dim }
            hl.TelescopePromptNormal = { bg = palette.bg2 }
            hl.TelescopePromptBorder = { bg = palette.bg2, fg = palette.bg2 }
            hl.TelescopePromptTitle = { bg = palette.bg2, fg = palette.orange }
            hl.TelescopeResultsNormal = { bg = palette.bg_dim, fg = palette.grey2 }
            hl.TelescopeResultsBorder = { bg = palette.bg_dim, fg = palette.bg_dim }
            hl.TelescopePreviewNormal = { bg = palette.bg_dim }
            hl.TelescopePreviewBorder = { bg = palette.bg_dim, fg = palette.bg_dim }
            hl.TelescopeSelection = { bg = palette.bg3 }
            hl.TelescopeMatching = { fg = palette.orange, bold = true }

            -- lazygit.nvim links these to Normal by default, which makes the
            -- terminal float paint against the wrong surface.
            hl.LazyGitFloat = { bg = palette.bg_dim }
            hl.LazyGitBorder = { bg = palette.bg_dim, fg = palette.bg_dim }
        end,
    }

    everforest.load()
end

M.dependencies = {
    {
        'cormacrelf/dark-notify',
        config = function()
            require('dark_notify').run {
                schemes = {
                    dark = 'everforest',
                    light = 'everforest',
                },
            }
        end,
    },
}

return M
