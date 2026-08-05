.PHONY: install config zsh projects

install:
	./install.sh

config:
	./config.sh

zsh:
	chsh -s $$(which zsh)

projects:
	./projects-setup.sh