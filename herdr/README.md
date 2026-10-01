# herdr

[herdr](https://herdr.dev) is a terminal workspace manager for AI coding agents. Only `config.toml` is tracked here. Sessions, snapshots, logs, sockets and installed plugins are runtime state and are git-ignored.

## What's configured

| Setting | Value | Why |
| --- | --- | --- |
| `theme.name` | `vesper` | Matches the low-colour Ghostty theme |
| `ui.toast.delivery` | `system` | Sends notifications straight to macOS. `terminal` hands them to Ghostty, which hides banners from its focused window, so you only heard the sound |
| `ui.copy_on_select` | `true` | Same behaviour as Ghostty |
| `ui.show_agent_labels_on_pane_borders` | `true` | Shows which agent runs in each pane |
| `experimental.switch_ascii_input_source_in_prefix` | `true` | Switches to an ASCII input source while the prefix is active |
| `Ctrl+h/j/k/l` | `vim-herdr-navigation.*` | Moves between herdr panes and Neovim splits with the same keys |

## Plugins

Plugins aren't tracked; install them yourself:

- [`ragamo/herdr-flock`](https://github.com/ragamo/herdr-flock): your agents as pixel-art sheep.
- `vim-herdr-navigation`: a local plugin. Without it, the `Ctrl+h/j/k/l` bindings in `config.toml` do nothing.

## Relation to Ghostty / tmux

herdr runs inside Ghostty (see [`../ghostty`](../ghostty/README.md)). With `delivery = "system"` its notifications go straight to macOS, without passing through Ghostty or tmux.

Apply changes with `herdr server reload-config`.
