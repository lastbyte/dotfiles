# Neovim config setup

This config uses [`lazy.nvim`](https://github.com/folke/lazy.nvim) as its plugin
manager (self-bootstrapping — no manual install step) plus `mason.nvim` for LSP
servers, linters, and formatters.

## 1. Core requirements (all platforms)

| Tool                                    | Why                                                                                                     | Min version                                |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| Neovim                                  | the editor itself (native `vim.lsp.config`/`vim.lsp.enable` API)                                        | **0.11+**                                  |
| git                                     | `lazy.nvim` clones itself and all plugins over git                                                      | any recent                                 |
| A C compiler (cc/gcc/clang)             | compiles Treesitter parsers (`:TSUpdate`)                                                               | any recent                                 |
| [Nerd Font](https://www.nerdfonts.com/) | icons in statusline, nvim-tree, fzf-lua, diagnostics                                                    | any Nerd Font, set as your terminal's font |
| ripgrep (`rg`)                          | `fzf-lua` live grep                                                                                     | any recent                                 |
| Node.js + npm                           | mason installs several LSPs via npm (`pyright`, `bashls`, `ts_ls`, `eslint_d`, `prettier_d`, `fixjson`) | LTS                                        |
| Python 3 + pip                          | mason installs python-based tools (`black`, `flake8`) through an isolated venv                          | 3.9+                                       |
| Go                                      | `gopls`, `gofumpt`, `go-revive`                                                                         | 1.21+                                      |
| A terminal clipboard tool (Linux only)  | `unnamedplus` clipboard option                                                                          | see below                                  |

Optional, only if you use that part of the config:

- **lazygit** binary — for `<leader>gg` (lazygit.nvim manages/builds this itself, but a system install works too)
- **tmux** — only relevant if you also use `vim-tmux-navigator` inside tmux

---

## 2. macOS

```bash
# Neovim (nightly/0.12+ — Homebrew's `neovim` formula is usually current enough;
# if it's older than 0.12, use `neovim head`)
brew install neovim
brew install --HEAD neovim   # only if the above is < 0.12

brew install git ripgrep node python go
brew install --cask font-jetbrains-mono-nerd-font   # or any other Nerd Font

# clipboard works out of the box on macOS (pbcopy/pbpaste), nothing to install

# optional
brew install lazygit tmux
```

Set your terminal (iTerm2/Terminal.app/Kitty/etc) font to the Nerd Font you installed.

---

## 3. Linux (Debian/Ubuntu example — swap for your distro's package manager)

```bash
# Neovim 0.12+: distro repos are usually too old, use the official AppImage/tarball
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

sudo apt update
sudo apt install -y git ripgrep build-essential nodejs npm python3 python3-pip golang

# clipboard support (pick one depending on X11 vs Wayland)
sudo apt install -y xclip        # X11
sudo apt install -y wl-clipboard # Wayland

# Nerd Font: download + install manually, e.g.
mkdir -p ~/.local/share/fonts
curl -Lo /tmp/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip /tmp/JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv

# optional
sudo apt install -y lazygit tmux   # lazygit may need a PPA/manual binary on older distros
```

Fedora/Arch: swap `apt` for `dnf`/`pacman` (package names are close to identical:
`ripgrep`, `nodejs`, `npm`, `python3`, `go`, `xclip`/`wl-clipboard`).

---

## 4. Windows

Two supported paths — pick one.

### Option A: native Windows (PowerShell)

```powershell
# via winget
winget install Neovim.Neovim
winget install Git.Git
winget install BurntSushi.ripgrep.MSVC
winget install OpenJS.NodeJS.LTS
winget install Python.Python.3.12
winget install GoLang.Go
winget install --id=DEVCOM.JetBrainsMonoNerdFont -e   # or any Nerd Font

# optional
winget install JesseDuffield.lazygit
```

Native Windows clipboard works automatically (no extra tool needed).
Also install a C compiler for Treesitter — easiest is the "Desktop development
with C++" workload from Visual Studio Build Tools, or `winget install
LLVM.LLVM` for clang.

Set your terminal (Windows Terminal, etc) font to the Nerd Font.

> Note: `lua/config/terminal.lua`'s floating terminal uses `$SHELL`, which
> isn't set on native Windows — the floating terminal (`<leader>t`) may not
> work there. It works fine under WSL.

### Option B: WSL2 (recommended — this config's `obsidian.lua` already assumes

a Linux-style path when `sysname == "Linux"`, which is what WSL reports)

Install WSL2 with your distro of choice, then follow the **Linux** steps above
inside it. Set the Windows Terminal font (not a Linux-side font) to your Nerd
Font, since rendering happens on the Windows side.

---

## 5. Install the config

```bash
git clone <this-repo-url> ~/.config/nvim   # macOS/Linux
# Windows native: clone to %LOCALAPPDATA%\nvim
```

Then just launch:

```bash
nvim
```

`lazy.nvim` bootstraps itself and installs all plugins automatically on first
launch (see `lua/config/lazy.lua`, plugin specs under `lua/plugins/`). Wait
for it to finish, then restart Neovim once.

---

## 6. Install LSP servers, linters, and formatters (mason)

After plugins are installed, run inside Neovim:

```vim
:Mason
```

Or non-interactively from a terminal:

```bash
nvim --headless -c 'lua
  local registry = require("mason-registry")
  local pkgs = {
    "efm", "lua-language-server", "pyright", "bash-language-server",
    "typescript-language-server", "gopls", "clangd",
    "stylua", "black", "flake8", "prettierd", "eslint_d", "fixjson",
    "shfmt", "shellcheck", "clang-format", "cpplint", "gofumpt",
    "luacheck", "revive",
  }
  registry.refresh(function()
    for _, name in ipairs(pkgs) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then pkg:install() end
    end
  end)
' -c 'sleep 60' -c 'qa!'
```

Servers enabled in `lua/plugins/lsp.lua`: `lua_ls`, `pyright`, `bashls`,
`ts_ls`, `gopls`, `clangd`, `efm` (formatting/linting glue for
c/cpp/css/go/html/js/json/lua/markdown/python/sh/ts/vue/svelte). Rust is
handled separately by `rustaceanvim`, which installs/manages `rust-analyzer`
itself — no manual mason step needed, just have Rust's toolchain reachable if
you want `cargo`-based project features.

**Known gap:** `luacheck` and `revive` (lua/go linters) need `luarocks` and a
working `go` toolchain respectively to build — if those aren't on `PATH`
mason's install for them will silently fail. Not required for formatting
(`stylua`/`gofumpt` still work), only for lint diagnostics on those two
languages.

---

## 7. Verify

```vim
:checkhealth
```

Then open a file (e.g. a `.py` or `.lua` file), make it messy, save it — it
should auto-format (see `lua/config/autocmds.lua`). Check `:LspInfo` to
confirm the right servers attached.
