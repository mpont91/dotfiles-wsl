echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Oh My Zsh installed successfully!"

echo "Installing Oh My Zsh plugins..."

OHMYZSH_PLUGINS_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
mkdir -p "$OHMYZSH_PLUGINS_CUSTOM"

if [ ! -d "$OHMYZSH_PLUGINS_CUSTOM/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$OHMYZSH_PLUGINS_CUSTOM/zsh-autosuggestions"
else
    echo "zsh-autosuggestions is already installed."
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$OHMYZSH_PLUGINS_CUSTOM/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OHMYZSH_PLUGINS_CUSTOM/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting is already installed."
fi

echo "Oh My Zsh plugins installation finished."