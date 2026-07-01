#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
# Add .NET Core SDK tools
export PATH="$PATH:/home/karoki/.dotnet/tools"
. "$HOME/.aftman/env"
