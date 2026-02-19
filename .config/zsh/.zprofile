# ~/.config/zsh/.zprofile
# Purpose:
# - Login shell configuration
# - PATH and environment setup
# - Runs once per login

# Add user binaries
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)

# Ensure locale is sane
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Start graphical session helpers if needed
# Example:
# [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]] && exec startx

