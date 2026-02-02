return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    local transparent = false

    -- Colors inspired by VS Code Dark+ palette
    local bg = "#1e1e1e"
    local bg_dark = "#1b1b1b"
    local bg_highlight = "#2c2c2c"
    local bg_search = "#264f78"
    local bg_visual = "#264f78"
    local fg = "#d4d4d4"
    local fg_dark = "#c5c5c5"
    local fg_gutter = "#4b5263"
    local border = "#3f3f46"

    require("tokyonight").setup({
      style = "night",
      transparent = transparent,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = transparent and "transparent" or "dark",
        floats = transparent and "transparent" or "dark",
      },
      on_colors = function(colors)
        colors.bg = bg
        colors.bg_dark = transparent and colors.none or bg_dark
        colors.bg_float = transparent and colors.none or bg_dark
        colors.bg_highlight = bg_highlight
        colors.bg_popup = bg_dark
        colors.bg_search = bg_search
        colors.bg_sidebar = transparent and colors.none or bg_dark
        colors.bg_statusline = transparent and colors.none or bg_dark
        colors.bg_visual = bg_visual
        colors.border = border
        colors.fg = fg
        colors.fg_dark = fg_dark
        colors.fg_float = fg
        colors.fg_gutter = fg_gutter
        colors.fg_sidebar = fg_dark
      end,
    })

    vim.cmd("colorscheme tokyonight")
  end,
}
