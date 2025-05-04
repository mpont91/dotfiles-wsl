.PHONY: install nvm ohmyzsh zsh link

install:
	./install.sh

nvm:
	./nvm/nvm-install.sh

ohmyzsh:
	./ohmyzsh/ohmyzsh-install.sh		

link:
	./link-dotfiles.sh

