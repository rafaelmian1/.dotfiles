-- Kanagawa Colorscheme

local M = {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    priority = 10000,
    lazy = false,
}

M.opts = {
    compile = true,
    undercurl = true,
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,
    dimInactive = false,
    terminalColors = true,

    -- Kanagawa ships `wave` (dark), `dragon` (darker/muted) and `lotus`
    -- (light). dark-notify swaps between wave and lotus below.
    background = {
        dark = 'wave',
        light = 'lotus',
    },

    -- Palette-level tweaks apply to every theme variant.
    colors = {
        theme = {
            all = {
                -- Float borders inherit the normal background so popups read
                -- as one surface rather than a stack of boxes.
                ui = { bg_gutter = 'none' },
            },
        },
    },

    overrides = function(colors)
        local theme = colors.theme
        return {
            -- Telescope: one continuous surface, borders tinted to match.
            TelescopeNormal = { bg = theme.ui.bg_m1, fg = theme.ui.fg },
            TelescopeBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { bg = theme.ui.bg_p1, fg = theme.ui.bg_p1 },
            TelescopePromptTitle = { bg = theme.ui.bg_p1, fg = theme.ui.special },
            TelescopeResultsNormal = { bg = theme.ui.bg_m1, fg = theme.ui.fg_dim },
            TelescopeResultsBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
            TelescopeSelection = { bg = theme.ui.bg_p2 },
            TelescopeMatching = { fg = theme.syn.special1, bold = true },

            -- lazygit.nvim floats: match the editor surface instead of
            -- linking straight to Normal.
            LazyGitFloat = { bg = theme.ui.bg_m1 },
            LazyGitBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },

            -- Popup menus share the float background so completion and
            -- documentation windows sit flush together.
            NormalFloat = { bg = theme.ui.bg_m1 },
            FloatBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
            FloatTitle = { bg = theme.ui.bg_m1, fg = theme.ui.special },

            Pmenu = { bg = theme.ui.bg_m1, fg = theme.ui.fg_dim },
            PmenuSel = { bg = theme.ui.bg_p2, fg = 'NONE' },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
        }
    end,
}

M.config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.cmd.colorscheme 'kanagawa'
end

M.dependencies = {
    {
        'cormacrelf/dark-notify',
        config = function()
            require('dark_notify').run {
                schemes = {
                    dark = 'kanagawa-wave',
                    light = 'kanagawa-lotus',
                },
            }
        end,
    },
}

return M
