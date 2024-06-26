return {
  "mistricky/codesnap.nvim",
  build = "make build_generator",
  opts = {
    save_path = "~/bump/screenshots/code",
    border = "rounded",
    has_breadcrumbs = true,
    bg_theme = "grape",
    watermark = "",
  },
}
