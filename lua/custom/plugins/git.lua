-- Git UI: lazygit in a floating window
-- https://github.com/kdheepak/lazygit.nvim

vim.pack.add {
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
}

vim.keymap.set('n', '<leader>gg', '<Cmd>LazyGit<CR>', { desc = 'Lazy[G]it' })
vim.keymap.set('n', '<leader>lg', '<Cmd>LazyGit<CR>', { desc = '[L]azy[G]it (same as the shell alias)' })
vim.keymap.set('n', '<leader>gf', '<Cmd>LazyGitCurrentFile<CR>', { desc = 'LazyGit for repo of current [F]ile' })
vim.keymap.set('n', '<leader>gl', '<Cmd>LazyGitFilterCurrentFile<CR>', { desc = '[G]it [L]og of current file' })
