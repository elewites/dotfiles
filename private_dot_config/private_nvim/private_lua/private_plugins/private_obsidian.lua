-- locals
local vault = vim.loop.fs_realpath(vim.fn.expand("~/vault"))

-- lua table
return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    -- "BufReadPre " .. vim.fn.expand("/mnt/c/Users/erosrodr/Documents/obsidian-vault/*.md"),
    "BufReadPre "
      .. vault
      .. "/*.md",

    -- "BufNewFile " .. vim.fn.expand("~/vault"),
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      -- {
      { name = "personal", path = vim.fn.expand("~/vault") },
      -- path = "~/vault",
      -- },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
    ui = {
      enable = false, -- 🔧 disables all UI features like backlinks/status/outline
    },
    note_id_func = function(title)
      local date_prefix = os.date("%Y%m%d%H%M%S")
      if title ~= nil then
        local formatted_title = title:gsub("%s+", "_"):lower()
        return date_prefix .. "_" .. formatted_title
      else
        return date_prefix
      end
    end,
  },

  -- key maps
  vim.keymap.set("n", "<leader>ot", function()
    require("obsidian").util.toggle_checkbox()
  end, { desc = "Toggle Obsidian task checkbox", silent = true }),
  vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianFollowLink<CR>", { desc = "Follow Obsidian link" }),
}
