return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffers
    "hrsh7th/cmp-path", -- source for file system paths
    "hrsh7th/cmp-nvim-lsp", -- source for lsp server
    "hrsh7th/cmp-cmdline", -- source for cmd line
    -- cmp_luasnip connects LuaSnip engine to nvim-cmp, without it nvmim-cmp would not know about my snippets
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets", -- useful predefined snippets
    "onsails/lspkind.nvim",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
    },
  },
  config = function()
    require("config.cmp") -- Load your modular config
  end,
}
