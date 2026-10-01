# SketchyBar

The macOS menu-bar replacement used with [AeroSpace](../aerospace/README.md). It's a floating, blurred, rounded bar at the top of the screen.

Based on [hbthen3rd's dotfiles](https://github.com/hbthen3rd/dotfiles/tree/master/.config/sketchybar) (see `reference.md`).

## Layout

| Path | What it does |
| --- | --- |
| `sketchybarrc` | Entry point: bar appearance, defaults, item order |
| `colors.sh`, `icons.sh` | Palette and SF Symbols / Nerd Font icons |
| `items/` | One file per bar item (spaces, front app, battery, CPU, volume, weather, calendar…) |
| `plugins/` | Scripts the items call on events (`aerospace.sh`, `battery.sh`, `clock.sh`, …) |
| `aerospace_*.sh` | Workspace pills driven by AeroSpace |
| `helper/` | Small C program that streams CPU usage to the bar |
| `restart.sh` | Restarts SketchyBar with this config |

## Install

```sh
brew tap FelixKratz/formulae && brew install sketchybar
brew install --cask font-sf-pro sf-symbols
cd ~/.config/sketchybar/helper && make
brew services start sketchybar
```

AeroSpace must be running: the bar reads workspaces with `aerospace list-workspaces` and listens for `aerospace_workspace_change`.

## Variants

`../sketchybarAlt` ("ultra rich" colours) and `../sketchybar-2` are alternative themes with the same structure. To try one, run `sketchybar --config ~/.config/sketchybarAlt/sketchybarrc`.
