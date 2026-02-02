-------------------------------------------
--- Modules
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

----------------------------------------------
-- Mason
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

----------------------------------------------
-- Mason lspconfig
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "gopls",
    "nil_ls", -- nix lsp
    "bashls",
    "dockerls",
    "clangd",
    "mesonlsp",
  },
  automatic_installation = false,
})

-----------------------------------------------
-- Mason tool installer
mason_tool_installer.setup({
  ensure_installed = {
    -- formatters
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "gofumpt", -- go formatter
    "beautysh", -- bash

    -- linters
    "markdownlint", -- markdown lint
    "npm-groovy-lint", -- groovy lint
    "hadolint", -- dockerfile
  },
})

-------------------------------------------
--- lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local on_attach = function(_, bufnr)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
  vim.keymap.set("n", "gf", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = bufnr, desc = "List references" })
  vim.keymap.set(
    "n",
    "gs",
    "<cmd>Telescope lsp_document_symbols<CR>",
    { buffer = bufnr, desc = "List document symbols" }
  )
end

servers = mason_lspconfig.get_installed_servers()

for _, server_name in ipairs(servers) do
  print("Configuring " .. server_name)

  -- general
  vim.lsp.config(server_name, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable(server_name)

  -- targeted
  if server_name == "clangd" then
    vim.lsp.config._configs.clangd = {
      cmd = {
        "clangd",
        "--log=verbose",
        "--background-index",
        "--all-scopes-completion",
        "--clang-tidy",
        "--completion-style=detailed",
        "--query-driver=/usr/bin/g++,usr/bin/clang,/usr/bin/gcc",
      },
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "c", "cpp", "objc", "objcpp" },
    }
    vim.lsp.enable("clangd")
  end
end

-- ty (astral python language server)
vim.lsp.config("ty", {
  cmd = { "python", "-m", "ty", "server" },
  filetypes = { "python" },
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable("ty")
