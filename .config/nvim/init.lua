if vim.fn.has 'nvim' == 1 and vim.fn.executable 'nvr' == 1 then
    vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'
