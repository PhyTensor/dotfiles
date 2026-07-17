# ~/.zshenv
# Purpose:
# - Define Zsh configuration location
# - Set environment variables required everywhere
# - NO aliases, NO prompts, NO plugins

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Tell Zsh where its config lives
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# History file location
export HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"

# Sensible defaults
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

. "$HOME/.aftman/env"
