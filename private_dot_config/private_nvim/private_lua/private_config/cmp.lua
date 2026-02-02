local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
require("luasnip.loaders.from_vscode").lazy_load()

-- nvim-cmp setup
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<M-k>"] = cmp.mapping.select_prev_item(),
    ["<M-j>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<M-e>"] = cmp.mapping.abort(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "spell" },
  }),
  -- formatting = {
  --   format = lspkind.cmp_format({
  --     maxwidth = 200,
  --     ellipsis_char = "...",
  --     symbol_map = {
  --       copilot = "", -- GitHub Copilot
  --       spell = "暈", -- Spell checker
  --       path = "🖫", -- File paths
  --       buffer = "Ω", -- Buffer content
  --       luasnip = "⋗", -- Snippets
  --       nvim_lsp = "λ", -- LSP
  --     },
  --   }),
  -- },
})

-- Cmdline completion setup
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline("?", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})
