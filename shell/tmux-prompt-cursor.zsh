# Optional Zsh adapter. Source after the user's ZLE/keymap setup.

_tmux_prompt_cursor_move() {
  emulate -L zsh
  local -i click_x click_y cursor_x cursor_y start_x target
  local pane=${TMUX_PANE:-}
  [[ -n $pane ]] || return 0

  click_x=$(tmux show-option -p -t "$pane" -v @tmux-prompt-cursor-x 2>/dev/null) || return 0
  click_y=$(tmux show-option -p -t "$pane" -v @tmux-prompt-cursor-y 2>/dev/null) || return 0
  cursor_x=$(tmux display-message -p -t "$pane" '#{cursor_x}') || return 0
  cursor_y=$(tmux display-message -p -t "$pane" '#{cursor_y}') || return 0

  # This adapter maps unwrapped ASCII command text. Refuse clicks on other
  # prompt rows and leave the shell buffer untouched.
  (( click_y == cursor_y )) || return 0
  start_x=$((cursor_x - ${#LBUFFER}))
  target=$((click_x - start_x))
  (( target < 0 )) && target=0
  (( target > ${#BUFFER} )) && target=${#BUFFER}
  CURSOR=$target
  # Re-evaluate dynamic and multi-line prompts before redrawing the buffer.
  # A plain redisplay can leave prompt cells stale after the cursor jumps.
  zle reset-prompt
  zle redisplay
}

_tmux_prompt_cursor_init() {
  [[ -n ${TMUX_PANE:-} ]] || return 0
  tmux set-option -p -t "$TMUX_PANE" @tmux-prompt-cursor-active 1 2>/dev/null || true
}

_tmux_prompt_cursor_finish() {
  [[ -n ${TMUX_PANE:-} ]] || return 0
  tmux set-option -pu -t "$TMUX_PANE" @tmux-prompt-cursor-active 2>/dev/null || true
}

autoload -Uz add-zle-hook-widget
zle -N _tmux_prompt_cursor_move
zle -N _tmux_prompt_cursor_init
zle -N _tmux_prompt_cursor_finish
add-zle-hook-widget line-init _tmux_prompt_cursor_init
add-zle-hook-widget line-finish _tmux_prompt_cursor_finish
bindkey -M emacs '^]' _tmux_prompt_cursor_move
bindkey -M viins '^]' _tmux_prompt_cursor_move
