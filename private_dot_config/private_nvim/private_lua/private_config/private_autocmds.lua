-- Automatically disable automatic comment continuation
-- When opening a new buffer, remove 'o' from 'formatoptions'
-- This prevents Neovim from auto-inserting comment markers on new lines
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*", -- Applies to all buffers
  command = "set formatoptions-=o",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "query", "tsplayground", "markdown", "text" }, -- Applies to Treesitter query buffers, Markdown, plain text
  command = "setlocal wrap", -- Enables soft wrapping in these file types
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    -- check if treesitter has parser
    if require("nvim-treesitter.parsers").has_parser() then
      -- use treesitter folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    else
      -- use alternative foldmethod
      vim.opt.foldmethod = "syntax"
    end
  end,
})
