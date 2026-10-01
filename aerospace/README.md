# AeroSpace

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is an i3-style tiling window manager for macOS. Config: `aerospace.toml`.

## Keys

| Keys | Action |
| --- | --- |
| `⌥h/j/k/l` | Focus left / down / up / right (across monitors) |
| `⌥⇧h/j/k/l` | Move window |
| `⌥⇧-` / `⌥⇧=` | Shrink / grow |
| `⌥1`–`⌥0`, `⌥t` | Go to workspace 1–10, `t` |
| `⌥⇧1`–`⌥⇧0`, `⌥⇧t` | Send window to workspace and follow it |
| `⌥/` | Tiles layout (toggle horizontal/vertical) |
| `⌥,` | Accordion layout |
| `⌥⇧f` | Fullscreen |
| `⌥Tab` | Previous workspace |
| `⌥⇧Tab` | Move workspace to next monitor |
| `⌥⇧;` | Service mode (`esc` reload, `r` reset layout, `f` float/tile, `⌫` close others) |

## Auto-placement

| Workspace | Apps |
| --- | --- |
| `1` | VS Code, ToDesktop apps (Cursor etc.) |
| `5` | Arc, Dia, Vivaldi, ClickUp |
| `8` | Slack, Telegram, Discord, KakaoTalk |
| `9` | Obsidian |
| `t` | WezTerm, Warp, Spotify |

System Settings, Weather and Bazecor always float.

## Integrations

- **SketchyBar:** `exec-on-workspace-change` fires `aerospace_workspace_change` so the bar's workspace pills update (see [`../sketchybar`](../sketchybar/README.md)).
- **Mouse follows focus:** `on-focus-changed` moves the cursor to the focused window.
- **Notch gap:** `gaps.outer.top` is `-25` on the built-in display so windows sit under the floating bar.
