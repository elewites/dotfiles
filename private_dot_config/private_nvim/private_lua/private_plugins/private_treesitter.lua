return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Treat .tpp files as C++ for syntax highlighting
    vim.filetype.add({
      extension = {
        tpp = "cpp",
      },
    })
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "vimdoc",
        "c",
        "cpp",
        "python",
        "go",
        "git_config",
        "gitignore",
        "gitattributes",
        "gitcommit",
        "git_rebase",
        "groovy",
        "nix",
        "meson",
        "ssh_config",
        "c_sharp",
      },
      -- fold = { enable = "true" },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
