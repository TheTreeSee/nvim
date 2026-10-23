-- Yazi file manager in a floating window
--  Files you open in yazi open in nvim; renames/moves update open buffers and LSP.
--  Press <F1> inside yazi for the nvim-specific keys (e.g. <C-s> grep in dir, <C-v> open in split).
-- https://github.com/mikavilpas/yazi.nvim

vim.pack.add {
  { src = 'https://github.com/mikavilpas/yazi.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
}

require('yazi').setup {
  -- neo-tree keeps handling `nvim <directory>`; set to true to use yazi for that instead
  open_for_directories = false,
  keymaps = {
    show_help = '<F1>',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>-', '<Cmd>Yazi<CR>', { desc = 'Yazi at current file' })
vim.keymap.set('n', '<leader>_', '<Cmd>Yazi cwd<CR>', { desc = 'Yazi in working directory' })
vim.keymap.set('n', '<C-Up>', '<Cmd>Yazi toggle<CR>', { desc = 'Resume last Yazi session' })
