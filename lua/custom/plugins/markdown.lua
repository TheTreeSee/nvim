-- Markdown & notes: render headings, tables, checkboxes etc. inside the buffer
-- https://github.com/MeanderingProgrammer/render-markdown.nvim

vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
}

vim.keymap.set('n', '<leader>tm', '<Cmd>RenderMarkdown toggle<CR>', { desc = '[T]oggle [M]arkdown rendering' })

-- Spell check for prose. Add 'nl' to spelllang to also check Dutch (nvim offers to download it).
--  ]s / [s jump between mistakes, z= suggests fixes, zg adds a word to your dictionary
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-prose', { clear = true }),
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en'
  end,
})
