#!/usr/bin/env bash

backup() {
  rsync -auh --delete --info=progress2 --stats ~/.config/i3 ~/.config/alacritty ~/.config/sublime-text ~/.config/zsh ~/.config/xfce4 ~/.config/picom ~/git/system/dotfiles/config
  rsync -auh --delete --info=progress2 --stats ~/.config/tmux/tmux.conf ~/git/system/dotfiles/config/tmux
  rsync -auh --stats --info=progress2 ~/.gitconfig ~/.gitignore ~/.starship ~/.vimrc ~/.zshrc ~/.xinitrc ~/git/system/dotfiles/dotfiles
  rsync -auh --stats --info=progress2 ~/.nvm/default-packages ~/git/system/dotfiles/node/default-packages
  pacman -Qqe > ~/git/system/dotfiles/packages
  cd ~/git/system/dotfiles
  git send 'BACKUP'
  cd -
}

restore () {
  rsync -auh --info=progress2 --stats ~/git/system/dotfiles/config/ ~/.config
  rsync -auh --info=progress2 --stats ~/git/system/dotfiles/dotfiles/ ~/
  rsync -auh --info=progress2 --stats ~/git/system/dotfiles/node/default-packages ~/.nvm/default-packages
}

gen_psw() {
  LC_ALL=C tr -dc "[=!=][=?=][=.=][:alnum:]" < /dev/urandom | head -c ${1:-30} | pbcopy
}

gzip_size () {
  gzip -c $1 | wc -c
}

git_update_all_branches() {
  current_branch=$(git rev-parse --abbrev-ref HEAD);
  for BRANCH in `git branch --list|sed 's/\*//g'`;
  do
    git checkout $BRANCH;
    git bup;
  done;
  git checkout $current_branch;
}

pr (){
  open-pr ${1-master}
}

show_process_on_port() {
  lsof -iTCP -sTCP:LISTEN -P -n  | grep --color $1
}

find_largest_file(){
  find -type f -exec du -Sh {} + | sort -rh | head -n ${1:-10}
}

git_search() {
  git grep $1 $(git rev-list --all -- ${2:-.}) -- ${2:-.}
}

nas_mount() {
  FOLDER=${1-home}
  sudo mount -t cifs //192.168.1.2/${FOLDER} ~/NAS/${FOLDER} -o x-mount.mkdir,iocharset=utf8,credentials=/etc/samba/credentials/nas-master,uid=master,gid=master
}

nas_list_share() {
  sudo smbclient -L 192.168.1.2 -A /etc/samba/credentials/nas-master
}

nas_umount() {
  FOLDER=${1}
  if [ -z "${FOLDER}" ]
  then
      for d in ~/NAS/*/ ; do
        echo "unmounting ${d}"
        sudo umount ${d}
        sleep 0.5
        rm -rf ${d}
        echo "unmounted ${d}"
      done
  else
      sudo umount ~/NAS/${FOLDER}
      rm -rf ~/NAS/${FOLDER}
  fi
}

