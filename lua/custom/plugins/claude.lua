-- Claude Code integration: run Claude in a split, send selections, review its edits as diffs
-- https://github.com/coder/claudecode.nvim

vim.pack.add { 'https://github.com/coder/claudecode.nvim' }

require('claudecode').setup {
  terminal = {
    split_side = 'right',
    split_width_percentage = 0.35,
  },
}

-- NOTE: Inside the Claude terminal, use <C-\><C-n> to get back to normal mode
vim.keymap.set('n', '<leader>ac', '<Cmd>ClaudeCode<CR>', { desc = 'Toggle [C]laude' })
vim.keymap.set('n', '<leader>af', '<Cmd>ClaudeCodeFocus<CR>', { desc = '[F]ocus Claude' })
vim.keymap.set('n', '<leader>ar', '<Cmd>ClaudeCode --resume<CR>', { desc = '[R]esume Claude session' })
vim.keymap.set('n', '<leader>aC', '<Cmd>ClaudeCode --continue<CR>', { desc = '[C]ontinue last Claude session' })
vim.keymap.set('n', '<leader>am', '<Cmd>ClaudeCodeSelectModel<CR>', { desc = 'Select Claude [M]odel' })
vim.keymap.set('n', '<leader>ab', '<Cmd>ClaudeCodeAdd %<CR>', { desc = 'Add current [B]uffer to Claude' })
vim.keymap.set('v', '<leader>as', '<Cmd>ClaudeCodeSend<CR>', { desc = '[S]end selection to Claude' })
vim.keymap.set('n', '<leader>aa', '<Cmd>ClaudeCodeDiffAccept<CR>', { desc = '[A]ccept Claude diff' })
vim.keymap.set('n', '<leader>ad', '<Cmd>ClaudeCodeDiffDeny<CR>', { desc = '[D]eny Claude diff' })

-- In neo-tree, <leader>as adds the file under the cursor
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-claudecode-tree', { clear = true }),
  pattern = 'neo-tree',
  callback = function(event) vim.keymap.set('n', '<leader>as', '<Cmd>ClaudeCodeTreeAdd<CR>', { desc = 'Add file to Claude', buf = event.buf }) end,
})
