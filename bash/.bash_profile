# ~/.bash_profile - runs at login only

# Source .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Login reminder (only in interactive shells)
[[ $- == *i* ]] && echo -e "\n\033[1;33m󰮯 Remember: yay -Syu\033[0m\n"
