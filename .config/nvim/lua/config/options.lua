-- Set space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set script encoding to UTF-8
vim.scriptencoding = 'utf-8'

-- Set buffer encoding to UTF-8
vim.opt.encoding = 'utf-8'

-- Set file encoding to UTF-8
vim.opt.fileencoding = 'utf-8'

-- Show line numbers
vim.opt.number = true

-- Show relative line numbers
vim.opt.relativenumber = true

-- Show file name in window title
vim.opt.title = true

-- Enable automatic indentation
vim.opt.autoindent = true

-- Enable smart indentation
vim.opt.smartindent = true

-- Highlight search results
vim.opt.hlsearch = true

-- Disable backup files
vim.opt.backup = false

-- Show commands as they are typed
vim.opt.showcmd = true

-- Hide command line when not being used
vim.opt.cmdheight = 0

-- Hide the status line
vim.opt.laststatus = 0

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Keep cursor 20 lines from the top/bottom when scrolling
vim.opt.scrolloff = 20

-- Show effects of substitution commands in a split
vim.opt.inccommand = 'split'

-- Ignore case in search patterns
vim.opt.ignorecase = true

-- Tab intelligently when performing completion
vim.opt.smarttab = true

-- Wrapped lines will be indented to match start
vim.opt.breakindent = true

-- Number of spaces for each step of indent
vim.opt.shiftwidth = 2

-- Number of spaces a tab counts for
vim.opt.tabstop = 2

-- Wrap long lines
vim.opt.wrap = true

-- Highlight the current line
vim.opt.cursorline = true

-- Make backspace work over line breaks and indentation
vim.opt.backspace = { 'start', 'eol', 'indent' }

-- Search down into subfolders with :find
vim.opt.path:append { '**' }

-- Ignore node_modules when using wildcard expansion
vim.opt.wildignore:append { '*/node_modules/*' }

-- Open new horizontal splits below current buffer
vim.opt.splitbelow = true

-- Open new vertical splits to the right of current buffer
vim.opt.splitright = true

-- Keep cursor position when splitting
vim.opt.splitkeep = 'cursor'

-- Auto-insert comment leader when pressing enter in a comment
vim.opt.formatoptions:append { 'r' }

-- Disable terminal GUI colors
vim.opt.termguicolors = true

-- Case-sensitive search when pattern contains uppercase
vim.opt.smartcase = true

-- Persistent undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undodir'

-- Reduce time for completion menu to appear (ms)
vim.opt.updatetime = 250

-- Don't show mode in command line (since you likely use a statusline plugin)
vim.opt.showmode = false

-- Minimum width for line numbers column
vim.opt.numberwidth = 4

-- Always leave signcolumn on to avoid text shifting
vim.opt.signcolumn = 'yes'

-- Highlight matching brackets
vim.opt.showmatch = true

-- Time in ms to show matching brackets
vim.opt.matchtime = 2

-- Show invisible characters
vim.opt.list = false
-- vim.opt.listchars = { tab = '▸ ', trail = '·', extends = '❯', precedes = '❮' }

-- Enable system clipboard integration
vim.opt.clipboard = 'unnamedplus'

-- Improve display for long paragraphs
vim.opt.linebreak = true

-- Don't give completion messages like 'match 1 of 2'
vim.opt.shortmess:append 'c'

-- Enable folding (za to toggle a fold)
vim.opt.foldenable = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- Needed for better plugin performance
vim.opt.hidden = true

-- Filetypes
vim.filetype.add {
    extension = {
        tf = 'terraform',
        tfvars = 'terraform',
    },
}
