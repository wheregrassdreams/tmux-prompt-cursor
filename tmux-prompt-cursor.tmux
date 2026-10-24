#!/usr/bin/env bash
# TPM entry point for the optional Zsh prompt cursor adapter.
set -eu

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux set-option -g @tmux-prompt-cursor-root "$PLUGIN_DIR"
tmux source-file "$PLUGIN_DIR/tmux-prompt-cursor.conf"
