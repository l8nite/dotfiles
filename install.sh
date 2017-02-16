#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$DIR" != "$HOME/.dotfiles" ]]; then
  echo "You forgot to clone this repository into ~/.dotfiles (instead of: ${DIR})"
  exit 1
fi

backup () {
  # if it exists and isn't a symbolic link
  if [[ -e "$1" && ! -h "$1" ]]; then
    mv $1 $1.`date +%Y%m%dT%H%M`
  fi

  if [[ -h "$1" ]]; then
    rm "$1"
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
  backup ~/.vimrc
  ln -s ~/.maximum-awesome/vimrc ~/.vimrc

  backup ~/.vimrc.bundles
  ln -s ~/.maximum-awesome/vimrc.bundles ~/.vimrc.bundles

  # Install maximum-awesome's plugins and snippets
  cp -R ~/.maximum-awesome/vim/* ~/.vim/

  # Link my own .local configurations
  backup ~/.vimrc.local
  ln -s ~/.dotfiles/vimrc.local ~/.vimrc.local

  backup ~/.vimrc.bundles.local
  ln -s ~/.dotfiles/vimrc.bundles.local ~/.vimrc.bundles.local

  # Install the vim plugins
  vim +PluginInstall +qall now &>/dev/null
}

setup_tmux() {
  # Link maximum-awesome's tmux configuration files
  backup ~/.tmux.conf
  ln -s ~/.maximum-awesome/tmux.conf ~/.tmux.conf

  # Link my own .local configurations
  backup ~/.tmux.conf.local
  ln -s ~/.dotfiles/tmux.conf.local ~/.tmux.conf.local
}

setup_bash_aliases() {
  # This script assumes the default .bashrc reads this file
  backup ~/.bash_aliases
  ln -s ~/.dotfiles/bash_aliases ~/.bash_aliases
}

setup_bashrc() {
  echo 'source ~/.dotfiles/bashrc.local' >> ~/.bashrc
}

setup_git_prompt() {
  backup ~/.git-prompt.sh
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
