return {
  {
    "nathom/filetype.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      overrides = {
        extension = {
          ts = "typescript",
          tsx = "typescriptreact",
          sh = "sh",
        },
        complex = {
          ["tmux.conf"] = "tmux",
        },
        literal = {
          [".env"] = "sh",
          [".env.example"] = "sh",
          [".env.qa"] = "sh",
          [".env.local"] = "sh",
          [".env.development"] = "sh",
          [".env.production"] = "sh",
        },
      },
    },
  },
}
