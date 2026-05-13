-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>qt", function()
    Snacks.bufdelete()
end, { desc = "Quit Tab" })

vim.keymap.set("n", "<leader>cc", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header" })

vim.keymap.set("n", "gt", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "gT", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })

vim.keymap.set("n", "<leader>yf", function()
    vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Yank Filename" })

vim.keymap.set("n", "<leader>yp", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Yank File Path" })
