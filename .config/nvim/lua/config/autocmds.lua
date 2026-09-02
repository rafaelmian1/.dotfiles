-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- :Theme [name] — switch colour theme across the whole terminal stack.
-- With no argument it opens the picker; <leader>uc does the same.
vim.api.nvim_create_user_command('Theme', function(opts)
    local theme = require 'config.theme'
    if opts.args == '' then
        theme.pick()
    else
        theme.set(opts.args)
    end
end, {
    nargs = '?',
    desc = 'Switch colour theme',
    complete = function(lead)
        return vim.tbl_filter(function(name)
            return name:find(lead, 1, true) == 1
        end, require('config.theme').list())
    end,
})
