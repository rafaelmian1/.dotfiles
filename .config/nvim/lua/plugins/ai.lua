local function nes_apply()
    return require('sidekick').nes_jump_or_apply()
end

return {
    {
        -- Copilot backend (copilot-language-server). Auth via `:Copilot auth`.
        -- Ghost text/panel disabled: completions go through blink.cmp (blink-copilot),
        -- next edit suggestions through sidekick.nvim.
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = { 'InsertEnter', 'BufReadPost' },
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                yaml = true,
                gitcommit = true,
            },
        },
    },
    {
        -- Copilot Next Edit Suggestions + AI CLI terminals (claude, copilot, codex, gemini, ...)
        'folke/sidekick.nvim',
        event = 'VeryLazy',
        opts = {
            cli = {
                mux = { backend = 'tmux', enabled = vim.env.TMUX ~= nil },
            },
        },
        keys = {
            {
                '<C-y>',
                function()
                    if not nes_apply() then
                        vim.api.nvim_feedkeys(vim.keycode '<C-y>', 'n', false)
                    end
                end,
                desc = 'Goto/Apply Next Edit Suggestion',
            },
            -- stylua: ignore start
            { '<C-.>', function() require('sidekick.cli').toggle() end, mode = { 'n', 't', 'i', 'x' }, desc = 'Sidekick Toggle CLI' },
            { '<leader>ia', function() require('sidekick.cli').toggle() end, desc = 'Sidekick Toggle CLI' },
            { '<leader>is', function() require('sidekick.cli').select() end, desc = 'Sidekick Select CLI' },
            { '<leader>id', function() require('sidekick.cli').close() end, desc = 'Sidekick Detach CLI' },
            { '<leader>it', function() require('sidekick.cli').send { msg = '{this}' } end, mode = { 'n', 'x' }, desc = 'Sidekick Send This' },
            { '<leader>if', function() require('sidekick.cli').send { msg = '{file}' } end, desc = 'Sidekick Send File' },
            { '<leader>iv', function() require('sidekick.cli').send { msg = '{selection}' } end, mode = 'x', desc = 'Sidekick Send Selection' },
            { '<leader>ip', function() require('sidekick.cli').prompt() end, mode = { 'n', 'x' }, desc = 'Sidekick Select Prompt' },
            -- stylua: ignore end
        },
    },
}
