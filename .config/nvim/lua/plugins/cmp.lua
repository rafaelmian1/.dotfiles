local M = {
    'saghen/blink.cmp',
    version = '*',
}

M.dependencies = {
    'rafamadriz/friendly-snippets',
}

M.opts = {
    cmdline = { enabled = false },
    keymap = {
        preset = 'none',
        ['<C-a>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-y>'] = { 'select_and_accept' },

        ['<C-p>'] = { 'select_prev' },
        ['<C-n>'] = { 'select_next' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    appearance = {
        nerd_font_variant = 'mono',
    },
    signature = { enabled = true },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
}

return M
