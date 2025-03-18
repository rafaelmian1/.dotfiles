local M = {
    'saghen/blink.cmp',
    version = '*',
}

M.dependencies = {
    'rafamadriz/friendly-snippets',
    'brenoprata10/nvim-highlight-colors',
    'giuxtaposition/blink-cmp-copilot',
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
    signature = { enabled = true, window = { border = 'single' } },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    sources = {
        -- default = { 'lsp', 'path', 'snippets', 'buffer' },
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
            copilot = {
                name = 'copilot',
                module = 'blink-cmp-copilot',
                score_offset = 100,
                async = true,
            },
        },
    },
    completion = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before _and_ after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        keyword = { range = 'full' },

        -- Disable auto brackets
        -- NOTE: some LSPs may add auto brackets themselves anyway
        accept = { auto_brackets = { enabled = false } },

        -- Don't select by default, auto insert on selection
        list = { selection = { preselect = false, auto_insert = true } },

        menu = {
            border = 'single',

            -- Don't automatically show the completion menu
            auto_show = false,

            -- nvim-cmp style menu
            draw = {
                columns = {
                    { 'kind_icon' },
                    { 'label', 'label_description', gap = 1 },
                },
            },
            -- avoid menu and ghost text overlap
            direction_priority = function()
                local ctx = require('blink.cmp').get_context()
                local item = require('blink.cmp').get_selected_item()
                if ctx == nil or item == nil then
                    return { 's', 'n' }
                end

                local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
                local is_multi_line = item_text:find '\n' ~= nil

                -- after showing the menu upwards, we want to maintain that direction
                -- until we re-open the menu, so store the context id in a global variable
                if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                    vim.g.blink_cmp_upwards_ctx_id = ctx.id
                    return { 'n', 's' }
                end
                return { 's', 'n' }
            end,
        },

        -- Show documentation when selecting a completion item
        documentation = {
            window = { border = 'single' },
        },
        -- Display a preview of the selected item on the current line
        ghost_text = { enabled = true },
    },
}

return M
