return {
  -- {
  --   "nvimtools/none-ls.nvim",
  --   "davidmh/cspell.nvim",
  --   event = "VeryLazy",
  --   depends = { "davidmh/cspell.nvim" },
  --   opts = function(_, opts)
  --     local cspell = require("cspell")
  --     opts.sources = opts.sources or {}
  --     table.insert(
  --       opts.sources,
  --       cspell.diagnostics.with({
  --         diagnostics_postprocess = function(diagnostic)
  --           diagnostic.severity = vim.diagnostic.severity.HINT
  --         end,
  --       })
  --     )
  --     table.insert(opts.sources, cspell.code_actions)
  --   end,
  -- },

  --   vim.keymap.set("n", "<leader>cs", function()
  --     local filename = vim.fn.expand("%")
  --     vim.cmd("write") -- save buffer
  --     vim.cmd("!" .. "cspell " .. filename)
  --   end, { desc = "Check spelling with cspell", silent = true }),
}
