return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",

  config = function()
    local ufo = require("ufo")
    ufo.setup()

    -- remove folded highlight
    vim.api.nvim_set_hl(0, "Folded", { fg = "NONE", bg = "NONE" })

    -- keymaps
    vim.keymap.set("n", "zR", ufo.openAllFolds)
    vim.keymap.set("n", "zM", ufo.closeAllFolds)

    -- options
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
}
