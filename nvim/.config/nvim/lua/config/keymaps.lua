-- Keymaps are automatically loaded on the VeryLazy event
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Shortcuts
keymap.set({ "n", "x", "o" }, "<leader>h", "^")
keymap.set({ "n", "x", "o" }, "<leader>l", "g_")
keymap.set("n", "<leader>a", ":keepjumps normal! ggVG<cr>")

-- Delete text
keymap.set({ "n", "x" }, "x", '"_x')
keymap.set({ "n", "x" }, "X", '"_d')

-- Write without formatting
keymap.set("n", "<leader>w", "<cmd>noa write<cr>")
--
-- Save file and quit
keymap.set("n", "<leader>q", "<cmd>q<cr>", opts)
keymap.set("n", "<leader>Q", "<cmd>qa<cr>", opts)

-- File explorer with NvimTree
keymap.set("n", "<Leader>tf", ":NvimTreeFindFile<cr>", opts)
keymap.set("n", "<Leader>t", ":NvimTreeToggle<cr>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<cr>", opts)
keymap.set("n", "<s-tab>", ":tabprev<cr>", opts)
keymap.set("n", "tw", ":tabclose<cr>", opts)

-- Buffer management
keymap.set("n", "<leader>bc", "<cmd>bdelete<cr>")
keymap.set("n", "<leader>bl", "<cmd>buffer #<cr>")

-- Scrolling
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Window Management
keymap.set("n", "<leader>pv", "<C-w>v", { desc = "[P]ane [V]ertical split" })
keymap.set("n", "<leader>ph", "<C-w>s", { desc = "[P]ane [H]orizontal split" })
keymap.set("n", "<leader>pe", "<C-w>=", { desc = "[P]ane [E]qual size" })
keymap.set("n", "<leader>pc", "<cmd>close<CR>", { desc = "[P]ane [C]lose current" })

-- Tmux/Vim Nagivation
keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts)
keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts)
keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts)
keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts)

-- Reset hlsearch
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Copy relative path
local function copy_relative_path()
  local relative_path = vim.fn.expand("%")
  vim.fn.setreg("+", relative_path)
  vim.notify("Relative path copied to clipboard: " .. relative_path)
end

keymap.set("n", "<leader>rp", copy_relative_path, { noremap = true, silent = true })

-- Make file executable
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- QuickFix list
keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz")
keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz")
keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz")
keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz")

-- Pasting
keymap.set("x", "<leader>v", [["_dP]])

-- CodeSnap
keymap.set({ "x", "v" }, "<leader>csc", "<cmd>CodeSnap<cr>", { desc = "[C]odeSnap [C]opy to clipboard" })
keymap.set(
  { "x", "v" },
  "<leader>css",
  "<cmd>CodeSnapSave<cr>",
  { desc = "[C]odeSnap [S]ave to ~/bump/screenshots/code" }
)
