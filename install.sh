#!/bin/bash
# upgrade packages
xbps-install -Syu

# install stow
xbps-install -Sy stow

# install all configs
cd packages
stow -t $HOME *
cd ..

# install other required applications
xbps-install -Sy $(cat pkgs | xargs)

# install fisher
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

# install z
fish -c "fisher install jethrokuan/z"

# install fzf
fish -c "fisher install jethrokuan/fzf"

#install sdkman fish support
fish -c "fisher install reitzig/sdkman-for-fish@v2.0.0"

#install sdkman
fish -c "curl -s \"https://get.sdkman.io\" | bash"

fish -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\""

fish -c "sdk install java"

fish -c "sdk install gradle 7.5.1"

fish -c "sdk install maven"


# install packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
