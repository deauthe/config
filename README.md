# dotfiles

My macOS `~/.config`. Clone it to `~/.config` and every tool finds its config in the default place.

```sh
git clone https://github.com/deauthe/config ~/.config
```

## What's here

| Folder | Tool | Notes |
| --- | --- | --- |
| [`ghostty/`](ghostty/README.md) | Ghostty + **tmux** | tmux lives inside `ghostty/tmux/` and Ghostty launches straight into it. Includes theme, cursor shader, status bar and notifications |
| [`herdr/`](herdr/README.md) | herdr | AI-agent workspace manager; only `config.toml` is tracked |
| [`aerospace/`](aerospace/README.md) | AeroSpace | Tiling window manager + workspace auto-placement |
| [`sketchybar/`](sketchybar/README.md) | SketchyBar | Menu bar wired to AeroSpace workspaces |
| `sketchybarAlt/`, `sketchybar-2/` | SketchyBar | Alternative themes with the same layout |
| `nvim/` | Neovim | LazyVim-based config |
| `wezterm/` | WezTerm | Older terminal config, kept for reference |
| `mise/` | mise | Tool versions (Go, Node, pnpm, task, golangci-lint) |
| `git/ignore` | git | Global gitignore |
| `spotify-player/` | spotify-player | Terminal Spotify client (keymap + theme) |
| `gh/config.yml` | GitHub CLI | Aliases and preferences only |
| `graphite/aliases` | Graphite CLI | Command aliases |

## How the terminal stack fits together

```
AeroSpace (tiling) + SketchyBar (menu bar)
└── Ghostty (glass, theme, ⌘ keys)
    └── tmux (status bar, panes, sessions)   ← ghostty/tmux/
        └── zsh (vi mode, long-command notifications)
            └── nvim, herdr, …
```

## Not tracked

Anything holding credentials or machine state is git-ignored: `gh/hosts.yml`, `github-copilot/`, `graphite/user_config`, `gcloud`, `solana/`, Raycast, herdr sessions and logs. `~/.zshrc` lives outside this repo; the parts that the Ghostty setup needs are in [`ghostty/README.md`](ghostty/README.md#shell-pieces-in-zshrc-not-in-this-repo).
