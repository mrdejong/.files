-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, opts)
  opts = opts or {}
  return function(lhs, rhs, desc)
    opts.desc = desc or ""
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local imap = map("i", { silent = true })
local nmap = map("n", { silent = true })

imap("jk", "<Esc>")
imap("jw", "<Esc>:w<cr>")
imap("jl", "<Esc>la")
imap("j;", "<Esc>$a;<Esc>")
imap("jo", "<Esc>o")
imap("jO", "<Esc>O")
imap("jp", "<Esc>p")
imap("jP", "<Esc>P")

nmap("<Tab>", ":BufferLineCycleNext<cr>")
nmap("<S-Tab>", ":BufferLineCyclePrev<cr>")
nmap("<S-H>", ":BufferLineMovePrev<cr>")
nmap("<S-L>", ":BufferLineMoveNext<cr>")
