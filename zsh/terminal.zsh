unsetopt BEEP

BREW="${HOMEBREW_PREFIX:-/opt/homebrew}"

# ─── vi mode ───────────────────────────────────────────
ZVM_INIT_MODE=sourcing
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
zvm_after_init() {
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey -M viins '^A' beginning-of-line
  bindkey -M viins '^E' end-of-line
  bindkey -M viins '^W' backward-kill-word
  bindkey -M viins '^P' up-line-or-history
  bindkey -M viins '^N' down-line-or-history
  bindkey -M viins '^X^E' edit-command-line
  bindkey -M viins '^[[1;3D' backward-word
  bindkey -M viins '^[[1;3C' forward-word
  bindkey -M viins '^[b' backward-word
  bindkey -M viins '^[f' forward-word
  bindkey -M viins '^[^?' backward-kill-word
}
source "$BREW/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# ─── fzf: Ctrl+T files, Alt+C dirs (Ctrl+R belongs to atuin) ─
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --height=45% --layout=reverse --border=rounded --info=inline-right
  --prompt='❯ ' --pointer='▌' --marker='+' --separator='─' --scrollbar='│'
  --color=bg+:#1b1e26,bg:-1,fg:#8a909c,fg+:#e8eaef,hl:#a2b2d6,hl+:#a2b2d6
  --color=border:#4b505d,prompt:#a2b2d6,pointer:#a2b2d6,marker:#cfb98f,info:#5c6270,spinner:#5c6270,header:#5c6270"
export FZF_CTRL_T_OPTS="--preview 'bat --style=plain --color=always --line-range :200 {} 2>/dev/null'"
export FZF_ALT_C_OPTS="--preview 'eza -1 --icons=always --color=always {}'"
export FZF_TMUX_OPTS='-p 80%,70%'
export FZF_CTRL_R_COMMAND=
source <(fzf --zsh)
(( $+widgets[fzf-tab-complete] )) && bindkey -M viins '^I' fzf-tab-complete

# ─── fzf-tab: fuzzy Tab completion in a tmux popup ─────
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' popup-min-size 80 12
[[ -n $TMUX ]] && zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:(cd|z|__zoxide_z):*' fzf-preview 'eza -1 --icons=always --color=always $realpath'
zstyle ':fzf-tab:complete:(cat|bat|nvim|vi|vim|less):*' fzf-preview 'bat --style=plain --color=always --line-range :200 $realpath 2>/dev/null || eza -1 --icons=always --color=always $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log --oneline --graph --color=always -20 $word'

# ─── atuin: smart history on Ctrl+R ────────────────────
eval "$(atuin init zsh --disable-up-arrow)"

# ─── autosuggestions: ghost text, → or Ctrl+E to accept ─
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4b505d'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=80
ZSH_AUTOSUGGEST_USE_ASYNC=1
source "$BREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ─── long-command notifications ────────────────────────
zmodload zsh/datetime
autoload -Uz add-zsh-hook
NOTIFY_MIN_SECONDS=10
NOTIFY_IGNORE=(vi vim nvim less more man ssh tmux lazygit htop btop top watch claude fzf bat git-log atuin)
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

# ─── syntax highlighting (must load last) ──────────────
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#c8ccd4'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#c4848c'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a2b2d6'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a2b2d6'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a2b2d6'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a2b2d6'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a2b2d6,italic'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#a898c2'
ZSH_HIGHLIGHT_STYLES[path]='fg=#c8ccd4,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#94b39d'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#94b39d'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#94b39d'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#8a909c'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#8a909c'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#4b505d,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#5c6270'
source "$BREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
