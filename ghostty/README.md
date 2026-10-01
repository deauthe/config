# Ghostty + tmux

Ghostty is the terminal. **tmux lives inside this folder** and Ghostty starts straight into it, so the two are configured as one unit:

```
Ghostty ──(command = tmux/launch.sh)──▶ tmux -f ~/.config/ghostty/tmux/tmux.conf ──▶ zsh
   │                                        │
   ├─ glass look, theme, cursor shader      ├─ status bar (top), panes, windows, sessions
   └─ ⌘ keys → private escape codes ───────▶└─ user-keys bound to tmux actions
```

There is no `~/.tmux.conf`; tmux is always launched with `-f` pointing here.

## Layout

| Path | What it does |
| --- | --- |
| `config.ghostty` | Ghostty config: opacity + blur, font, cursor, quick terminal, ⌘ keybinds |
| `themes/frost` | Low-colour dark theme (near-black, soft greys, one periwinkle accent) |
| `shaders/cursor_trail.glsl` | Subtle trail when the cursor jumps ≥ 4 cells |
| `tmux/tmux.conf` | tmux config: prefix, bindings, status bar, notifications hook |
| `tmux/launch.sh` | What Ghostty runs: attaches to `main`, or starts a new session if `main` is already open elsewhere |
| `tmux/scripts/*.sh` | Status bar segments (`cpu`, `mem`, `battery`, `git`), animated `split`, `notify` |

## Install

```sh
brew install --cask ghostty
brew install tmux zsh-vi-mode terminal-notifier
git clone <this repo> ~/.config
```

Open Ghostty. `⌘R` reloads Ghostty, `Ctrl+S r` reloads tmux.

## Keys

The tmux prefix is **`Ctrl+S`** (`Ctrl+Space` is taken by macOS input-source switching). `Ctrl+S ?` lists every binding with a description.

| Ghostty | tmux equivalent | Action |
| --- | --- | --- |
| `⌘T` | `Ctrl+S c` | New window |
| `⌘D` / `⌘⇧D` | `Ctrl+S \|` / `Ctrl+S -` | Split side by side / top-bottom (animated) |
| `⌘W` | `Ctrl+S x` | Close pane |
| `⌘Z` | `Ctrl+S z` | Zoom pane |
| `⌘1`–`⌘9`, `⌘←` / `⌘→` | `Ctrl+S 1`–`9`, `n` / `p` | Switch window |
| `⌘S` | `Ctrl+S s` | Session / window picker |
| `⌘F` | — | Search the pane's scrollback |
| `⌘K` | `Ctrl+S k` | Clear screen + scrollback |
| `⌘⌃F` | — | Fullscreen |
| `` ⌘` `` | — | Quick terminal (global) |
| — | `Ctrl+S H/J/K/L` | Resize pane (repeatable) |
| — | `Ctrl+S g` / `t` | Lazygit popup / floating shell |

### How ⌘ keys reach tmux

Ghostty sends a private escape sequence for each ⌘ shortcut (`keybind = super+t=text:\x1b[9000~`), and `tmux.conf` maps each sequence to an action with `user-keys`:

```tmux
set -s user-keys[0] "\e[9000~"
bind -n User0 new-window -c "#{pane_current_path}"
```

These don't depend on the prefix, so changing the prefix never breaks the ⌘ keys. To add one, use the next free number (currently `9019`) in both files.

## Status bar

The bar sits at the top with a transparent background, so Ghostty's blur shows through. Segments drop out as the window narrows:

| Width | Shown |
| --- | --- |
| ≥ 150 cols | git · CPU · memory · battery · date · time |
| ≥ 120 | git · battery · date · time |
| ≥ 90 | git · time |
| < 90 | time |

The left side shows a **PREFIX** badge while the prefix is held, a **COPY** badge in copy mode, the session name, zoom/sync flags and the current folder.

## Notifications

`tmux/scripts/notify.sh` sends desktop notifications for:

- **Long commands:** anything over 10s (zsh hook below), even if you're watching the pane.
- **Bells:** in any tmux window you're not looking at (`alert-bell` hook).

Ghostty hides notifications from the window that has focus, and it can't see tmux panes. So when the target Ghostty window is focused the script uses `terminal-notifier` (falling back to `osascript`); otherwise it writes an OSC 777 sequence to the tmux client's tty. Debug log: `~/.cache/ghostty-notify.log`.

## Shell pieces (in `~/.zshrc`, not in this repo)

<details>
<summary>vi mode + long-command notifications</summary>

```zsh
unsetopt BEEP

ZVM_INIT_MODE=sourcing
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
zvm_after_init() {
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey -M viins '^R' history-incremental-search-backward
  bindkey -M viins '^A' beginning-of-line
  bindkey -M viins '^E' end-of-line
  bindkey -M viins '^W' backward-kill-word
  bindkey -M viins '^P' up-line-or-history
  bindkey -M viins '^N' down-line-or-history
  bindkey -M viins '^X^E' edit-command-line
}
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

zmodload zsh/datetime
autoload -Uz add-zsh-hook
NOTIFY_MIN_SECONDS=10
NOTIFY_IGNORE=(vi vim nvim less more man ssh tmux lazygit htop btop top watch claude fzf bat git-log)
_notify_preexec() { _notify_cmd=$1; _notify_start=$EPOCHREALTIME }
_notify_precmd() {
  local code=$?
  [[ -z $_notify_start ]] && return
  local elapsed=$(( EPOCHREALTIME - _notify_start ))
  unset _notify_start
  (( elapsed < NOTIFY_MIN_SECONDS )) && return
  local first=${${(z)_notify_cmd}[1]}
  (( ${NOTIFY_IGNORE[(Ie)$first]} )) && return
  local secs=${elapsed%.*} took
  (( secs >= 60 )) && took="$(( secs / 60 ))m $(( secs % 60 ))s" || took="${secs}s"
  local title
  (( code == 0 )) && title="✓ Done in $took" || title="✗ Failed ($code) after $took"
  ~/.config/ghostty/tmux/scripts/notify.sh "$title" "$_notify_cmd" &!
}
add-zsh-hook preexec _notify_preexec
add-zsh-hook precmd _notify_precmd
```

</details>

## Gotchas

- Don't use `%hidden` variables inside tmux style options. tmux rejects them with `bad colour`, so the config uses literal hex values.
- Nerd Font icons in `tmux.conf` are supplementary-plane glyphs (`U+F0000`+). Some editors and heredocs silently strip the older private-use range.
- macOS reserves `Ctrl+Space` and `Ctrl+arrows`, which is why the prefix is `Ctrl+S` and resizing uses `H/J/K/L`.
