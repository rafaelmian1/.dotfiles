local M = {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    config = function()
        local extension_path = '$MASON/packages/codelldb/extension/'
        local codelldb_path = extension_path .. 'adapter/codelldb'
        local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
        local cfg = require 'rustaceanvim.config'

        vim.g.rustaceanvim = {
            dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            },
        }
    end,
}

return M
