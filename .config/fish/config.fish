
if status is-interactive
    # Commands to run in interactive sessions can go here
    # source ('/usr/bin/starship' init fish --print-full-init | psub)
end

## Usefule aliases
#
## Replace ls with eza
alias ls 'eza -alh --color=always --group-directories-first --icons' # preferred listing
alias la 'eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll 'eza -lh --color=always --group-directories-first --icons' # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -alhd --color=always --group-directories-first --icons .*' # show only dotfiles
alias l 'eza -alh --color=always --long --git --no-filesize --icons --no-time --no-user --no-permissions'

# STARSHIP
starship init fish | source

# ANDROID
set ANDROID_HOME = $HOME/Android/Sdk/
set PATH $PATH $ANDROID_HOME $HOME/Android/Sdk/platform-tools/

# FLUTTER
# set PATH $PATH /usr/local/bin/flutter/bin/
set PATH $PATH /opt/flutter/bin/
set PATH $PATH $HOME/.pub-cache/bin/


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
