return {
  {
    "nathom/filetype.nvim",
    lazy = false,
    opts = {
      overrides = {
        extensions = {
          env = "sh",
        },
        complex = {
          [".env.*"] = "sh",
          ["tmux.conf"] = "tmux",
        },
      },
    },
  },
}
