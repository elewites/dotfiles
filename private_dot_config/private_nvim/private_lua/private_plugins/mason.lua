return {
  "williamboman/mason.nvim",
  -- cmd = "Mason",
  -- event = "VeryLazy",
  dependencies = {
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "neovim/nvim-lspconfig" },
  },
  config = function()
    require("config.mason")
  end,
}
