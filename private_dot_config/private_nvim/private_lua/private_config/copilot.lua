local copilot = require("copilot")
-- local copilot_chat = require("CopilotC-Nvim/CopilotChat.nvim")

copilot.setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      next = "<M-n>",
      dismiss = "<M-e>",
    },
  },
  assistant = { enabled = true },
  panel = { enabled = true },
})

-- copilot_chat.setup({
--   model = "gpt-4.1", -- AI model to use
--   temperature = 0.1, -- Lower = focused, higher = creative
--   -- window = {
--   --   layout = "vertical", -- 'vertical', 'horizontal', 'float'
--   --   width = 0.5, -- 50% of screen width
--   -- },
-- })
