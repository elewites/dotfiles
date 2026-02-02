return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    telescope.setup({
      defaults = {
        path_display = { "absolute" },
        dyanmic_preview_tile = { "true" },
        results_tilte = "false",
        wrap_results = { "true" },
        layout_strategy = "vertical",
        -- previewer = "false",
        previewer = "true",
        preview = {
          title = "true",
        },
        results_width = 0.99,
        winblend = 20, -- slightly transparent
        layout_config = {
          vertical = {
            -- height = 0.9,
            width = 0.8,
            -- preview_height = 0,
            -- prompt_position = "bottom",
          },
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-y>"] = function(prompt_bufnr)
              local entry = require("telescope.actions.state").get_selected_entry()
              if entry then
                local value = entry.value or entry[1]
                vim.fn.setreg("+", value)
                print("Yanked: " .. value)
              end
            end, -- yank to clipboard
          },
        },
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", function()
      require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
    end, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })

    keymap.set("n", "<leader>fc", function()
      require("telescope.builtin").find_files({
        prompt_title = "Neovim Config",
        cwd = vim.fn.stdpath("config"), -- Set to Neovim's config directory
        hidden = true, -- Include hidden files like `.lua`
      })
    end, { noremap = true, silent = true, desc = "Find Neovim Config Files" })
  end,
}
