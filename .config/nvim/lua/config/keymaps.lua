-- Keymaps are automatically loaded on the VeryLazy event
local keymap = vim.keymap

local function opts(overrides)
  local options = { noremap = true, silent = true, expr = false, desc = "" }

  if type(overrides) == "table" then
    for k, v in pairs(overrides) do
      options[k] = v
    end
  end

  return options
end

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
keymap.set("n", "<leader>q", "<cmd>q<cr>", opts())
keymap.set("n", "<leader>Q", "<cmd>qa<cr>", opts())

-- File explorer with NvimTree
keymap.set("n", "<Leader>ef", ":NvimTreeFindFile<cr>", opts())
keymap.set("n", "<Leader>e", ":NvimTreeToggle<cr>", opts())

-- Tabs
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<cr>", opts())
keymap.set("n", "<s-tab>", ":tabprev<cr>", opts())
keymap.set("n", "tw", ":tabclose<cr>", opts())

-- Buffer management
keymap.set("n", "<leader>bc", "<cmd>bdelete<cr>")
keymap.set("n", "<leader>bl", "<cmd>buffer #<cr>")
keymap.set("n", "<leader>bdo", "<cmd>%bd|e#<cr>")
keymap.set("n", "<leader>bda", "<cmd>%bd<cr>")

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
keymap.set("n", "<leader>pc", "<cmd>close<cr>", { desc = "[P]ane [C]lose current" })
-- Resize panes
keymap.del({ "n", "i", "v" }, "<A-j>")
keymap.del({ "n", "i", "v" }, "<A-k>")
keymap.del("n", "<C-Left>")
keymap.del("n", "<C-Down>")
keymap.del("n", "<C-Up>")
keymap.del("n", "<C-Right>")

keymap.set("n", "<M-h>", '<cmd>lua require("tmux").resize_left()<cr>', opts())
keymap.set("n", "<M-j>", '<cmd>lua require("tmux").resize_bottom()<cr>', opts())
keymap.set("n", "<M-k>", '<cmd>lua require("tmux").resize_top()<cr>', opts())
keymap.set("n", "<M-l>", '<cmd>lua require("tmux").resize_right()<cr>', opts())
--
-- Tmux/Vim Nagivation
keymap.set("n", "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", opts())
keymap.set("n", "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", opts())
keymap.set("n", "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", opts())
keymap.set("n", "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", opts())
keymap.set("n", "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<cr>", opts())

-- Reset hlsearch
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Copy relative path
local function copy_relative_path()
  local relative_path = vim.fn.expand("%")
  vim.fn.setreg("+", relative_path)
  vim.notify("Relative path copied to clipboard: " .. relative_path)
end

keymap.set("n", "<leader>rp", copy_relative_path, opts())

-- Make file executable
keymap.set("n", "<leader>ex", "<cmd>!chmod +x %<cr>", opts())

-- QuickFix list
keymap.set("n", "<leader>cn", "<cmd>cnext<cr>zz")
keymap.set("n", "<leader>cp", "<cmd>cprev<cr>zz")
keymap.set("n", "<leader>ln", "<cmd>lnext<cr>zz")
keymap.set("n", "<leader>lp", "<cmd>lprev<cr>zz")

-- Pasting
keymap.set("x", "<leader>v", [["_dP]])

-- Replace Word in all file
keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], opts())

-- Lazydocker
keymap.set("n", "<leader>k", "<cmd>LazyDocker<cr>", opts())

-- Generate Compile Errors QF list
local function compile_errors_qflist()
  local output = vim.fn.systemlist("npx tsc --noEmit")
  local qf_list = {}

  for _, line in ipairs(output) do
    if line:match("^Found") then
      goto continue
    end

    local file, row, col, message = line:match("^(.-)%((%d+),(%d+)%)%s*:%s*error TS%d+:%s*(.*)$")
    if file and row and col and message then
      message = message:gsub("^%s+", "")
      table.insert(qf_list, {
        filename = file,
        lnum = tonumber(row),
        col = tonumber(col),
        text = message,
      })
    end

    ::continue::
  end

  vim.fn.setqflist({}, "r", { title = "TSC compile errors", items = qf_list })
  require("fzf-lua").quickfix()
end

keymap.set("n", ";da", compile_errors_qflist, opts({ desc = "Compile Errors QF List" }))
