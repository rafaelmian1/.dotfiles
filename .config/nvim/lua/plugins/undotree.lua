local M = {
    'mbbill/undotree',
}

M.config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
end

return M
