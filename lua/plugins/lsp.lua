return {
  --- Tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "black",
        "flake8",
        "mypy",
        "ruff",
        "ansible-language-server",
        "ansible-lint",
        "terraform-ls",
        "dockerfile-language-server",
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
      servers = {
        pyright = {},
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
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
              ansiblelint = {
                enabled = true,
                path = "ansible-lint",
              },
              executionEnvironment = {
                enabled = false,
              },
              python = {
                interpreterPath = "python3",
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
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },

  --- Formatters
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { { "black" } },
        ["markdown"] = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        ["javascript"] = { "dprint" },
        ["javascriptreact"] = { "dprint" },
        ["typescript"] = { "dprint" },
        ["typescriptreact"] = { "dprint" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        dprint = {
          condition = function(ctx)
            return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },

  --- Linters
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        markdown = { "markdownlint" },
        python = { "flake8" },
        ansible = { "ansiblelint" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        luacheck = {
          condition = function(ctx)
            return vim.fs.find({ ".luacheckrc" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}
