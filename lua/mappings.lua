require "nvchad.mappings"
local bufnr = vim.api.nvim_get_current_buf()
local utils = require "gale.utils"
local map = utils.glb_map
local del = utils.del_map

-- GROUP: [[ CORE MAPPINGS ]]

-- Enter cmd mode with ";"
map("n", ";", ":", { desc = "Enter CMD mode" })
-- Exit insert mode with "jk"
map("i", "jk", "<ESC>")
-- Save using Ctrl+s
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>")
-- Prevent force-closing with Ctrl+z / Ctrl+Z
map("n", "<C-z>", "<nop>")
map("n", "<C-S-z>", "<nop>")
-- Prevent f from jumpingg to matching next pressed key
map("n", "f", "<nop>")
-- Remove a whole word with Ctrl+Backspace
-- https://github.com/neovim/neovim/issues/2048
map("i", "<C-h>", "<Esc>cvb")
-- Prevent cursor jumping back to where selection started on yank
map("v", "y", "ygv<Esc>")
-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
-- Move lines up/down
map("n", "<A-Down>", ":m .+1<CR>")
map("n", "<A-j>", ":m .+1<CR>")
map("n", "<A-Up>", ":m .-2<CR>")
map("n", "<A-k>", ":m .-2<CR>")
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi")
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
map("v", "<A-Down>", ":m '>+1<CR>gv=gv")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-Up>", ":m '<-2<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- GROUP: [[ PLUGIN MAPPINGS ]]

-- PLUGIN: ccc
map("n", "cc", "<cmd>CccConvert<CR>", { desc = "Change Color space" })
map("n", "ch", "<cmd>CccHighlighterToggle<CR>", { desc = "Toggle Color highlighter" })
map("n", "<Leader>cp", "<cmd>CccPick<CR>", { desc = "Open Color picker" })

-- PLUGIN: code-companion
map({ "n", "v" }, "´´", "<cmd>CodeCompanionToggle<CR>", { desc = "Toggle CodeCompanion" })
map({ "n", "v" }, "<leader>ñ", "<cmd>Gen<CR>", { desc = "Toggle Gen" })

-- PLUGIN: comment
-- Bind a single key that selects between single and
-- multiline comment styles based on the current context
-- "n" is pre-mapped and adding it breaks the functionality
map("x", "<leader>/", "<cmd>set operatorfunc=v:lua.__toggle_contextual<CR> g@")
-- Force single-line block-comment
map("n", "<leader>_", function()
  require("Comment.api").toggle.blockwise.current()
end)

-- PLUGIN: conform
map("n", "<leader>fm", "<cmd>FormatFile<CR>", { desc = "Format file" })

-- PLUGIN: crates
map("n", "<leader>cu", function()
  local crates = require "crates"
  crates.upgrade_all_crates()
end, { desc = "Update crates" })

-- PLUGIN: dap
local widgets = require "dap.ui.widgets"
local sidebar = widgets.sidebar(widgets.scopes)
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")
map("n", "<leader>dt", function()
  sidebar.toggle()
end, { desc = "Toggle debugging sidebar" })

-- PLUGIN: dap-python
map("n", "<leader>dpr", function()
  require("dap-python").test_method()
end)

-- PLUGIN: lsp-saga
map({ "n", "v" }, "cA", "<cmd>Lspsaga code_action<CR>", { desc = "LSP Code action" })
map("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "LSP Toggle outline" })
map("n", "gh", "<cmd>Lspsaga finder<CR>", { desc = "LSP Find symbol definition" })
map("n", "cr", "<cmd>Lspsaga rename<CR>", { desc = "LSP Rename in file" })
map("n", "cR", "<cmd>Lspsaga rename ++project<CR>", { desc = "LSP Rename in selected files" })
map("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "LSP Peek at definition" })
map("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "LSP Go to definition" })
map("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "LSP Go to type definition" })
map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "LSP Prev diagnostics" })
map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "LSP Next diagnostics" })
map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "LSP Hover" })
map("n", "[E", function()
  require("lspsaga.diagnostic"):goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = "LSP Prev error" })
map("n", "]E", function()
  require("lspsaga.diagnostic"):goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = "LSP Next error" })

-- PLUGIN: md-preview
map("n", "<leader>mp", "<cmd> MarkdownPreviewToggle <CR>", { desc = "Toggle Markdown Preview" })

-- PLUGIN: popurri
map("n", "<leader>pp", "<cmd>Popurri<CR>", { desc = "Toggle Popurri" })

-- PLUGIN: rustaceanvim
map("n", "K", function()
  vim.cmd.RustLsp { "hover", "actions" }
end, { silent = true, buffer = bufnr, desc = "Rust Hover" })
map("n", "<leader>a", function()
  -- vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
  vim.lsp.buf.codeAction() -- if you don't want grouping.
end, { silent = true, buffer = bufnr, desc = "Rust Code actions" })

-- PLUGIN: searchbox
map("n", "<leader>s", "<cmd>SearchBoxIncSearch<CR>", {
  desc = "Enter Searchbox",
})
map("n", "<leader>r", "<cmd>SearchBoxReplace<CR>", {
  desc = "Enter Replace Searchbox",
})

-- PLUGIN: tabufline
map("n", "<leader>x", "<cmd>NvCloseBuffer<CR>", { desc = "Close current buffer" })

-- PLUGIN: signs
map("n", "<leader>bl", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })

-- PLUGIN: telescope
del("n", "<leader>fz")
map("n", "<leader>f?", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Help tags" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope Search files" })
local all_files = "Telescope find_files follow=true no_ignore=true hidden=true"
map("n", "<leader>fa", "<cmd>" .. all_files .. "<CR>", { desc = "Telescope Search all files" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Search old files" })
map("n", "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Find in current file" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Buffers" })
map("n", "<leader>tf", "<cmd>Telescope terms<CR>", { desc = "Telescope Terms" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope NvChad themes" })
map("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "Telescope LSP references" })
map("n", "<leader>ts", "<cmd>Telescope treesitter<CR>", { desc = "Telescope TreeSitter" })
map("n", "<leader>fvo", "<cmd>Telescope vim_options<CR>", { desc = "Telescope Vim options" })
map("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Telescope Highlights" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })

-- PLUGIN: treesitter-playground
map({ "n", "v" }, "<leader>pl", "<cmd>TSPlaygroundToggle<CR>", { desc = "Toggle TSPlayground" })

-- PLUGIN: trouble
map("n", "<leader>tt", "<cmd>TroubleToggle<CR>", { desc = "Toggle Trouble" })

-- PLUGIN: yerbreak
map({ "n", "v" }, "<leader>yb", "<cmd>Yerbreak<CR>", { desc = "Toggle Yerbreak" })
