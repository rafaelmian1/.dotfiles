local M = { 'windwp/nvim-autopairs' }

M.event = { 'InsertEnter' }

M.dependencies = { 'hrsh7th/nvim-cmp' }

M.config = function()
    local autopairs = require 'nvim-autopairs'

    autopairs.setup {
        check_ts = true, -- enable treesitter
        ts_config = {
            lua = { 'string' }, -- don't add pairs in lua string treesitter nodes
            javascript = { 'template_string' }, -- don't add pairs in javscript template_string treesitter nodes
        },
    }

    -- make autopairs and completion work together
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

return M
