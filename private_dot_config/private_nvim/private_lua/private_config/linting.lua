local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff" },
  markdown = { "markdownlint" },
  dockerfile = { "hadolint" },
  groovy = { "npm-groovy-lint" },
  cpp = { "cppcheck" },
}

---------------------------------------------------------------------
--- cpp
lint.linters.cppcheck = {
  cmd = "cppcheck",
  stdin = false,
  args = {
    "--enable=all",
    "--language=c++",
    "--std=c++17",
    "--suppressions-list=cppcheck-suppressions-list.txt",
    "--inline-suppr",
    "--template=gcc",
    vim.api.nvim_buf_get_name(0), -- Current buffer file
  },
  stream = "stderr", -- cppcheck writes diagnostics to stderr
  ignore_exitcode = false, -- cppcheck returns non-zero if issues found
  parser = require("lint.parser").from_errorformat(
    "%f:%l:%c: %trror: %m," .. "%f:%l:%c: %tarning: %m," .. "%f:%l:%c: %m",
    { source = "cppcheck" }
  ),
}

---------------------------------------------------------------------
--- Python

lint.linters.ruff.cmd = "python"
lint.linters.ruff.args = {
  "-m",
  "ruff",
  "check",
  "--output-format=json",
  function()
    return vim.api.nvim_buf_get_name(0)
  end,
}

-------------------------------------------------------------------
--- Commands
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    local filetype = vim.bo.filetype
    local linters = lint.linters_by_ft[filetype] or {}
    for _, linter in ipairs(linters) do
      print("[nvim-lint] Triggering lint.try_lint(): ", linter)
    end
    require("lint").try_lint()
  end,
})

vim.api.nvim_create_user_command("LintAvailable", function()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft] or {}
  if #linters == 0 then
    print("No linters configured for filetype: " .. ft)
  else
    print("Linters for filetype '" .. ft .. "': " .. table.concat(linters, ", "))
  end
end, { desc = "List linters for current filetype" })

vim.keymap.set("n", "<leader>ll", function()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft] or {}

  if #linters == 0 then
    print("No linters configured for filetype: " .. ft)
  else
    print("Running linters for '" .. ft .. "': " .. table.concat(linters, ", "))
  end

  lint.try_lint()
end, { desc = "Trigger linting for current file" })
