---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "gopls",
        "pyright",
        "typescript-language-server",
        "json-lsp",
        "yaml-language-server",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "clangd",
        "bash-language-server",
        "dockerfile-language-server",
        "sqlls",
        "taplo",               -- TOML
        "marksman",            -- Markdown
        "prisma-language-server",
        "buf-language-server", -- Protobuf
        "ltex-ls",             -- Grammar/spell
        "jdtls",               -- Java
        "vimls",               -- VimL

        -- Formatters
        "stylua",
        "gofumpt",
        "goimports",
        "prettier",
        "biome",
        "black",
        "isort",
        "shfmt",
        "clang-format",

        -- Linters
        "golangci-lint",
        "eslint_d",
        "markdownlint",
        "shellcheck",

        -- DAP
        "delve",       -- Go debugger
        "debugpy",     -- Python debugger
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}
