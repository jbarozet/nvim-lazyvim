return {
  -- add catppuccin
  {
    "catppuccin", -- Make sure to use "catppuccin" and not "catppuccin/nvim"
    opts = {
      style = "mocha",
      transparent_background = true,
    },
  },
  -- add tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  -- Configure LazyVim to load catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
