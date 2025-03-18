local M = {}

M.plugins = {
    {
        'zbirenbaum/copilot.lua',
        dependencies = {
            'copilotlsp-nvim/copilot-lsp',
        },
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
        cmd = 'Copilot',
        event = 'InsertEnter',
    },
    {
        'olimorris/codecompanion.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            adapters = {
                http = {
                    copilot = function()
                        return require('codecompanion.adapters').extend('copilot', {
                            schema = {
                                model = {
                                    default = 'claude-sonnet-4.6',
                                    choices = {
                                        'claude-sonnet-4.6', -- Best for agentic coding, 1x premium
                                        'claude-opus-4.6', -- Deep reasoning, complex architecture
                                        'claude-opus-4-6-fast', -- Opus quality, lower latency (preview)
                                        'claude-sonnet-4.5', -- Solid all-rounder
                                        'claude-haiku-4.5', -- Fast & cheap
                                    },
                                },
                            },
                        })
                    end,

                    copilot_cheap = function()
                        return require('codecompanion.adapters').extend('copilot', {
                            schema = {
                                model = {
                                    default = 'claude-haiku-4.5',
                                },
                            },
                        })
                    end,
                },
            },

            interactions = {
                chat = {
                    adapter = {
                        name = 'copilot',
                        model = 'claude-sonnet-4.6', -- Latest, excels at agentic coding & search
                    },
                },
                inline = {
                    adapter = {
                        name = 'copilot',
                        model = 'claude-sonnet-4.6', -- Same model, fast enough for inline
                    },
                },
                cmd = {
                    adapter = {
                        name = 'copilot',
                        model = 'claude-haiku-4.5', -- Vim commands don't need big models
                    },
                },
                background = {
                    adapter = {
                        name = 'copilot_cheap',
                    },
                },
            },

            display = {
                diff = {
                    enabled = true,
                    provider = 'inline',
                },
            },

            opts = {
                log_level = 'ERROR',
            },
        },
    },
}

return M.plugins
