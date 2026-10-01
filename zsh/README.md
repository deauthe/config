# zsh

`terminal.zsh` turns plain zsh + oh-my-zsh into a Warp-like shell. Load it from `~/.zshrc` right after oh-my-zsh:

```zsh
plugins=(git aliases fzf-tab)
source $ZSH/oh-my-zsh.sh
source ~/.config/zsh/terminal.zsh
```

## Install

```sh
brew install zsh-vi-mode fzf fd atuin bat eza zsh-autosuggestions zsh-syntax-highlighting
git clone --depth 1 https://github.com/Aloxaf/fzf-tab ~/.oh-my-zsh/custom/plugins/fzf-tab
atuin import auto
```

## What you get

| Feature | Keys | Tool |
| --- | --- | --- |
| Grey ghost-text suggestions | `→` or `Ctrl+E` accepts, `⌥→` accepts one word | zsh-autosuggestions |
| Smart history: fuzzy, per-repo, shows exit code + duration | `Ctrl+R` (`Ctrl+R` again cycles global / host / session / directory) | atuin |
| Fuzzy Tab completion with previews, in a tmux popup | `Tab`, `<` / `>` switch groups | fzf-tab |
| Fuzzy file picker / folder jump | `Ctrl+T` / `⌥C` | fzf + fd |
| Muted syntax highlighting (unknown commands in red) | — | zsh-syntax-highlighting |
| Vim editing on the command line | `Esc` or `jk` for normal mode | zsh-vi-mode |
| Word navigation | `⌥←` / `⌥→`, `⌥⌫` | zsh |
| Open the command in `$EDITOR` | `Ctrl+X Ctrl+E` | zsh |
| Desktop notification when a command takes > 10s | — | [`ghostty/tmux/scripts/notify.sh`](../ghostty/README.md#notifications) |

## Load order

The order inside `terminal.zsh` matters:

1. **zsh-vi-mode** first. It resets keymaps, so everything else binds after it.
2. **fzf**, then re-bind `Tab` to `fzf-tab-complete`, because `fzf --zsh` claims `Tab` for itself.
3. **atuin**, which takes `Ctrl+R`. fzf's `Ctrl+R` is disabled via `FZF_CTRL_R_COMMAND=`.
4. **zsh-autosuggestions**.
5. **zsh-syntax-highlighting** last, so it wraps every widget defined before it.

`zoxide init` must stay at the very end of `~/.zshrc`, or zoxide prints a configuration warning in every shell.

## History privacy

atuin is local-only (`auto_sync = false`, no account). `history_filter` and `secrets_filter` in [`../atuin/config.toml`](../atuin/config.toml) keep commands containing passwords, tokens or API keys out of the database.
