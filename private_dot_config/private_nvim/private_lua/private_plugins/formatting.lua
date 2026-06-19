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
        prettier = {
          command = "prettier",
          args = {
            "--stdin-filepath",
            "$FILENAME",
            "--config",
            vim.fn.expand("~/.config/nvim/.prettierrc.json"),
          },
        },
        ruff = {
          command = "ruff",
          args = { "format", "-" },
        },
      },
      format_on_save = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        vim.notify("[CONFORM] Formatting: " .. bufname, vim.log.levels.INFO)
        return {
          lsp_fallback = true,
          async = true,
        }
      end,
      notify_no_formatters = true,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      vim.notify("[CONFORM] Formatting: " .. bufname, vim.log.levels.INFO)
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
