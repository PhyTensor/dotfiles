## Set values

# Fish command history
function history
    builtin history --show-time='%F %T '
end


# Create a file backup
function backup --argument filename
    cp $filename $filename.bak
end


# Clearnup orphaned packages
function cleanup
    while pacman -Qqdt
        sudo pacman -R (pacman -Qqdt)
    end
end


## Usefule aliases
## Replace ls with eza
alias ls 'eza -alh --color=always --group-directories-first --icons' # preferred listing
alias la 'eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll 'eza -lh --color=always --group-directories-first --icons' # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -alhd --color=always --group-directories-first --icons .*' # show only dotfiles
alias l 'eza -alh --color=always --long --git --no-filesize --icons --no-time --no-user --no-permissions'

alias vim 'nvim'

alias cat 'bat --style header --style snip --style changes --style header'

# Common use
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias big 'expac -H M "%m\t%n" | sort -h | nl'     # Sort installed packages according to size in MB (expac must be installed)
alias dir 'dir --color=auto'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias grubup 'sudo update-grub'
alias hw 'hwinfo --short'                          # Hardware Info
alias ip 'ip -color'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias rmpkg 'sudo pacman -Rdd'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias vdir 'vdir --color=auto'
alias wget 'wget -c '

# Get fastest mirrors
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --protocol https --info --verbose --sort rate --threads $(nproc) --save /etc/pacman.d/mirrorlist'
alias mirrora 'sudo reflector --latest 50 --number 20 --protocol https --info --verbose --sort age --threads $(nproc) --save /etc/pacman.d/mirrorlist'
alias mirrord 'sudo reflector --latest 50 --number 20 --protocol https --info --verbose --sort delay --threads $(nproc) --save /etc/pacman.d/mirrorlist'
alias mirrors 'sudo reflector --latest 50 --number 20 --protocol https --info --verbose --sort score --threads $(nproc) --save /etc/pacman.d/mirrorlist'

# Help people new to Arch
alias tb 'nc termbin.com 9999'
alias helpme 'echo "To print basic information about a command use tldr <command>"'
alias pacdiff 'sudo -H DIFFPROG=meld pacdiff'

# Get the error messages from journalctl
alias jctl 'journalctl -p 3 -xb'

# Recent installed packages
alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

# GIT
alias ga 'git add'
alias gc 'git commit'
alias gi 'git init'
alias gd 'git diff'
alias gb 'git branch'
alias gP 'git push'
alias gp 'git pull'
alias gcl 'git clone'
alias gap 'git add --patch'
alias gss 'git status --short'
alias gco 'git checkout'
alias gcob 'git checkout -b'
# alias gl 'git log --oneline --decorate --graph --all'
alias gl "git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"
alias glg 'git log --oneline --decorate --graph --all --stat --date=short'
# %h -- commit hash
# %H -- abbreviated commit hash
# %an -- author name
# %ae -- author email
# %ar -- commit time
# %D -- ref names
# %n -- new line
# %s -- commit message

# ANDROID
# set ANDROID_HOME = $HOME/Android/Sdk/
# set PATH $PATH $ANDROID_HOME $HOME/Android/Sdk/platform-tools/

# FLUTTER
# set PATH $PATH /usr/local/bin/flutter/bin/
# set PATH $PATH /opt/flutter/bin/
# set PATH $PATH $HOME/.pub-cache/bin/


# DOTNET TOOLS
set PATH $PATH $HOME/.dotnet/tools/


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f /home/karoki/anaconda3/bin/conda
#    eval /home/karoki/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# else
#   if test -f "/home/karoki/anaconda3/etc/fish/conf.d/conda.fish"
#       . "/home/karoki/anaconda3/etc/fish/conf.d/conda.fish"
#   else
#       set -x PATH "/home/karoki/anaconda3/bin" $PATH
#   end
# end
#<<< conda initialize <<<


## Run fastfetch if session is interactive
#if status --is-interactive && type -q fastfetch
#   fastfetch --load-config dr460nized
#end

# STARSHIP
#starship init fish | source
# starship prompt
if status is-interactive
    # Commands to run in interactive sessions can go here
     source ('/usr/bin/starship' init fish --print-full-init | psub)

    # ZOXIDE
    zoxide init fish | source

    # Atuin
    atuin init fish | source
end

set MANPAGER "nvim +Man!"

# FZF shell integration
# Set up fzf key bindings
fzf --fish | source

# YAZI
# Shell wrapper for yazi. We suggest using this y shell wrapper that provides the ability to change the current working directory when exiting Yazi.
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


# TMUX-SESSIONISER
set PATH "$PATH":"$HOME/.config/scripts/"
bind \cf "tmux-sessioniser.sh"

