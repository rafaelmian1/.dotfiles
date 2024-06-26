return {
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")
      nvim_tmux_nav.setup({
        disable_when_zoomed = true,
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
        },
      })
    end,
  },
  {
    {
      "aserowy/tmux.nvim",
      config = function()
        return require("tmux").setup({
          copy_sync = {
            enable = false,
          },
          resize = {
            enable_default_keybindings = false,
          },
        })
      end,
    },
  },
}
