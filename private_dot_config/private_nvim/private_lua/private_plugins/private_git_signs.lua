return {
  "https://github.com/lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
  end,

  vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {}),
  vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>"),
}
