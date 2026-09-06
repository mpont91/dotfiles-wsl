.PHONY: install config zsh projects projects-full

install:
	./install.sh

config:
	./config.sh

zsh:
	chsh -s $$(which zsh)

projects:
	./projects-setup.sh

projects-full:
	./projects-setup.sh present-connection victoria-id