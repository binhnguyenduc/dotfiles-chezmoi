# Nix vs Chezmoi Dotfiles Comparison

> Comparing `~/dotfiles/nix` (Nix flakes + home-manager) with `dotfiles-chezmoi` (chezmoi + Homebrew)

---

## Table of Contents

- [Architecture](#architecture)
- [Shell (ZSH)](#shell-zsh)
  - [Plugin Management](#plugin-management)
  - [Plugins](#plugins)
  - [Prompt](#prompt)
  - [History](#history)
  - [Keybindings](#keybindings)
  - [Completions (zstyle)](#completions-zstyle)
  - [Environment Variables](#environment-variables)
  - [Custom Functions](#custom-functions)
  - [Startup Behavior](#startup-behavior)
  - [Feature Toggles](#feature-toggles)
- [Aliases](#aliases)
  - [Shell Aliases](#shell-aliases)
  - [Git Aliases](#git-aliases)
- [Git Configuration](#git-configuration)
  - [Core Settings](#core-settings)
  - [Delta Themes (Chezmoi Only)](#delta-themes-chezmoi-only)
- [Neovim / Vim](#neovim--vim)
  - [Architecture](#neovim-architecture)
  - [Plugins](#neovim-plugins)
  - [Features](#neovim-features)
- [tmux](#tmux)
  - [Core Settings](#tmux-core-settings)
  - [Plugins](#tmux-plugins)
  - [FZF Menu Entries (Chezmoi Only)](#fzf-menu-entries-chezmoi-only)
- [Other Config Files](#other-config-files)
- [System Packages](#system-packages)
  - [Languages & Runtimes](#languages--runtimes)
  - [Go Development](#go-development)
  - [Kubernetes](#kubernetes)
  - [CLI Tools](#cli-tools)
  - [Linters & Formatters](#linters--formatters)
  - [Infrastructure / DevOps](#infrastructure--devops)
  - [Editors & GUI Apps](#editors--gui-apps)
  - [macOS Specific](#macos-specific)
  - [Package Counts](#package-counts)
- [What You Lose Switching to Chezmoi](#what-you-lose-switching-to-chezmoi)
- [What You Gain Switching to Chezmoi](#what-you-gain-switching-to-chezmoi)
- [Bottom Line](#bottom-line)

---

## Architecture

| Aspect | Nix | Chezmoi |
|---|---|---|
| Config management | Nix flakes + home-manager | chezmoi |
| Package delivery | Nix store (reproducible, pinned via flake.lock) | Homebrew (latest from tap) |
| Config approach | Declarative Nix expressions | Template files (`dot_*`) |
| Reproducibility | Exact (flake.lock pins everything) | Best-effort (brew versions float) |
| Cross-platform | macOS, Ubuntu, EndeavourOS | macOS + Linux (brew-based) |
| Complexity | Moderate (~20 nix files) | High (hundreds of config lines) |
| Update mechanism | `nix flake update` (manual) | `autoupdate.zsh` every 7 days |

---

## Shell (ZSH)

### Plugin Management

| Aspect | Nix | Chezmoi |
|---|---|---|
| Plugin manager | Oh-My-Zsh + Nix-managed plugins | Zinit (lazy-loading from GitHub) |
| Plugin delivery | Nix store (declarative) | Zinit auto-install |
| Config file | `modules/common/shell.nix` | `dot_zshrc` (657 lines) |

### Plugins

| Plugin | Nix | Chezmoi | Notes |
|---|---|---|---|
| git (omz) | yes | - | |
| sudo (omz) | yes | - | Double-ESC to prefix sudo |
| docker (omz) | yes | - | |
| golang (omz) | yes | - | |
| kubectl (omz) | yes | - | |
| kubectx (omz) | yes | - | |
| rust (omz) | yes | - | |
| command-not-found (omz) | yes | - | |
| pass (omz) | yes | - | |
| helm (omz) | yes | - | |
| zsh-completions | yes | yes | |
| zsh-syntax-highlighting | yes | - | |
| fast-syntax-highlighting | - | yes | Faster replacement for zsh-syntax-highlighting |
| powerlevel10k | yes | - | |
| yazpt | - | yes | Custom prompt with dynamic segments |
| fzf-tab | yes | yes | |
| zsh-autosuggestions | - | yes | Fish-like autosuggestions |
| zsh-you-should-use | - | yes | Reminds about existing aliases |
| zsh-notify | - | yes | Desktop notifications for long commands |
| forgit | - | yes | Interactive git operations via fzf |
| zsh-vi-mode | - | yes | VI keybindings |
| direnv | - | yes | Per-directory environment switching |
| git-extras | - | yes | Extended git commands |

### Prompt

| Aspect | Nix | Chezmoi |
|---|---|---|
| Theme | Powerlevel10k | Yazpt (custom) |
| GitHub check status | No | Yes (polled every 10s) |
| Late-night reminder | No | Yes (11pm-6am warning) |
| Error response | Standard | Random excuse from 800+ BOFH excuses |
| Success celebration | No | Fireworks animation (iTerm2) on git push |
| Custom segments | None (stock p10k) | 4 custom segments |

### History

| Setting | Nix | Chezmoi |
|---|---|---|
| Size | 10,000 | 10,000 |
| Storage | `$XDG_DATA_HOME/zsh/history` | `$XDG_DATA_HOME/zsh/history` |
| appendhistory | yes | yes |
| sharehistory | yes | yes |
| hist_ignore_space | yes | yes |
| hist_ignore_all_dups | yes | yes |
| hist_save_no_dups | yes | yes |
| hist_find_no_dups | yes | yes |
| globdots | - | yes |
| interactivecomments | - | yes |

### Keybindings

| Aspect | Nix | Chezmoi |
|---|---|---|
| Mode | Emacs (`bindkey -e`) | VI mode (zsh-vi-mode) |
| History back | Ctrl+P | VI mode bindings |
| History forward | Ctrl+N | VI mode bindings |
| Kill region | Ctrl+Alt+W | - |
| Insert cursor | N/A | Blinking beam |
| Normal cursor | N/A | Block |

### Completions (zstyle)

| Completion Target | Nix | Chezmoi |
|---|---|---|
| cd / zoxide preview | eza listing | eza listing |
| ls preview | cat | eza listing |
| git checkout sorting | Disabled | Disabled |
| git diff preview | - | Syntax-highlighted diffs |
| git log preview | - | Colored log output |
| brew package info | - | `brew info` preview |
| man pages | - | batman (colored) |
| process/kill preview | - | Detailed process info |
| env variable preview | - | Variable value display |
| command preview | - | tldr → man → which fallback |
| File filter | - | Ignores .DS_Store, Icon? |
| Popup style | Standard | tmux popup support |

### Environment Variables

| Variable | Nix | Chezmoi |
|---|---|---|
| EDITOR | nvim | nvim |
| MANPAGER | Default | bat with man syntax |
| LESSOPEN / LESSCOLORIZER | - | bat for colored output |
| BAT_THEME | - | gruvbox dark |
| LS_COLORS | - | vivid gruvbox dark |
| SET_TERMINAL_COLORS | - | true |
| START_TMUX | - | true (auto tmux) |
| DOCKER_HOST | colima socket | - |
| OPENSSL_DIR/LIB_DIR/INCLUDE_DIR | Nix-managed paths | - |
| GPG_TTY | yes | - |
| SSH_AUTH_SOCK | gpg agent | - |
| TAVILY_API_KEY | yes | - |
| PATH: ~/.local/bin | yes | - |
| PATH: ~/.npm-global/bin | yes | - |
| PATH: ~/go/bin | yes | - |
| PATH: Python 3.9 (macOS) | yes | - |

### Custom Functions

| Function | Nix | Chezmoi |
|---|---|---|
| claude() / claude-sc() | yes (profile switching) | - |
| set_terminal() | - | Terminal detection, iTerm2 profile/wallpaper |
| preexec() | - | tmux UUID tracking, brew completion updates |
| precmd() | - | Brew completion refresh |
| zshexit() | - | Cleanup + figlet/cowsay exit message |
| insult() | - | 200+ random insults |
| excuse() | - | 800+ BOFH excuses |
| compliment() | - | 1100+ random compliments |
| command_not_found_handler() | - | thefuck integration |
| br() | - | broot integration |
| zsh_stats() | - | History statistics |
| periodic() | - | GH checks status every 10s |
| term-notify() | - | Custom notification handler |
| tmux_bindings() | - | Display tmux key bindings |
| expand-command-aliases() | - | Expand aliases for history |

### Startup Behavior

| Step | Nix | Chezmoi |
|---|---|---|
| Load plugins | yes | yes |
| Set PATH | yes | yes |
| Terminal detection | - | yes (auto-detect + color setup) |
| Auto-start tmux | - | yes |
| Auto-install Homebrew | - | yes (if missing) |
| ASCII welcome art | - | yes (fortune + cowsay, snoozable 12h) |
| GitHub status display | - | yes |
| Cache cleanup offers | - | yes (Go, Docker) |

### Feature Toggles

| Toggle | Nix | Chezmoi Default |
|---|---|---|
| CHEERS_ENABLED | N/A | true |
| INSULTS_ENABLED | N/A | true |
| INSULTS_OFFENSIVE_ENABLED | N/A | false |
| CNF_TF_ENABLED | N/A | true |
| ASCII_WELCOME_ENABLED | N/A | true |
| AUTO_CLEAR_CACHES | N/A | true (every 3 months) |

---

## Aliases

### Shell Aliases

| Alias | Nix | Chezmoi |
|---|---|---|
| `vim` | `nvim` | `nvim` |
| `ls` | `ls --color` | `eza` (with options) |
| `tree` | - | `eza --tree` |
| `ctrl-l` / `C-l` / `control-l` | `clear` | - |
| `clean` | `clear` | - |
| `c` | - | `clear` |
| `o` | - | `open` |
| `q` | - | `exit` |
| `du` | - | `dust` |
| `df` | - | `duf` |
| `curl` | - | `curlie` |
| `cat` | - | `bat -P` |
| `diff` | - | `batdiff` |
| `bathelp` | - | `bat --plain --language=help` |
| `top` | - | `btm -b` (bottom) |
| `icloud` | - | cd to iCloud Drive |
| `k` | - | `kubectl` |
| `root` | - | cd to git repo root |
| `update` | - | `brew update` |
| `upgrade` | - | `brew upgrade` |
| `cleanup` | - | `brew cleanup` |
| `install` | - | `brew install` |
| `doctor` | - | `brew doctor` (with easter egg) |
| `uud` / `ood` | - | update+upgrade+cleanup+doctor |
| `insult_cow` | - | `insult \| cowthink` |
| `excuse_cow` | - | `excuse \| cowthink` |
| `compliment_cow` | - | `compliment \| cowthink` |

### Git Aliases

| Alias | Nix | Chezmoi |
|---|---|---|
| `git st` | `status` | `status` |
| `git co` | `checkout` | `checkout` |
| `git br` | `branch` | `branch` |
| `git ci` | `commit` | `commit` |
| `git unstage` | `reset HEAD --` | `reset HEAD --` |
| `git last` | `log -1 HEAD` | `log -1 HEAD` |
| `git visual` | `!gitk` | - |
| `git lg` | pretty graph log | pretty graph log |

> Chezmoi now has 7 of 8 git aliases (all except `visual`).

---

## Git Configuration

### Core Settings

| Setting | Nix | Chezmoi |
|---|---|---|
| core.editor | nvim | nvim |
| core.pager | default | **delta** (side-by-side, line numbers, gruvbox) |
| core.autocrlf | input | input |
| help.autoCorrect | - | prompt |
| init.defaultBranch | main | main |
| push strategy | autoSetupRemote=true | push.default=current + autoSetupRemote=true |
| pull strategy | rebase=false | **ff=only** (stricter — refuses non-fast-forward) |
| diff.tool | vimdiff | delta + colorMoved |
| merge.tool | vimdiff | **custom nvim mergetool** (MergetoolStart) |
| merge.conflictstyle | default | **diff3** |
| interactive.diffFilter | - | delta --color-only |
| filter "lfs" | - | **full Git LFS setup** |
| diff "sopsdiffer" | - | sops --decrypt |
| URL rewrite | - | **HTTPS→SSH for github.com** |
| User identity | Hardcoded in nix config | `~/.gitconfig_local` (created at install) |
| Includes | - | `~/.gitconfig_themes`, `~/.gitconfig_local` |

### Delta Themes (Chezmoi Only)

| Theme | Style |
|---|---|
| fn-gruvbox | Gruvbox dark (**default**) |
| collared-trogon | Nord-based dark |
| coracias-caudatus | GitHub-based light |
| hoopoe | Light |
| tangara-chilensis | Vibrant Sunburst dark |
| villsau | OneHalfDark |
| woolly-mammoth | Detailed formatting dark |
| calochortus-lyallii | Nord dark |
| mantis-shrimp | Monokai Extended dark |
| mantis-shrimp-lite | Simplified Monokai |
| zebra-dark | Zebra-stripe dark |
| zebra-light | Zebra-stripe light |
| chameleon | Nord + blame formatting |

> Nix has **no** delta, **no** gitconfig_themes — uses plain git output.

---

## Neovim

> Both configs now use **AstroNvim v4** with lazy.nvim and native LSP + Mason. The chezmoi config was migrated from legacy vimscript+CoC in Feb 2026.

### Neovim Architecture

| Aspect | Nix | Chezmoi |
|---|---|---|
| Framework | AstroNvim v4 | AstroNvim v4 |
| Plugin manager | lazy.nvim | lazy.nvim |
| LSP approach | Native LSP + Mason | Native LSP + Mason (20 servers) |
| Config language | Lua | Lua |
| Config size | ~20 modular files | ~20 modular files (18 plugin specs) |
| Theme | Catppuccin | gruvbox-material |
| Leader key | (default) | Space |
| Config location | `~/.config/nvim/` (symlinked) | `~/.config/nvim/` (chezmoi-managed) |

### Key Differences

| Aspect | Nix | Chezmoi |
|---|---|---|
| Community packs | (unknown) | 17 language packs via AstroCommunity |
| AI | - | **avante.nvim** (Claude primary) + Copilot |
| Git | AstroNvim default | **neogit** (replacing vim-fugitive) |
| Navigation | AstroNvim default | **flash.nvim** (replacing easymotion) |
| UI | AstroNvim default | **noice.nvim** (replacing wilder.nvim) |
| Start screen | AstroNvim default | **alpha-nvim** (replacing vim-startify) |
| Formatting | (unknown) | conform.nvim |
| Linting | (unknown) | nvim-lint |
| Colorschemes | Catppuccin | gruvbox-material + multiple via AstroCommunity |

---

## tmux

### tmux Core Settings

| Setting | Nix | Chezmoi |
|---|---|---|
| Config size | ~30 lines | **560+ lines** |
| Framework | home-manager programs.tmux | **gpakosz/.tmux** |
| Terminal | screen-256color | 24-bit color |
| History limit | 10,000 | **100,000** |
| Key mode | vi | vi |
| Mouse | On | On |
| Base index | 1 | 1 |
| Renumber windows | Yes | Yes |
| Theme | None (default) | **Full gruvbox** (3 alternates: onedark, material, commented) |
| Status bar left | Default | Session name, uptime |
| Status bar right | Default | CPU/mem, battery, username, hostname, online, pomodoro, mode indicator |
| Separators | Default | Powerline-style |
| Pane border | Default | Top, with index + title |
| Copy to OS clipboard | No | **Yes** |
| Welcome message | No | Yes ("Welcome back $USER") |
| Split bindings | `\|` and `-` | Default (gpakosz) |
| Pane switching | Alt+Arrow | Default (gpakosz) |
| Config reload | prefix+r | prefix+r |
| Session prompt | No | Yes (prompt for name) |
| New pane retains path | No | Yes |
| Custom variables | None | tmux_cpu_mem, online status |

### tmux Plugins

| Plugin | Nix | Chezmoi | Purpose |
|---|---|---|---|
| tmux-yank | - | yes | System clipboard |
| tmux-sensible | - | yes | Sensible defaults |
| tmux-resurrect | - | yes | **Session save/restore** (panes, vim sessions) |
| tmux-menus | - | yes | F12 popup menus |
| tmux-suspend | - | yes | F1 suspend (nested tmux) |
| tmux-mode-indicator | - | yes | Visual prefix/copy/sync/empty indicator |
| tmux-fzf | - | yes | **Ctrl+Space** fzf for sessions/windows/panes |
| tmux-fuzzback | - | yes | Ctrl+_ fzf scrollback search |
| tmux-pomodoro-plus | - | yes | **Pomodoro timer** in status bar |
| tmux-fzf-url | - | yes | Open URLs from scrollback |
| **Total** | **0** | **10** | |

> Nix has **zero** tmux plugins. Chezmoi has a full plugin ecosystem.

### FZF Menu Entries (Chezmoi Only)

40+ entries accessible via Ctrl+Space:

| Category | Entries |
|---|---|
| Git (forgit) | add, reset, log, diff, checkout (file/branch/commit), branch delete, revert, tag, clean, stash, cherry-pick, rebase, fixup |
| Git tools | repo stats (onefetch), git ship (add→commit→pull→push) |
| GitHub | status, dashboard (gh-dash) |
| Containers | lazydocker, k9s |
| Navigation | broot (directory navigator) |
| Reference | navi (cheatsheets), batman (man pages) |
| Maintenance | autoupdate dotfiles |
| Sessions | personal dotfiles (smug) |
| Info | weather (wttr.sh), SF clock, India clock, IP address, speedtest |
| System | activity monitor (btm), disk free (dust), disk usage (duf) |
| Shell | color palette, zsh history stats, explain prompt, tmux bindings, zsh completions list, system info (fastfetch) |

---

## Other Config Files

| File | Nix | Chezmoi | Details |
|---|---|---|---|
| `~/.prettierrc` | None | Yes | bracketSameLine=true, proseWrap=always, trailingComma=all |
| `~/.golangci.yml` | None (package only) | Yes | timeout: 10s, allow-parallel-runners: true |
| `~/.urlview` | None | Yes | COMMAND xdg-open |
| `~/.gitconfig_themes` | None | Yes | 13 delta themes |
| `~/.config/nvim/` | Yes (AstroNvim) | Yes (AstroNvim) | Both now use AstroNvim v4 |
| `~/.config/fsh/` | None | Yes | 2 fast-syntax-highlighting themes |
| iTerm2 profile | None | Yes | Auto-installed gruvbox + wallpaper |
| `~/.p10k.zsh` | Yes (symlinked) | None | Powerlevel10k config |

---

## System Packages

### Languages & Runtimes

| Package | Nix | Chezmoi |
|---|---|---|
| go | yes | yes |
| nodejs | yes (nodejs_22) | yes (node) |
| python | yes (python3) | yes |
| rust | yes (rustup) | yes |
| typescript | - | yes |
| dart | yes | - |
| lua | yes | - |
| lua-language-server | yes | - |
| java | yes (jdk21) | yes (openjdk) |
| maven | yes | - |
| gradle | - | yes |
| clojure | yes | - |
| leiningen | yes | - |

### Go Development

| Package | Nix | Chezmoi |
|---|---|---|
| gopls | yes | yes |
| golangci-lint | yes | yes |
| air | yes | - |
| sqlc | yes | - |
| gotests | - | yes |
| gops | - | yes |
| impl | - | yes (go install) |
| keyify | - | yes (go install) |
| iferr | - | yes (go install) |
| fillstruct | - | yes (go install) |
| gocovsh | - | yes (go install) |
| mockery | - | yes |
| bufls | - | yes (go install) |
| jsonnet-language-server | - | yes (go install) |

### Kubernetes

| Package | Nix | Chezmoi |
|---|---|---|
| kubectl | yes | yes |
| helm | yes | yes |
| helmfile | - | yes |
| kustomize | yes | yes |
| kubecolor | yes | yes |
| kubectl-ktop | yes | - (not in Homebrew; use `krew`) |
| kubectl-tree | yes | - (not in Homebrew; use `krew`) |
| kubectx | yes | yes |
| kubecm | yes | yes |
| kubefwd | yes | yes |
| kubetail | yes | yes |
| stern | yes | yes |
| cilium-cli | yes | yes |
| krew | - | yes |
| k9s | - | yes |
| kubebuilder | - | yes |
| kind | - | yes |
| tilt / ctlptl | - | yes |
| buf / grpcurl | - | yes |

### CLI Tools

| Package | Nix | Chezmoi | Category |
|---|---|---|---|
| eza | yes | yes | File listing |
| ripgrep | yes | yes | Search |
| fzf | yes | yes | Fuzzy finder |
| tree | yes | - | Directory tree |
| fd | - | yes | File finder |
| gdu | yes | - | Disk usage |
| dust | - | yes | Disk usage (Rust) |
| ncdu | - | yes | Disk usage (ncurses) |
| duf | - | yes | Disk free |
| bat | - | yes | Cat replacement |
| bat-extras | - | yes | Bat utilities (batdiff, batman, etc.) |
| git-delta | - | yes | Git pager |
| bottom | yes | yes | System monitor |
| zoxide | yes | yes | Directory jumper |
| tmux | yes | yes | Terminal multiplexer |
| tmux-mem-cpu-load | - | yes | tmux status info |
| lazygit | yes | - | Git TUI |
| lazydocker | yes | yes | Docker TUI |
| gh | yes | yes | GitHub CLI |
| copilot-cli | - | yes | GitHub Copilot CLI |
| rclone | yes | - | Cloud storage sync |
| socat | yes | yes | Socket relay |
| inetutils | yes | - | Network utilities |
| neovim | yes | yes | Editor |
| thefuck | - | yes | Command corrector |
| curlie | - | yes | Curl replacement |
| cowsay | - | yes | ASCII art |
| fortune | - | yes | Random quotes |
| figlet | - | yes | ASCII banners |
| vivid | - | yes | LS_COLORS generator |
| hyperfine | - | yes | Benchmarking |
| sd | - | yes | Sed replacement |
| broot | - | yes | Directory navigator |
| navi | - | yes | Cheatsheets |
| tealdeer | - | yes | tldr pages |
| onefetch | - | yes | Git repo info |
| fastfetch | - | yes | System info |
| procs | - | yes | Process viewer |
| mosh | - | yes | Mobile shell |
| watch | - | yes | Command repeater |
| smug | - | yes | tmux session manager |
| gping | - | yes | Ping with graph |
| tty-clock | - | yes | Terminal clock |
| speedtest-cli | - | yes | Internet speed test |
| pstree | - | yes | Process tree |
| fpp | - | yes | Facebook PathPicker |
| chafa | - | yes | Image viewer |
| exiftool | - | yes | Media metadata |
| pdftohtml | - | yes | PDF converter |
| lesspipe | - | yes | Less preprocessor |
| jq | - | yes | JSON processor |
| yq | - | yes | YAML processor |
| jqp | - | yes | Interactive jq |
| doge | - | yes | DNS client |
| urlview | - | yes | URL extractor |
| vcsh | - | yes | Git-based config manager |
| subversion | - | yes | SVN |
| ctop | - | yes | Container monitor |
| oh-my-posh | yes | - | Prompt theme engine |
| lefthook | yes | - | Git hooks manager |
| act | yes | - | Run GitHub Actions locally |
| qmk | yes | - | Keyboard firmware |
| deck | yes | - | Kong deck |
| glab | yes | yes | GitLab CLI |
| asdf | - | yes | Version manager |
| spr | - | yes | Stacked PRs |

### Linters & Formatters

| Package | Nix | Chezmoi |
|---|---|---|
| stylua | yes | - |
| luacheck | yes | - |
| yamlfmt | yes | - |
| tree-sitter | yes | yes |
| shellcheck | - | yes |
| markdownlint-cli | - | yes |
| markdownlint-cli2 | - | yes |
| yamllint | - | yes |
| languagetool | - | yes |
| pylint | - | yes |
| eslint | - | yes |
| cppcheck | - | yes |
| jsonlint | - | yes |
| shfmt | - | yes |
| rustfmt | - | yes |
| vint | - | yes |
| swiftlint | yes | yes |
| vale | - | yes |
| autopep8 | - | yes |
| golangci-lint | yes | yes |

### Infrastructure / DevOps

| Package | Nix | Chezmoi |
|---|---|---|
| terraform | - | yes |
| terragrunt | - | yes |
| tflint | - | yes |
| circleci | - | yes |
| graphviz | - | yes |
| tilt / ctlptl | - | yes |
| go-jsonnet | - | yes |
| jsonnet-bundler | - | yes |
| tanka | - | yes |
| act | yes | - |
| deck | yes | - |

### Editors & GUI Apps

| App | Nix | Chezmoi |
|---|---|---|
| neovim | yes | yes |
| vscode | yes | yes |
| zed-editor | yes | - |
| google-chrome | yes | yes |
| alacritty | yes | - |
| iterm2 | - | yes |
| ghostty | - | yes |
| obsidian | yes | - |
| notion | - | yes |
| slack | - | yes |
| discord | - | yes |
| zoom | - | yes |
| figma | - | yes |
| chatgpt | - | yes |
| github (desktop) | - | yes |
| docker (desktop) | - | yes |
| orbstack | - | yes |
| google-drive | - | yes |
| backblaze | - | yes |
| stats | - | yes |
| twingate | - | yes |
| adobe-acrobat-reader | - | yes |

### macOS Specific

| Item | Nix | Chezmoi |
|---|---|---|
| **Cask: arc** | yes | - |
| **Cask: contexts** | yes | - |
| **Cask: karabiner-elements** | yes | - |
| **Cask: viber** | yes | - |
| **Cask: zalo** | yes | - |
| **Cask: setapp** | yes | - |
| **Cask: the-unarchiver** | yes | - |
| **Cask: swiftdefaultappsprefpane** | - | yes |
| **MAS: Dashlane** | yes | - |
| **MAS: Magnet** | yes | - |
| **MAS: reMarkable** | yes | - |
| **MAS: Tailscale** | yes | - |
| **System: mactop** | yes | - |
| **System: swiftlint** | yes | yes (cross-platform formula) |
| **System: mas** | yes | - |
| **Brew: glab** | yes | yes (cross-platform formula) |
| **GNU coreutils** | - | yes (coreutils, findutils, gnu-sed, grep, gawk, bash, wget) |
| **macOS utilities** | - | duti, terminal-notifier, reattach-to-user-namespace |

### Package Counts

| Category | Nix | Chezmoi |
|---|---|---|
| Core CLI packages | ~89 | **~164** |
| GUI casks | 9 + 4 MAS apps | **34** |
| Fonts | 1 family (JetBrains Mono) | **9 Nerd Font families** |
| Go tools (go install) | 0 | **7** |
| npm globals | 2 (mcp-chrome-bridge, yarn) | **5** (turbo, bash-language-server, dockerfile-language-server, graphql-language-service-cli, husky) |
| Python packages | 0 | **6** (pre-commit, pynvim, libtmux, tiktoken, setuptools, pip) |
| GitHub extensions | 0 | **2** (gh-dash, gh-copilot) |
| Brew taps | 0 | **7** |
| Linters/formatters | 4 | **11+** |
| Kubernetes tools | **12** | **15** |

---

## What You Lose Switching to Chezmoi

1. **Reproducibility** — Nix flake.lock pins exact package versions; Homebrew versions float
2. ~~**All 8 git aliases**~~ — **Resolved**: 7 of 8 added (`visual` skipped)
3. ~~**`vim` → `nvim` alias**~~ — **Resolved**: added to dot_aliases
4. ~~**`init.defaultBranch = main`**~~ — **Resolved**: added to gitconfig
5. ~~**`core.autocrlf = input`**~~ — **Resolved**: added to gitconfig
6. ~~**AstroNvim**~~ — **Resolved**: chezmoi now uses AstroNvim v4 (migrated Feb 2026)
7. **Powerlevel10k** prompt (replaced by yazpt)
8. **Emacs keybindings** in shell (replaced by vi mode)
9. **Oh-My-Zsh plugins** — sudo, pass, helm, docker, rust, command-not-found, golang, kubectl, kubectx
10. ~~**Kubernetes tools**~~ — **Mostly resolved**: only kubectl-ktop and kubectl-tree remain (not in Homebrew; install via krew)
11. **zed-editor**
12. **Declarative configuration** — everything defined in nix expressions
13. **Nix-managed OpenSSL paths** — automatic, correct OpenSSL configuration
14. **GPG/SSH agent** config in shell
15. **Mac App Store apps** — Dashlane, Magnet, reMarkable, Tailscale
16. **lazygit**, rclone, oh-my-posh, lefthook, act
17. **Languages** — dart, lua, clojure, leiningen
18. **alacritty** terminal (replaced by iterm2/ghostty)
19. **obsidian** (replaced by notion)
20. ~~**Claude profile switching**~~ — deliberately skipped

---

## What You Gain Switching to Chezmoi

1. **Delta** — rich side-by-side git diffs with 13 themes
2. **Full tmux environment** — 10 plugins, 40+ FZF menu entries, pomodoro, session restore
3. **Modern coreutils** — bat, dust, duf, curlie, fd, vivid, procs, sd, broot, hyperfine
4. **AstroNvim v4** with gruvbox-material, 17 AstroCommunity language packs, 18 plugin specs
5. **avante.nvim** — Claude-powered AI assistant in editor + Copilot
6. **neogit** + flash.nvim + noice.nvim + alpha-nvim (modern replacements)
7. **conform.nvim** + nvim-lint for formatting/linting
8. **Desktop notifications** for long-running commands (zsh-notify)
9. **forgit** — interactive git operations via fzf
10. **zsh-autosuggestions** — fish-like command suggestions
11. **zsh-you-should-use** — alias reminder system
12. **direnv** — per-directory environment switching
13. **Auto-update system** — weekly updates for brew, zinit, nvim, npm, pip, tldr, vale
14. **iTerm2 deep integration** — auto-profile install, wallpaper, fireworks animation
15. **Fun features** — 2100+ insults/excuses/compliments, cowsay, fortune, figlet, ASCII welcome art
16. **10+ linters** out of the box (shellcheck, eslint, pylint, vale, yamllint, etc.)
17. **Infrastructure tools** — terraform, terragrunt, tflint, tilt, circleci
18. **34 GUI casks** (slack, discord, figma, notion, orbstack, ghostty, chatgpt, etc.)
19. **9 Nerd Font families** (vs 1)
20. **GNU coreutils** on macOS (coreutils, findutils, gnu-sed, grep, gawk)
21. **GitHub extensions** — gh-dash (dashboard TUI), gh-copilot
22. **Global configs** — prettierrc, golangci.yml, urlview
23. **Go dev tools** — 7 additional go install packages (impl, gotests, fillstruct, etc.)
24. **Tmux FZF command palette** — 40+ quick-access tools (weather, clocks, speedtest, k9s, lazydocker, etc.)
25. **vim-mergetool** with custom nvim integration and diff3 conflict style
26. **Git LFS** support
27. **HTTPS → SSH URL rewriting** for GitHub

---

## Bottom Line

| | Nix | Chezmoi |
|---|---|---|
| **Philosophy** | Declares what should exist | Scripts build what you want |
| **Strength** | Reproducibility, declarative config | Feature richness, polish, deep integrations, k8s parity |
| **Weakness** | Fewer tools, no delta/bat/tmux plugins | No version pinning, complex |
| **Best for** | Deterministic environments | Batteries-included daily-driver dev environment |
| **Editor style** | AstroNvim (Catppuccin) | AstroNvim (gruvbox-material, avante.nvim, 17 language packs) |
| **Shell style** | Clean, minimal, emacs-mode | Feature-rich, vi-mode, fun/entertainment |
| **Maintenance** | Manual (`nix flake update`) | Automated (weekly autoupdate) |
