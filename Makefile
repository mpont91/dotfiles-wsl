.PHONY: install claude nvm ohmyzsh link zsh

install:
	./install.sh

nvm:
	./nvm/nvm-install.sh

claude:
	./claude/claude-install.sh

ohmyzsh:
	./ohmyzsh/ohmyzsh-install.sh		

link:
	./link-dotfiles.sh

zsh:
	chsh -s $$(which zsh)