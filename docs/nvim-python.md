---
title: Neovim - Python
tags:
  - Programming
  - python
  - nvim
created: 2022-09-19
updated: 2023-12-03
status: complete
category: note
---
# nvim-python

[My Neovim configuration based on LazyVim](https://github.com/jbarozet/nvim-lazyvim)
## Introduction
### External tooling for Python
To setup Neovim for Python, you will need:
- Langage Server Protocol (LSP) server for completion and diagnostics: **pyright** 
- Syntax highlighting and indentation: **Treesitter** with python installed 
- Linter: **flake8** (or ruff)
- Formatter: **black**
- Switching virtual env: AckslD/swenv.nvim

> Note: **ruff**: for faster python linting. Ruff can be used to replace Flake8 (plus dozens of plugins), isort, pydocstyle, yesqa, eradicate, pyupgrade, and autoflake, all while executing tens or hundreds of times faster than any individual tool. It is also exposed as a LSP and is  intended to be used alongside another Python LSP in order to support features like navigation and autocompletion.
### External Tooling installation
You can always install the necessary tools (pyright, flake8, ruff etc) outside of Neovim using the package manager of your choice. But I find it way easier to install them using the Neovim plugin called Mason. You can use Mason just by entering `:Mason` and then you are exposed with a nice TUI graphical interface where you can pick and choose which package you want to install. To have them automatically installed for a fresh new setup;, then it's better to have them defined in a neovim configuration file (I put all of them in my [lua/plugins/lsp.lua](https://github.com/jbarozet/nvim-lazyvim/blob/main/lua/plugins/lsp.lua) config file).
### Configuration
In terms of configuration, null-ls is a plugin that was commonly used in the community. null-ls is an interface to use things that are not language servers (like linters, formatters or event other neovim plugins) as if they were language servers. It somehow bridge the gap between LSP client and Servers and provides Formatting, Diagnostics and more. But it seems this plugin is extremely hard to maintain and `null-ls.vim` is not maintained anymore. This was announced by its maintainer mid 2023. A fork called `none-ls.nvim` has been created but there is a debate to know whether this is really a goog approach because the problem remains the same: it's a mess to maintain. LazyVim (folke) has decided to go with a different approach and  `none-ls.nvim` is no longer installed by default in LazyVim. 

They decided to go with this approach:
- `conform.nvim` is now the default formatter
- `nvim-lint` is now the default linter

## Syntax Highlighting
We will be using **Treesitter** for syntax highlighting.

To improve syntax highlighting we'll run a command to install the `treesitter` language parser for Python.

```
:TSInstall python
```

But - as always - it's better to have this configured so you get that with every new fresh install. I have it configured in [lua/plugins/treesitter.lua](https://github.com/jbarozet/nvim-lazyvim/blob/main/lua/plugins/treesitter.lua)

Example:
```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "ninja",
          "python",
          "bash",
          "python",
          "dockerfile",
          "hcl",
          "terraform",
          "toml",
          "yaml",
          "html",
          "json",
          "cpp",
          "css",
          "fish",
          "gitignore",
          "go",
          "java",
          "php",
          "rust",
        })
      end
    end,
  },
}

```

## Language Server (LSP)
This is the most important part of the configuration. Installing and configuring the LSP Server for your language. As always you a have a choice between different servers, each with pros and cons.

Here are the (common) steps to finalize your LSP configuration in Neovom:
- Install LSP server with Mason
- Configure with nvim-lspconfig

We'll be using the **pyright** language server for completion and diagnostics. I have also ruff configured there because it is exposed as a LSP and is  intended to be used alongside another Python LSP in order to support features like navigation and autocompletion.

To install the tools that we need, I will be using **mason.nvim**. This is a Neovim plugin that allows you to easily manage external editor tooling such as LSP servers, DAP servers, linters, and formatters through a single interface.

When you first open a file with LazyVim, `pyright` should be automatically installed. 

But if it's not you can use the `:Mason` command to install it. Just enter `:Mason`, find the `pyright` language server in the list and press `i` to install it.

My LSP installation and configuration is in [lua/plugins/lsp.lua](https://github.com/jbarozet/nvim-lazyvim/blob/main/lua/plugins/lsp.lua)
### Installation
LSP external tool (pyright) installation - Example using LazyVim:

```lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
      },
    },
  },
}
```

### Configuration
LSP Configuration - using LazyVim and nvim-lspconfig (pyright and ruff). As you can see below, I'm pretty much nothing configured for pyright. Most of the stuff is for ruff.

```lua
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
          settings = {
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

```

## Formatting
There are a few different tools that are commonly used to format code in Python — for instance `black` or `yapf`. But we will be using the **black** formatter which is the most used in the community.
### Install formatters
You can install these plugins with Mason by entering the `:Mason` command searching for `black` or `yapf` and pressing `i` on the entry to install the formatter.

If you want to make sure black is installed when you start a fresh new install - then add the following to your config:

[lua/plugins/lsp.lua](https://github.com/jbarozet/nvim-lazyvim/blob/main/lua/plugins/lsp.lua)

```lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "mypy",
        "ruff",
        "black"
      },
    },
  },
}
```

### Configure Formatters
To configure these formatters in Neovim, there is a couple of options:
- [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) - this ione has been commonly used for years and is now archived (not maintained anymore)
- [formatter.nvim](https://github.com/mhartington/formatter.nvim)
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Used by LazyVim

You can configure black by adding the following to your config (LazyVim with conform.nvim)

[lua/plugins/lsp.lua](https://github.com/jbarozet/nvim-lazyvim/blob/main/lua/plugins/lsp.lua)

```lua
return {
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
}

```

You can check by using: `:ConformInfo`


## Linting
We will be using **flake8**, a commonly used linter for Python. flake8 is used to enforce a particular style for your code.
### Installation
You can install flake8 with Mason by entering the `:Mason` command searching for `flake8` and pressing `i` on the entry to install.

or you can add it to Mason in the config file [lua/plugins/lsp.lua](https://github.com/jbarozet/nvim-lazyvim/blob/main/lua/plugins/lsp.lua)

```lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "flake8"
      },
    },
  },
}
```
### Configuration
For configuration use `nvim-lint`: It spawns linters, parses their output, and reports the results via the `vim.diagnostic` module.

[lua/plugins/lsp.lua](https://github.com/jbarozet/nvim-lazyvim/blob/main/lua/plugins/lsp.lua)

```lua
return {
 {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        markdown = { "markdownlint" },
        python = { "flake8" },
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
```

Then you have to define flake8 options in a file (.flake8) - you have to have a separate config file for each projects area. This config file should be versioned with the project itself:

```
[flake8]
# W291 - we dont care about trailing whitespace
# E302 - one line between functions is fine
# Q000 - double quote
ignore = W291,E302, Q000
max-complexity = 10
max-line-length = 120
```

### Ruff
This one is a bit special. Not sure yet if I'll keep it or not. Ruff can be used to replace Flake8 (plus dozens of plugins), Black, isort, pyupgrade, and more, all while executing tens or hundreds of times faster than any individual tool. It is exposed as a LSP and is  intended to be used alongside another Python LSP in order to support features like navigation and autocompletion.


## Managing Virtual Environments
**Plugin: swenv.nvim**

Being able to swap virtual environments on the fly is a very useful feature found in VSCode but is also possible in Neovim as well via adding a plugin: `AckslD/swenv.nvim`

