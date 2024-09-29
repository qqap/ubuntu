# install zsh
echo "Debug: Installing zsh and curl"
sudo apt update
sudo apt install zsh -y
sudo apt install curl -y

# Check if user "a" already exists
if id "a" &>/dev/null; then
    echo "User 'a' already exists."
    read -p "Are you sure you want to delete user 'a' and their home directory? (Type 'yes' to confirm): " confirm
    if [ "$confirm" = "yes" ]; then
        read -p "This action is irreversible. Type 'yes' again to confirm: " confirm2
        if [ "$confirm2" = "yes" ]; then
            echo "Deleting user 'a' and their home directory..."
            sudo userdel -r a
        else
            echo "Operation cancelled."
            exit 1
        fi
    else
        echo "Operation cancelled."
        exit 1
    fi
fi

# Check if /home/a exists (in case the user was deleted but the directory remains)
if [ -d "/home/a" ]; then
    echo "Directory /home/a exists."
    read -p "Are you sure you want to delete /home/a? (Type 'yes' to confirm): " confirm
    if [ "$confirm" = "yes" ]; then
        read -p "This action is irreversible. Type 'yes' again to confirm: " confirm2
        if [ "$confirm2" = "yes" ]; then
            echo "Deleting /home/a..."
            sudo rm -rf /home/a
        else
            echo "Operation cancelled."
            exit 1
        fi
    else
        echo "Operation cancelled."
        exit 1
    fi
fi


# Create user "a"
echo "Debug: Creating user 'a'"
sudo useradd -m -s /bin/zsh a

# Add user "a" to sudoers file without password requirement
echo "Debug: Adding user 'a' to sudoers file without password requirement"
echo "a ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/a
sudo chmod 0440 /etc/sudoers.d/a

# Set up SSH for user "a"
echo "Debug: Setting up SSH for user 'a'"
sudo -u a mkdir -p /home/a/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4DhuwpxW2YuZBrEWuIFY0nrZsVIW4Kma7HMxeGL1F64fnK68plpRcojd0scjwXol7BC7Pv0PWTIvnDKWMrbSuVoOXjf5/s79UQ0RGT7zPOYg2onx1JytqSHnEM7x7/uPok9edZ0HwK16MZaH/p3EOpBzsB1hcIiFdAkKew7rmjy0a65hZpoi2ikciWYD8R40n7G1NuDgJBgwzCOShXSg3EqPN6R8dQ4olhJgQoZJnwpP7ZUJfrwdyJGa4aSc54tSWNMpWxlurEZiL/twCO2io0X8wjQ12tRHby4xP6Ejcnx9RLABrZdxFzHpow4ZhNI5aIxtv7PAi3W4WMOhzb9s6XNopBkkW851D5FIELiKSin3LY/6qts4LSbVretxek5L09FI9a6DkutAs9vjIJHkRUnr4exy7opjF3YprpgnlFPyvj9pznaKHvwtEuNxXX5qyoi6F3d6Zhc57XGcYXJbwHNelX6jNWJVBpmdPVZTwNr85BrZOR3gbcVTByDFa9kE= qqap@macpro.local" | sudo -u a tee /home/a/.ssh/authorized_keys
sudo -u a chmod 600 /home/a/.ssh/authorized_keys

# Switch to user "a" for the rest of the setup
echo "Debug: Switching to user 'a'"
sudo su - a

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