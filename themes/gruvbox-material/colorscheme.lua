-- Gruvbox Material Colorscheme

local M = {
    'sainnhe/gruvbox-material',
    name = 'gruvbox-material',
    priority = 10000,
    lazy = false,
}

M.config = function()
    -- gruvbox-material is a Vimscript colorscheme configured through globals
    -- rather than a setup() table.

    -- 'hard' | 'medium' | 'soft' — background contrast.
    vim.g.gruvbox_material_background = 'medium'

    -- 'material' | 'mix' | 'original' — foreground palette. 'material' is
    -- the softest and is the upstream default.
    vim.g.gruvbox_material_foreground = 'material'

    vim.g.gruvbox_material_disable_italic_comment = 1
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_transparent_background = 0
    vim.g.gruvbox_material_dim_inactive_windows = 0
    vim.g.gruvbox_material_visual = 'grey background'
    vim.g.gruvbox_material_menu_selection_background = 'blue'
    vim.g.gruvbox_material_sign_column_background = 'none'
    vim.g.gruvbox_material_ui_contrast = 'low'
    vim.g.gruvbox_material_float_style = 'dim'
    vim.g.gruvbox_material_better_performance = 1

    -- Telescope and lazygit floats: keep each popup on a single surface so
    -- borders don't read as a stack of boxes. gruvbox-material has no
    -- on_highlights hook, so hook the ColorScheme event instead.
    vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'gruvbox-material',
        group = vim.api.nvim_create_augroup('GruvboxMaterialOverrides', { clear = true }),
        callback = function()
            local config = vim.fn['gruvbox_material#get_configuration']()
            local palette = vim.fn['gruvbox_material#get_palette'](
                config.background,
                config.foreground,
                config.colors_override
            )
            local set = vim.api.nvim_set_hl
            local bg_dim = palette.bg_dim[1]
            local bg2 = palette.bg2[1]
            local bg4 = palette.bg4[1]
            local fg = palette.fg0[1]
            local grey = palette.grey1[1]
            local orange = palette.orange[1]

            set(0, 'TelescopeNormal', { bg = bg_dim, fg = fg })
            set(0, 'TelescopeBorder', { bg = bg_dim, fg = bg_dim })
            set(0, 'TelescopePromptNormal', { bg = bg2 })
            set(0, 'TelescopePromptBorder', { bg = bg2, fg = bg2 })
            set(0, 'TelescopePromptTitle', { bg = bg2, fg = orange })
            set(0, 'TelescopeResultsNormal', { bg = bg_dim, fg = grey })
            set(0, 'TelescopeResultsBorder', { bg = bg_dim, fg = bg_dim })
            set(0, 'TelescopePreviewNormal', { bg = bg_dim })
            set(0, 'TelescopePreviewBorder', { bg = bg_dim, fg = bg_dim })
            set(0, 'TelescopeSelection', { bg = bg4 })
            set(0, 'TelescopeMatching', { fg = orange, bold = true })

            set(0, 'LazyGitFloat', { bg = bg_dim })
            set(0, 'LazyGitBorder', { bg = bg_dim, fg = bg_dim })
        end,
    })

    vim.cmd.colorscheme 'gruvbox-material'
end

M.dependencies = {
    {
        'cormacrelf/dark-notify',
        config = function()
            require('dark_notify').run {
                schemes = {
                    dark = 'gruvbox-material',
                    light = 'gruvbox-material',
                },
            }
        end,
    },
}

return M
