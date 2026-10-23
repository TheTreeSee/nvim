-- Start screen shown when nvim is opened without a file
--  Type the first letters of an item to jump to it, <CR> to open it.
--  See `:help mini.starter`

local starter = require 'mini.starter'

local header = table.concat({
  '        *        ',
  '       /_\\       ',
  '      /_ _\\      ',
  '     /_ _ _\\     ',
  '    /_ _ _ _\\    ',
  '   /_ _ _ _ _\\   ',
  '       |_|       ',
  '',
  '   N E O V I M   ',
}, '\n')

local function footer()
  local v = vim.version()
  return string.format('v%d.%d.%d  ·  %d plugins  ·  %s', v.major, v.minor, v.patch, #vim.pack.get(), os.date '%A %d %B')
end

-- Recent files for this folder, or everywhere when started from ~
local function recent_files() return starter.sections.recent_files(6, vim.fn.getcwd() ~= vim.env.HOME)() end

starter.setup {
  evaluate_single = true,
  header = header,
  footer = footer,
  items = {
    { section = 'Actions', name = 'Find file', action = 'Telescope find_files' },
    { section = 'Actions', name = 'Grep text', action = 'Telescope live_grep' },
    { section = 'Actions', name = 'Projects', action = 'Projects' },
    { section = 'Actions', name = 'Session restore', action = function() require('persistence').load() end },
    { section = 'Actions', name = 'Yazi', action = 'Yazi cwd' },
    { section = 'Actions', name = 'Lazygit', action = 'LazyGit' },
    { section = 'Actions', name = 'Claude Code', action = 'ClaudeCode' },
    { section = 'Actions', name = 'New file', action = 'enew' },
    { section = 'Actions', name = 'Update plugins', action = function() vim.pack.update() end },
    { section = 'Actions', name = 'Quit', action = 'qall' },
    recent_files,
  },
  content_hooks = {
    starter.gen_hook.adding_bullet '  ',
    starter.gen_hook.aligning('center', 'center'),
  },
}
