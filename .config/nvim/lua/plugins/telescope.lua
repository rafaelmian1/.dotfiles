local M = {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
}

M.event = 'VimEnter'

M.dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
    'jvgrootveld/telescope-zoxide',
}

M.config = function()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local actions = require 'telescope.actions'
    local tree = require 'nvim-tree.api'

    local ivy = function(cb, config)
        local default_opts = { layout_config = { height = 0.8 } }
        local opts = config or {}
        return function()
            pcall(cb, require('telescope.themes').get_ivy(vim.tbl_deep_extend('force', default_opts, opts)))
        end
    end

    -- You can put your default mappings / updates / etc. in here
    --  All the info you're looking for is in `:help telescope.setup()`

    local opts = {}

    opts.defaults = {
        file_ignore_patterns = {
            '.git/',
            'node_modules/',
            '*-cache*',
            '.next/',
            'seed/data/',
            'script/data/',
            'build/',
            'dist/',
        },
        wrap_results = true,
        winblend = 0,
        mappings = {
            n = {
                -- Avoid opening the qflist when adding buffers
                ['<C-q>'] = actions.send_to_qflist,
                ['<M-q>'] = actions.send_selected_to_qflist,
            },
            i = {
                ['<C-R>'] = actions.to_fuzzy_refine,
                -- Avoid opening the qflist when adding buffers
                ['<C-q>'] = actions.send_to_qflist,
                ['<M-q>'] = actions.send_selected_to_qflist,
            },
        },
    }

    opts.pickers = {
        buffers = {
            mappings = {
                i = { ['<C-d>'] = actions.delete_buffer + actions.move_to_top },
            },
        },
    }

    opts.extensions = {
        fzf = {},
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
        zoxide = {
            list_command = 'zoxide query -ls',
            mappings = {
                default = {
                    action = function(selection)
                        vim.cmd.cd(selection.path)
                    end,
                    after_action = function(selection)
                        tree.tree.change_root(selection.path)
                    end,
                },
            },
        },
    }

    telescope.setup(opts)

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'zoxide')

    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', ivy(builtin.find_files), { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', ivy(builtin.builtin), { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', ivy(builtin.grep_string), { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', ivy(builtin.live_grep), { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', ivy(builtin.diagnostics), { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sq', ivy(builtin.quickfix), { desc = '[S]earch [Q]uickfix List' })
    vim.keymap.set('n', '<leader>sr', ivy(builtin.resume), { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', ivy(builtin.oldfiles), { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', ivy(builtin.buffers), { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim Files' })

    -- Shortcut for searching .dotfiles
    vim.keymap.set('n', '<leader>.', function()
        builtin.find_files {
            cwd = '~/.dotfiles',
            hidden = true,
            no_ignore = true,
        }
    end, { desc = '[S]earch [.]DotFiles' })

    -- Shortcut for searching your lazy plugins package files
    vim.keymap.set('n', '<leader>sp', function()
        builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy') }
    end, { desc = '[S]earch Lazy [P]ackages Files' })

    -- Shortcut for searching env files in cwd
    vim.keymap.set(
        'n',
        '<leader>se',
        ivy(function()
            builtin.find_files {
                no_ignore = true,
                hidden = true,
                search_file = '.env',
            }
        end),
        { desc = '[S]earch [E]nv Files' }
    )

    -- Shortcut for searching ignored files in cwd
    vim.keymap.set(
        'n',
        '<leader>si',
        ivy(function()
            builtin.find_files {
                no_ignore = true,
                hidden = true,
            }
        end),
        { desc = '[S]earch [I]gnored Files' }
    )

    vim.keymap.set('n', '<leader>cd', function()
        telescope.extensions.zoxide.list(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end)
end

return M
