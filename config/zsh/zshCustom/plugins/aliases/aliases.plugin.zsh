# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lh'
alias lla='ls -lhA'
alias gi='git'
alias cls='printf "\033c"';
alias ag='ag -f --hidden'

alias open='xdg-open'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias top='bpytop'

# alias fix_git_completion='rm /usr/local/share/zsh/site-functions/_git'

alias profile_shell_startup='for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done'

# alias git_pull_all='find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -P10 -I {} git -C {} pull -pt'

alias update_host_no_ads='python3 ~/git/system/hosts/updateHostsFile.py -garf -e gambling fakenews'
alias clear_eval_cache='ls $HOME/.zsh-evalcache &> /dev/null && rm -rf $HOME/.zsh-evalcache'
alias clear_pacman_cache='yay -Scc'
alias update_system='printf "update sysyem\n"; yay -Syu; printf "removing orphan packages"; yay -Rns $(yay -Qqtd)'
alias update_zsh='printf "update zinit\n"; zinit self-update; printf "update zinit plugins\n"; zinit update;'
alias update='clear_eval_cache; clear_pacman_cache; update_system; update_zsh; nvm upgrade; source ~/.zshrc'

alias tmux_layout='tmux list-windows -F "#{window_active} #{window_layout}" | grep "^1" | cut -d " " -f 2'
alias tx='tmuxinator'
