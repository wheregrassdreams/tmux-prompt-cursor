# tmux-prompt-cursor

An optional TPM plugin that lets a click on the active Zsh command row move
the ZLE insertion point. Ordinary pane clicks continue through tmux's normal
mouse handling. The plugin has no compiled binary and does not depend on
tmux-config.

## Install with TPM

Add the plugin to `.tmux.conf`:

```tmux
set -g @plugin 'wheregrassdreams/tmux-prompt-cursor'
```

Then install with `prefix + I` and reload tmux. The plugin installs its
MouseDown1Pane handler automatically. To enable the Zsh side, source the
adapter from `.zshrc` after the user's ZLE/keymap setup:

```zsh
source "$HOME/.tmux/plugins/tmux-prompt-cursor/shell/tmux-prompt-cursor.zsh"
```

The adapter reserves `Ctrl-]` in Zsh's `emacs` and `viins` keymaps. The plugin
entry point sets `@tmux-prompt-cursor-root`; users do not need to source its
internal tmux file or configure paths in tmux.

## Current limits

The cursor mapping supports single-line, unwrapped ASCII command input. It
does not map wrapped or multiline input, Unicode display widths, or right
prompts. If the Zsh adapter is not sourced, clicks use ordinary tmux mouse
behavior.

## Release

This is a shell-only TPM plugin. A pushed `v*` tag creates a GitHub Release;
TPM installs the plugin files directly from the repository and does not need
a build step.
