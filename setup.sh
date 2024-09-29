# Exit on error
set -e

# Install zsh and curl if not already installed
command -v zsh &> /dev/null || { echo "Debug: Installing zsh"; sudo apt install zsh -y; }
command -v curl &> /dev/null || { echo "Debug: Installing curl"; sudo apt install curl -y; }

# Check if user "a" already exists
if grep -q "^a:" /etc/passwd; then
    echo "User 'a' already exists."
    echo "Please manually remove the user 'a' if needed, using the following commands:"
    echo "sudo userdel a"
    echo "sudo rm -rf /home/a"
    echo "sudo pkill -U a"
    echo "Then run this script again."
    exit 1
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

# Copy setupa.sh to /home/a and execute it as user a
echo "Debug: Copying setupa.sh to /home/a"
sudo cp setupa.sh /home/a/setupa.sh
sudo chown a:a /home/a/setupa.sh
sudo chmod +x /home/a/setupa.sh

echo "Debug: Executing setupa.sh as user a"
sudo -u a /home/a/setupa.sh

echo "Debug: Installation complete for user a"
# Get the IP address of the system
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Inform the user about SSH access
echo "Installation complete. You can now SSH into the system using:"
echo "ssh a@$IP_ADDRESS"
echo "This IP address was automatically detected from your system."