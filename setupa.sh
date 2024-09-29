# setup for current user
echo "Debug: Setting up zsh for current user"
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s $(which zsh) $USER
echo $SHELL

# setup oh my zsh
echo "Debug: Setting up Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install powerlevel10k theme
echo "Debug: Installing powerlevel10k theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install zsh-autosuggestions
echo "Debug: Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# install zsh-syntax-highlighting
echo "Debug: Installing zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~

# install https://github.com/unixorn/fzf-zsh-plugin
echo "Debug: Installing fzf-zsh-plugin"
git clone https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

# copy the .zshrc and .p10k.zsh into ~
echo "Debug: Copying .zshrc and .p10k.zsh to home directory"
cp .zshrc ~
cp .p10k.zsh ~

# restart zsh
echo "Debug: Restarting zsh"
source ~/.zshrc

# complete installation
echo "Debug: Installation complete"
echo "done"