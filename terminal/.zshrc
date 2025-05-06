# Path to your dotfiles
export DOTFILES=$HOME/.dotfiles

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="eastwood"

# Plugins
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
source $DOTFILES/terminal/.aliases

# Load NVM
source $DOTFILES/terminal/nvm-config.zsh

# Load Android Studio SDK
source $DOTFILES/terminal/android-studio-config.zsh