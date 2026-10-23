-- Sessions & project switching
--  persistence.nvim saves a session per directory (and git branch) when you quit,
--  and <leader>pp jumps between projects, restoring each one's session.
-- https://github.com/folke/persistence.nvim

vim.pack.add { 'https://github.com/folke/persistence.nvim' }

-- Don't save empty windows or terminal buffers (e.g. Claude) in sessions
vim.opt.sessionoptions:remove { 'blank', 'terminal' }

local persistence = require 'persistence'
persistence.setup()

vim.keymap.set('n', '<leader>ps', persistence.load, { desc = 'Restore [S]ession for current dir' })
vim.keymap.set('n', '<leader>pl', function() persistence.load { last = true } end, { desc = 'Restore [L]ast session' })
vim.keymap.set('n', '<leader>pS', persistence.select, { desc = '[S]elect a saved session' })
vim.keymap.set('n', '<leader>pd', persistence.stop, { desc = "[D]on't save session on exit" })

-- Git repos under these folders show up in the project picker
local project_roots = { '~/Projects', '~/Documents' }
-- Extra folders to always list, git repo or not
local extra_projects = { '~/.config/nvim' }

local function has_file_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= '' then return true end
  end
  return false
end

local function switch_to(dir)
  -- Save the project we're leaving, then close its buffers (asks about unsaved changes)
  if has_file_buffers() then persistence.save() end
  if not pcall(vim.cmd, 'confirm %bwipeout') then return end

  vim.fn.chdir(dir)
  if vim.fn.filereadable(persistence.current()) == 1 or vim.fn.filereadable(persistence.current { branch = false }) == 1 then
    persistence.load()
  else
    require('telescope.builtin').find_files()
  end
end

local function find_projects()
  local roots = vim.tbl_filter(function(d) return vim.fn.isdirectory(d) == 1 end, vim.tbl_map(vim.fs.normalize, project_roots))
  local cmd = { 'fd', '--hidden', '--no-ignore', '--type', 'd', '--max-depth', '4', '--prune', '--exclude', 'node_modules', '--glob', '.git' }
  vim.list_extend(cmd, roots)
  local out = vim.system(cmd, { text = true }):wait()

  local dirs = vim.tbl_map(vim.fs.normalize, extra_projects)
  for line in (out.stdout or ''):gmatch '[^\n]+' do
    table.insert(dirs, vim.fs.dirname((line:gsub('/$', ''))))
  end
  table.sort(dirs)
  return dirs
end

-- Your most used directories according to zoxide (the `z` command), most frecent first
local function find_zoxide_dirs()
  local out = vim.system({ 'zoxide', 'query', '--list' }, { text = true }):wait()
  return vim.split(out.stdout or '', '\n', { trimempty = true })
end

local function pick_dir(title, dirs)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = title,
      finder = finders.new_table {
        results = dirs,
        entry_maker = function(dir) return { value = dir, display = vim.fn.fnamemodify(dir, ':~'), ordinal = dir } end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          switch_to(action_state.get_selected_entry().value)
        end)
        return true
      end,
    })
    :find()
end

local function pick_project() pick_dir('Projects', find_projects()) end
local function pick_zoxide() pick_dir('Zoxide', find_zoxide_dirs()) end

vim.keymap.set('n', '<leader>pp', pick_project, { desc = '[P]ick a project' })
vim.keymap.set('n', '<leader>pz', pick_zoxide, { desc = 'Pick from [Z]oxide dirs' })
vim.api.nvim_create_user_command('Projects', pick_project, { desc = 'Pick a project' })
