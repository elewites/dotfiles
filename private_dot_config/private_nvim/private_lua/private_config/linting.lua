local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff" },
  markdown = { "markdownlint" },
  dockerfile = { "hadolint" },
  groovy = { "npm-groovy-lint" },
  c = { "cppcheck" },
  cpp = { "cppcheck" },
  -- tcl = { "tclint" },
}

---------------------------------------------------------------------
--- cpp
local cppcheck_parser = require("lint.parser").from_errorformat(
  "%f:%l:%c: %trror: %m," .. "%f:%l:%c: %tarning: %m," .. "%f:%l:%c: %m",
  { source = "cppcheck" }
)

local function cppcheck_args()
  local args = {
    "--enable=all",
    "--language=c++",
    "--std=c++17",
    "--inline-suppr",
    "--template=gcc",
  }
  local suppressions = vim.fs.find("cppcheck-suppressions-list.txt", {
    upward = true,
    type = "file",
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })[1]

  if suppressions then
    table.insert(args, "--suppressions-list=" .. suppressions)
  else
    vim.notify("[cppcheck] suppression file not found; continuing without it", vim.log.levels.WARN)
  end

  return args
end

lint.linters.cppcheck = function()
  return {
    cmd = "cppcheck",
    stdin = false,
    args = cppcheck_args(),
    stream = "stderr", -- cppcheck writes diagnostics to stderr
    ignore_exitcode = false,
    parser = function(output, bufnr, cwd)
      -- if vim.trim(output) ~= "" then
      --   vim.notify("[cppcheck] stderr:\n" .. vim.trim(output), vim.log.levels.INFO)
      -- end

      return cppcheck_parser(output, bufnr, cwd)
    end,
  }
end

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
