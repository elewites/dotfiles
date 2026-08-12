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
    "omnisharp",
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
    "csharpier", -- C# formatter

    -- linters
    "markdownlint", -- markdown lint
    "npm-groovy-lint", -- groovy lint
    "hadolint", -- dockerfile
    "tclint",
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

local function omnisharp_root_dir(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fs.dirname(fname)

  while dir do
    if #vim.fn.glob(vim.fs.joinpath(dir, "*.csproj"), false, true) > 0 then
      on_dir(dir)
      return
    end

    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end

  on_dir(vim.fs.root(fname, { ".git" }))
end

vim.lsp.config("omnisharp", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = omnisharp_root_dir,
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({
      vim.fn.stdpath("data") .. "/mason/bin/OmniSharp",
      "-z",
      "--hostPID",
      tostring(vim.fn.getpid()),
      "-s",
      config.root_dir,
      "DotNet:enablePackageRestore=false",
      "--encoding",
      "utf-8",
      "--languageserver",
    }, dispatchers, { cwd = config.root_dir })
  end,
  filetypes = { "cs" },
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = { workspaceFolders = false },
  }),
  settings = {
    MsBuild = {
      LoadProjectsOnDemand = true,
    },
    RoslynExtensionsOptions = {
      EnableDecompilationSupport = true,
    },
  },
  cmd_env = {
    DOTNET_ROLL_FORWARD = "Major",
  },
})
vim.lsp.enable("omnisharp")

local servers = mason_lspconfig.get_installed_servers()

for _, server_name in ipairs(servers) do
  if server_name == "csharp_ls" or server_name == "omnisharp" then
    goto continue
  end

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
        "--query-driver=/usr/bin/g++,/usr/bin/clang,/usr/bin/gcc,/opt/poky/5.0.17/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux/aarch64-poky-linux-gcc",
      },
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "c", "cpp", "objc", "objcpp", "inc" },
    }
    vim.lsp.enable("clangd")
  end

  ::continue::
end

-- ty (astral python language server)
vim.lsp.config("ty", {
  -- cmd = { "python", "-m", "ty", "server" },
  cmd = { "ty", "server" },
  filetypes = { "python" },
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable("ty")
