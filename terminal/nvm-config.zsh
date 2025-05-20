export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm use --silent >/dev/null 2>&1 # Tries to load npm version from .nvmrc file

if ! command -v node >/dev/null 2>&1; then
    nvm use default --silent >/dev/null 2>&1 # Load default version if there is not .nvmrc file
fi