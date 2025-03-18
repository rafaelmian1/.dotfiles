local M = {
    'kdheepak/lazygit.nvim',
    lazy = true,
}

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
