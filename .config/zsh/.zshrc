# ~/.config/zsh/.zshrc
# Purpose:
# - Interactive shell configuration
# - Aliases, keybindings, prompt, completion
# - Should be fast and readable

# --------------------------------------------------
# Safety checks
# --------------------------------------------------

# Only run in interactive shells
[[ -o interactive ]] || return

# --------------------------------------------------
# History configuration
# --------------------------------------------------

# Create history directory if missing
mkdir -p "${HISTFILE:h}"

# History behavior
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY          # Do not overwrite history
setopt SHARE_HISTORY           # Share history across shells
setopt HIST_IGNORE_DUPS        # Ignore duplicate commands
setopt HIST_IGNORE_SPACE       # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS      # Remove extra blanks
setopt INC_APPEND_HISTORY      # Write history immediately

# --------------------------------------------------
# Shell behavior
# --------------------------------------------------

setopt AUTO_CD                 # cd by typing directory name
setopt AUTO_PUSHD              # Push dirs onto stack
setopt PUSHD_IGNORE_DUPS       # No duplicate dirs
setopt INTERACTIVE_COMMENTS    # Allow comments in shell
setopt EXTENDED_GLOB           # Powerful globbing

unsetopt BEEP                  # No terminal bell

# --------------------------------------------------
# Completion system
# --------------------------------------------------

autoload -Uz compinit
compinit

# Completion options
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ''

# --------------------------------------------------
# Keybindings
# --------------------------------------------------

# Use emacs-style keybindings (default, explicit)
bindkey -v

# Useful bindings
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^R' history-incremental-search-backward

# --------------------------------------------------
# Prompt (minimal, fast, readable)
# --------------------------------------------------

# Colors
autoload -Uz colors
colors

# Prompt layout:
# user@host path
# %

PROMPT='%F{cyan}%n@%m%f %F{yellow}%~%f
%F{green}%% %f'

# --------------------------------------------------
# Aliases (keep them obvious)
# --------------------------------------------------

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'

# Git
alias g='git'
alias gs='git status'
alias gl='git log --oneline --graph --decorate'

alias myip='curl https://icanhazip.com'

# --------------------------------------------------
# Environment tweaks
# --------------------------------------------------

# Less behaves like a sane pager
export LESS='-R --use-color -Dd+r$Du+b'

# Make man pages readable
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# --------------------------------------------------
# Optional: source local overrides
# --------------------------------------------------

# This file is not tracked. Machine-specific tweaks go here.
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"

source <(fzf --zsh)

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
