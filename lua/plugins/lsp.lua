return {
  --- Tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "mypy",
        "ruff",
        "hadolint",
        "markdownlint",
        "nginx-language-server",
        "prettier",
        "rubocop",
        "shellcheck",
        "shfmt",
        "solargraph",
        "sql-formatter",
        "stylua",
        "tflint",
        "xmlformatter",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      pyright = {},
      lua_ls = {},
      html = {},
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      },
      --gopls = {},
      --ruby_ls = {},
      diagnosticls = {},
      dockerls = {},
      bashls = {},
      ansiblels = {
        filetypes = {
          "yaml.ansible",
        },
        settings = {
          ansible = {
            ansible = {
              path = "ansible",
              useFullyQualifiedCollectionNames = true,
            },
            ansibleLint = {
              enabled = true,
              path = "ansible-lint",
            },
            executionEnvironment = {
              enabled = false,
            },
            python = {
              interpreterPath = "python",
            },
            completion = {
              provideRedirectModules = true,
              provideModuleOptionAliases = true,
            },
          },
        },
      },
      terraformls = {},
      marksman = {},
      sqlls = {},
    },
  },
}
