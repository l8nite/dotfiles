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

if [ ! -f ~/.tmuxinator.bash ]; then
  curl -s -o ~/.tmuxinator.bash \
    https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash
fi

backup ~/.tmux.conf
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

if [ ! -f ~/.git-prompt.sh ]; then
  curl -s -o ~/.git-prompt.sh \
        https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
fi
backup ~/.gitconfig
ln -s ~/dotfiles/gitconfig ~/.gitconfig

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

backup ~/.vimrc
ln -s ~/dotfiles/vimrc ~/.vimrc
vim +PluginInstall +qall now

if [ ! -d ~/.rbenv ]; then
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

if [ ! -d ~/.ndenv ]; then
  git clone https://github.com/riywo/ndenv ~/.ndenv
fi

if [ ! -d ~/.goenv ]; then
  git clone https://github.com/wfarr/goenv.git ~/.goenv
fi

echo 'remember to . ~/.bash_profile'
