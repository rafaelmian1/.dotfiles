return {
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap, dapui = require 'dap', require 'dapui'
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio',
        },
        config = function()
            require('dapui').setup()
        end,
    },
    {
        'mfussenegger/nvim-dap-python',
        ft = 'python',
        dependencies = { 'mfussenegger/nvim-dap' },
        config = function()
            -- Uses the project's venv python (via $VIRTUAL_ENV/.venv) for the debuggee,
            -- debugpy itself comes from mason
            require('dap-python').setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')
            require('dap-python').test_runner = 'pytest'
        end,
    },
}
