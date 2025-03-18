return {
    {
        'rafaelmian1/tsc-errors.nvim',
        config = function()
            local builtin = require 'telescope.builtin'
            require('tsc-errors').setup {
                qf_preview = builtin.quickfix,
                key = ';da',
            }
        end,
    },
}
