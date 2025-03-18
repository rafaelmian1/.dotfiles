local M = {
    'kdheepak/lazygit.nvim',
    lazy = true,
}

M.init = function()
    vim.g.lazygit_floating_window_winblend = 10
end

M.cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
}

M.dependencies = {
    'nvim-lua/plenary.nvim',
}

M.keys = {
    { ';c', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
}

return M
