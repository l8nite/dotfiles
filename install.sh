#!/bin/bash
set -e

backup () {
  if [[ -e "$1" ]]; then
    mv $1 $1.`date +%Y%m%dT%H%M`
  fi
}

# Install some packages we need
sudo apt-get install curl git vim

# Install maximum-awesome
rm -rf ~/.maximum-awesome
git clone https://github.com/square/maximum-awesome ~/.maximum-awesome

setup_vim() {
  # Make a backup of ~/.vim
  backup ~/.vim

  # Install Vundle
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  # Link maximum-awesome's vim configuration files
  ln -s ~/.maximum-awesome/vimrc ~/.vimrc
  ln -s ~/.maximum-awesome/vimrc.bundles ~/.vimrc.bundles

  # Install maximum-awesome's plugins and snippets
  cp -R ~/.maximum-awesome/vim/* ~/.vim/

  # Link my own .local configurations
  ln -s ~/.dotfiles/vimrc.local ~/.vimrc.local
  ln -s ~/.dotfiles/vimrc.bundles.local ~/.vimrc.bundles.local

  # Install the vim plugins
  vim +PluginInstall +qall now
}

setup_tmux() {
  # Make a backup of ~/.tmux.conf
  backup ~/.tmux.conf

  # Link maximum-awesome's tmux configuration files
  ln -s ~/.maximum-awesome/tmux.conf ~/.tmux.conf

  # Link my own .local configurations
  ln -s ~/.dotfiles/tmux.conf.local ~/.tmux.conf.local
}

setup_bash_aliases() {
  backup ~/.bash_aliases

  # This script assumes the default .bashrc reads this file
  ln -s ~/.dotfiles/bash_aliases ~/.bash_aliases
}

setup_bashrc() {
  echo 'source ~/.dotfiles/bashrc.local' >> ~/.bashrc
}

setup_git_prompt() {
  curl -s -o ~/.git-prompt.sh \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
}

setup_gitconfig() {
  backup ~/.gitconfig
  ln -s ~/.dotfiles/gitconfig ~/.gitconfig
}

setup_ssh_config() {
  if [[ ! -d ~/.ssh ]]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
  fi

  backup ~/.ssh/config
  ln -s ~/.dotfiles/ssh-config ~/.ssh/config
}

setup_vim
setup_tmux
setup_bash_aliases
setup_bashrc
setup_git_prompt
setup_gitconfig
