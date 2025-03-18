local function map(mode, lhs, rhs, options)
    local default_opts = { noremap = true, silent = true }
    local opts = vim.tbl_extend('force', default_opts, options or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- NOTE: Here's what the options mean:
--   noremap = true: Don't allow the mapping to be remapped again (more predictable behavior)
--   silent = true: Don't show command output in the command line
--   expr = false: The right-hand side is not an expression to be evaluated
--   desc = "": Description of what the mapping does (useful for which-key and other plugins)

-- First things first, since this is Nvim, disable arrow keys in normal mode
for _, mode in pairs { 'n', 'i', 'v', 'x' } do
    for _, key in pairs { '<Up>', '<Down>', '<Left>', '<Right>' } do
        vim.keymap.set(mode, key, '<nop>')
    end
end

-- Basic navigation shortcuts
map({ 'n', 'x', 'o' }, '<leader>h', '^', { desc = 'Jump to start of line' })
map({ 'n', 'x', 'o' }, '<leader>l', 'g_', { desc = 'Jump to end of line' })
map('n', '<leader>a', ':keepjumps normal! ggVG<cr>', { desc = 'Select entire file' })
map('n', '<Left>', '<C-o>', { desc = 'Jump backwards on jumplist' })
map('n', '<Right>', '<C-i>', { desc = 'Jump forwards on jumplist' })

-- QuickFix list navigation
map('n', '<leader>cn', '<cmd>cnext<cr>zz', { desc = 'Next quickfix item' })
map('n', '<leader>cp', '<cmd>cprev<cr>zz', { desc = 'Previous quickfix item' })
map('n', '<leader>ln', '<cmd>lnext<cr>zz', { desc = 'Next location list item' })
map('n', '<leader>lp', '<cmd>lprev<cr>zz', { desc = 'Previous location list item' })

-- Delete text without yanking
map({ 'n', 'x' }, 'x', '"_x', { desc = 'Delete character without yanking' })
map({ 'n', 'x' }, 'X', '"_d', { desc = 'Delete selection without yanking' })

-- File operations
map('n', '<leader>wf', '<cmd>noa write<cr>', { desc = 'Write file without formatting' })
map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit current window' })
map('n', '<leader>Q', '<cmd>qa<cr>', { desc = 'Quit all windows' })
map('n', '<leader>qq', '<cmd>qa!<cr>', { desc = 'Force Quit current window' })

-- Tab management
map('n', 'te', ':tabedit', { desc = 'Open new tab' })
map('n', '<tab>', ':tabnext<cr>', { desc = 'Next tab' })
map('n', '<s-tab>', ':tabprev<cr>', { desc = 'Previous tab' })
map('n', 'tw', ':tabclose<cr>', { desc = 'Close tab' })

-- Buffer management
map('n', '<leader>bc', '<cmd>bdelete<cr>', { desc = 'Close current buffer' })
map('n', '<leader>bl', '<cmd>buffer #<cr>', { desc = 'Switch to last buffer' })
map('n', '<leader>bdo', '<cmd>%bd|e#<cr>', { desc = 'Delete all buffers except current' })
map('n', '<leader>bda', '<cmd>%bd<cr>', { desc = 'Delete all buffers' })

-- Improved scrolling behavior
map('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
map('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

-- Window Management
map('n', '<leader>pv', '<C-w>v', { desc = '[P]ane [V]ertical split' })
map('n', '<leader>ph', '<C-w>s', { desc = '[P]ane [H]orizontal split' })
map('n', '<leader>pe', '<C-w>=', { desc = '[P]ane [E]qual size' })
map('n', '<leader>pc', '<cmd>close<cr>', { desc = '[P]ane [C]lose current' })

-- Clear search highlighting
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlighting' })

-- Copy relative path
local function copy_relative_path()
    local relative_path = vim.fn.expand '%'
    vim.fn.setreg('+', relative_path)
    vim.notify('Relative path copied to clipboard: ' .. relative_path)
end

map('n', '<leader>rp', copy_relative_path, { desc = 'Copy relative path to clipboard' })

-- Make file executable
map('n', '<leader>ex', '<cmd>!chmod +x %<cr>', { desc = 'Make current file executable' })

-- Paste without yanking the replaced text
map('x', '<leader>v', [["_dP]], { desc = 'Paste over selection without yanking' })

-- Replace word under cursor in the entire file
map('n', '<leader>rs', [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
