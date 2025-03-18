local M = { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
}

M.opts = {
    ensure_installed = {
        'bash',
        'c',
        'diff',
        'markdown',
        'markdown_inline',
        'html',
        'css',
        'scss',
        'json',
        'jsdoc',
        'javascript',
        'typescript',
        'styled',
        'lua',
        'luadoc',
        'vim',
        'vimdoc',
        'rust',
        'groovy',
        'yaml',
        'toml',
        'sql',
        'query',
    },
    highlight = {
        enable = true,
        disable = function(_, buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        additional_vim_regex_highlighting = false,
    },
}

return M
