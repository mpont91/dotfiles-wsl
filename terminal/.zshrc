# Path to your dotfiles
export DOTFILES=$HOME/.dotfiles

# Custom paths
export PATH="$HOME/.local/bin:$PATH"

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="eastwood"

# Plugins
plugins=(git docker-compose zsh-autosuggestions zsh-syntax-highlighting gh)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
source $DOTFILES/terminal/.aliases

# Load NVM
source $DOTFILES/terminal/nvm-config.zsh

# Load pyenv
source $DOTFILES/terminal/pyenv-config.zsh

# Load ssh-agent
source $DOTFILES/terminal/ssh-agent-config.zsh

# IDE configuration
export EDITOR="vim"
export VISUAL="webstorm"