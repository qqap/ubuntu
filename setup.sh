# install zsh
sudo apt update
sudo apt install zsh -y
sudo apt install curl -y

# setup for current user
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s $(which zsh) $USER
echo $SHELL

# switch to zsh
zsh

# setup oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install https://github.com/unixorn/fzf-zsh-plugin
git clone https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

# copy the .zshrc and .p10k.zsh into ~
cp .zshrc ~
cp .p10k.zsh ~

# restart zsh
source ~/.zshrc

# complete installation
echo "done"