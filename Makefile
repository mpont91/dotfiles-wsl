.PHONY: install nvm ohmyzsh link zsh

install:
	./install.sh

nvm:
	./nvm/nvm-install.sh

ohmyzsh:
	./ohmyzsh/ohmyzsh-install.sh		

link:
	./link-dotfiles.sh

zsh:
	chsh -s $$(which zsh)