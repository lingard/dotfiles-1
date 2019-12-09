VSCODECFGDIR := $(HOME)/Library/Application\ Support/Code/User

init:
	test -d $(HOME).hammerspoon || ln -s $(PWD)/hammerspoon $(HOME)/.hammerspoon
	test -L $(HOME)/.zshenv.sh || ln -s $(PWD)/zsh/.zshenv.sh $(HOME)/.zshenv.sh
	test -L $(HOME)/.zshrc.sh || ln -s $(PWD)/zsh/.zshrc.sh $(HOME)/.zshrc.sh
	test -L $(VSCODECFGDIR)/settings.json || ln -s $(PWD)/vscode/settings.json $(VSCODECFGDIR)/settings.json
	test -L $(VSCODECFGDIR)/keybindings.json || ln -s $(PWD)/vscode/keybindings.json $(VSCODECFGDIR)/keybindings.json
	test -L $(VSCODECFGDIR)/projects.json || ln -s $(PWD)/vscode/projects.json $(VSCODECFGDIR)/projects.json
	test -d $(VSCODECFGDIR)/snippets || ln -s $(PWD)/vscode/snippets $(VSCODECFGDIR)/snippets
	test -L $(HOME)/.ssh/config_commons || ln -s $(PWD)/ssh_config_common $(HOME)/.ssh/config_common
	test -L $(HOME)/.gitconfig || ln -s $(PWD)/gitconfig $(HOME)/.gitconfig
	test -L $(HOME)/.gitignore || ln -s $(PWD)/.gitignore $(HOME)/.gitignore
	test -L $(HOME)/.editorconfig || ln -s $(PWD)/.editorconfig $(HOME)/.editorconfig
	test -L $(HOME)/~/.oh-my-zsh/themes/honukai.zsh-theme || ln -s $(PWD)/zsh/honukai-iterm-zsh/honukai.zsh-theme $(HOME)/~/.oh-my-zsh/themes/honukai.zsh-theme
}

clean:
	rm -rf $(HOME)/.hammerspoon
	rm -rf $(HOME)/.bash_profile
	rm -rf $(HOME)/.bashrc
	rm -rf $(VSCODECFGDIR)/projects.json $(VSCODECFGDIR)/keybindings.json $(VSCODECFGDIR)/settings.json $(VSCODECFGDIR)/snippets
	rm -rf $(HOME)/.ssh/config_common
	rm -rf $(HOME)/.gitconfig
