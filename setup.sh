#!/bin/bash
set -e

backup () {
  if [ -f "$1" ]; then
    mv "$1" "$1.bak"
  fi
}

backup ~/.bashrc
ln -s ~/dotfiles/bashrc ~/.bashrc

backup ~/.bash_profile
ln -s ~/dotfiles/bash_profile ~/.bash_profile

backup ~/.bash_aliases
ln -s ~/dotfiles/bash_aliases ~/.bash_aliases

if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa
fi

backup ~/.ssh/config
ln -s ~/dotfiles/ssh.config ~/.ssh/config

backup ~/.tmux.conf
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

backup ~/.git-prompt.sh
curl -s -o ~/.git-prompt.sh \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

backup ~/.gitconfig
ln -s ~/dotfiles/gitconfig ~/.gitconfig

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

backup ~/.vimrc
ln -s ~/dotfiles/vimrc ~/.vimrc
vim +PluginInstall +qall now

#backup ~/.irssi/config
#if [ ! -d ~/.irssi ]; then
#  mkdir -p ~/.irssi
#fi
#ln -s ~/dotfiles/irssi.config ~/.irssi/config

echo 'remember to . ~/.bash_profile'
