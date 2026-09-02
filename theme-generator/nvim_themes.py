"""Per-theme nvim colorscheme.lua bodies.

Each colorscheme plugin exposes a different options table, so these are hand
written per theme rather than templated. All of them keep the same shape as
the original config: a lazy.nvim spec with dark-notify as a dependency that
swaps variants when macOS appearance changes.
"""

ROSE_PINE = """-- Rosé Pine Colorscheme

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
"""

TOKYONIGHT = """-- Tokyo Night Colorscheme

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
"""

EVERFOREST = """-- Everforest Colorscheme

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
"""

GRUVBOX_MATERIAL = """-- Gruvbox Material Colorscheme

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
"""

KANAGAWA = """-- Kanagawa Colorscheme

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
"""

NVIM = {
    "rose-pine": ROSE_PINE,
    "tokyo-night": TOKYONIGHT,
    "everforest": EVERFOREST,
    "gruvbox-material": GRUVBOX_MATERIAL,
    "kanagawa": KANAGAWA,
}
