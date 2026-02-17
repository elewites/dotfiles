return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        toml = { "prettier" },
        lua = { "stylua" },
        python = { "ruff" },
        go = { "gofumpt" },
        sh = { "beautysh" },
        cpp = { "clang_format" },
        cs = { "csharpier" },
      },
      formatters = {
        ruff = {
          command = "ruff",
          args = { "format", "-" },
        },
      },
      format_after_save = {
        lsp_format = "fallback",
      },
      notify_no_formatters = true,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = true,
      })
    end, { desc = "Format file or range (in visual mode)" })

    vim.api.nvim_create_user_command("ListFormatters", function()
      local formatters = conform.list_formatters(vim.api.nvim_get_current_buf())
      -- print(formatters) -- Display in a readable format
      print(vim.inspect(formatters))
    end, {})
  end,
}
