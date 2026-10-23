# TheTreeSee's Neovim config

My personal Neovim setup, built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
It keeps kickstart's single, fully commented `init.lua`, and puts my own additions in small files under
`lua/custom/plugins/`.

Requires **Neovim 0.12+**: plugins are managed with Neovim's built-in [`vim.pack`](https://neovim.io/doc/user/pack.html#vim.pack),
not lazy.nvim.

## What's in it

- **Languages:** Python, Rust, TypeScript/JavaScript (+ HTML, CSS, JSON), C/C++, Lua, with LSP, completion,
  treesitter highlighting and formatters, all installed automatically through Mason
- **Formatting on demand:** `<leader>f` formats; nothing formats on save
- **Start screen** when opening `nvim` without a file
- **lazygit**, **yazi** and **Claude Code** inside Neovim
- **Sessions and project switching:** each project remembers its open files
- **Markdown:** rendered in the buffer, with spell check for prose and commit messages
- Telescope, which-key, gitsigns, neo-tree, autopairs, indent guides, tokyonight

## Install

### 1. Dependencies (Arch)

```sh
sudo pacman -S --needed neovim git make gcc unzip ripgrep fd tree-sitter-cli npm wl-clipboard
```

Optional, for the integrations: `lazygit`, `yazi`, `zoxide`, `ghostty`, `rust` (for `rustfmt`), the
[Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI, and a [Nerd Font](https://www.nerdfonts.com/)
set in your terminal.

### 2. Clone

Back up any existing config first (`mv ~/.config/nvim ~/.config/nvim.bak`), then:

```sh
git clone https://github.com/TheTreeSee/nvim.git ~/.config/nvim
```

### 3. First start

Run `nvim`. Plugins install on the first start; language servers and treesitter parsers install in the background
(this takes a minute or two). Check progress with `:Mason`, and run `:checkhealth` if something looks off.

### 4. Make it the default editor (optional)

```sh
~/.config/nvim/extras/install.sh
```

This makes double-clicking a text or code file open it in Neovim in a new Ghostty window (HTML stays with your
browser), and sets `EDITOR`/`VISUAL` for GUI apps (after the next login). For terminals, also put
`export EDITOR=nvim VISUAL=nvim` in your `~/.bashrc`.

## Keymaps

Leader is `<Space>`. Press it and wait for which-key to show everything available.

| Keys | Action |
| --- | --- |
| **Files & search** | |
| `<leader>sf` / `<leader>sg` | Find files / grep in project |
| `<leader><leader>` | Open buffers |
| `<leader>s.` | Recent files |
| `<leader>sw` | Grep word under cursor |
| `<leader>sn` | Find files in this config |
| `\` | Toggle neo-tree |
| `<leader>-` / `<leader>_` | yazi at current file / in working dir |
| `<C-Up>` | Resume last yazi session |
| **Projects & sessions** | |
| `<leader>pp` | Pick a project (git repos in `~/Projects`, `~/Documents`) |
| `<leader>pz` | Pick from zoxide directories |
| `<leader>ps` / `<leader>pl` | Restore session for this dir / last session |
| `<leader>pS` | Choose a saved session |
| `<leader>pd` | Don't save the session on exit |
| **Code** | |
| `<leader>f` | Format buffer |
| `grd` / `grr` / `gri` | Go to definition / references / implementation |
| `grn` / `gra` | Rename / code action |
| `<leader>sd` / `<leader>q` | Search diagnostics / diagnostics list |
| `<leader>th` | Toggle inlay hints |
| **Git** | |
| `<leader>lg` or `<leader>gg` | lazygit |
| `<leader>gf` / `<leader>gl` | lazygit for current file's repo / log of current file |
| `]c` / `[c` | Next / previous change |
| `<leader>hs` / `<leader>hr` / `<leader>hp` | Stage / reset / preview hunk |
| `<leader>hb` | Blame line |
| **Claude Code** | |
| `<leader>ac` / `<leader>af` | Toggle / focus Claude |
| `<leader>as` | Send selection (visual), or add file (neo-tree) |
| `<leader>ab` | Add current buffer |
| `<leader>aa` / `<leader>ad` | Accept / reject a proposed edit |
| `<leader>ar` / `<leader>aC` | Resume / continue a Claude session |
| **Other** | |
| `<C-h/j/k/l>` | Move between windows |
| `<C-k>` (insert mode) | Move cursor left |
| `<leader>tm` | Toggle markdown rendering |
| `<C-\><C-n>` | Leave terminal mode (e.g. the Claude terminal) |

## Languages

| Language | LSP | Formatter |
| --- | --- | --- |
| Python | pyright, ruff | ruff |
| Rust | rust-analyzer | rustfmt |
| TS / JS | ts_ls, eslint | prettierd |
| HTML / CSS / JSON | html, cssls, jsonls | prettierd |
| C / C++ | clangd | clang-format |
| Lua | lua_ls | stylua |

Add a language by adding its server to `servers` and its formatter to `formatters_by_ft` in `init.lua`.

C/C++ projects need a `compile_commands.json` in the project root for clangd to find includes: CMake with
`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, ESP-IDF's `build/compile_commands.json` symlinked to the root, or
`bear -- make`. Formatting style comes from a `.clang-format` file (default is LLVM).

## Layout

```
init.lua                    kickstart's config, with my options, languages and keymaps
lua/custom/plugins/         my additions, loaded automatically
  dashboard.lua               start screen
  sessions.lua                sessions, project and zoxide pickers
  git.lua                     lazygit
  yazi.lua                    yazi file manager
  claude.lua                  Claude Code
  markdown.lua                markdown rendering, spell check
lua/kickstart/plugins/      optional kickstart plugins (neo-tree, lint, autopairs, indent lines, debug)
extras/                     default-editor setup (Ghostty launcher, .desktop file, install script)
nvim-pack-lock.json         pinned plugin versions
```

## Updating

- **Plugins:** `:lua vim.pack.update()`, review the changes, then `:write` to apply. Commit the updated
  `nvim-pack-lock.json`.
- **Language servers and tools:** `:Mason`, then `U` to update all.
- **Upstream kickstart:** this repo is a fork, so new kickstart changes can be merged in:

  ```sh
  git -C ~/.config/nvim remote add upstream https://github.com/nvim-lua/kickstart.nvim  # once
  git -C ~/.config/nvim fetch upstream && git -C ~/.config/nvim merge upstream/master
  ```

## Windows

<details><summary>Notes (not tested since the switch to vim.pack)</summary>

Clone into `%localappdata%\nvim` instead. The easiest way to get the dependencies is
[chocolatey](https://chocolatey.org/install) (`winget install --accept-source-agreements chocolatey.chocolatey`),
then in an **admin** terminal:

```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make cmake nodejs
npm install -g tree-sitter-cli
```

The `extras/` default-editor setup is Linux only. WSL also works: install the Arch or Ubuntu packages above inside it.
</details>

## License

MIT, inherited from kickstart.nvim. See [LICENSE.md](LICENSE.md).
