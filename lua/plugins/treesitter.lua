return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "ninja",
          "python",
          "rst",
          "toml",
          "bash",
          "python",
          "dockerfile",
          "hcl",
          "terraform",
          "toml",
          "yaml",
          "html",
          "json",
          "json5",
          "jsonc",
          "astro",
          "cmake",
          "cpp",
          "css",
          "fish",
          "gitignore",
          "go",
          "graphql",
          "http",
          "java",
          "php",
          "rust",
          "scss",
          "sql",
          "svelte",
        })
      end
    end,
  },
}
