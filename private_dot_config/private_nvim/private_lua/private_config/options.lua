vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4

vim.g.netrw_winsize = 25 -- Width 25%
vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_altv = 1 -- Open splits to the right

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.cursorline = true
-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want cas-sensitve

-- turn on termguicolors for tokyonight colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so text does not shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard = "unnamedplus"

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- cache compiled lua modules for faster startup
vim.loader.enable()

-- enable spell suggestions
vim.opt.spell = true
vim.opt.spelllang = { "en" } -- or use en_us, fr, etc.
vim.opt.swapfile = false
