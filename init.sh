#!/bin/bash

# link files
BASE_DIR=`pwd`
pushd $HOME
ln -snf ${BASE_DIR}/home/.zshrc .zshrc
ln -snf ${BASE_DIR}/home/.zsh.d .zsh.d
ln -snf ${BASE_DIR}/home/.gitconfig .gitconfig

[ ! -d .config ] && mkdir .config
ln -snf ${BASE_DIR}/home/.config/brewfile .config/brewfile
ln -snf ${BASE_DIR}/home/.config/karabiner .config/karabiner

[ ! -d .ssh ] && mkdir .ssh
ln -snf ${BASE_DIR}/home/.ssh/config .ssh/config

# VSCode...
popd

exit 

# install brew-file to restore from Brewfile
curl -fsSL https://raw.github.com/rcmdnk/homebrew-file/install/install.sh |sh

# restore packages from Brewfile
brew file install

sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

