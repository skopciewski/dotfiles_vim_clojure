VIM_DIR := $(HOME)/.vim
VIM_PACK_DIR := $(VIM_DIR)/pack/clojure/start
VIM_PLUGIN_DIR := $(VIM_DIR)/plugin
CTAGS_CONFIG := $(HOME)/.ctags

install: prepare_vim

# link current dot file to the home dir
$(HOME)/%: %
	@ln -fs $(PWD)/$< $@

# check specific command
check_cmd_%:
	@if ! which $* &>/dev/null; then \
		echo "!! Missing $*"; \
		exit 1; \
	fi

# for vim
prepare_vim: check_vim_deps deploy_vim_configs manage_vim_plugins $(CTAGS_CONFIG)

check_vim_deps: check_cmd_git check_cmd_ctags check_cmd_joker

deploy_vim_configs: plugin/configs/*.vim plugin/*.vim
	@mkdir -p $(VIM_PLUGIN_DIR)
	@cp -r plugin/* $(VIM_PLUGIN_DIR)

manage_vim_plugins: clean_plugins install_plugins

install_plugins: $(VIM_PACK_DIR) vim_plugins.txt
	@for plugin in $$(cat ./vim_plugins.txt); do \
		echo "*** Installing: $${plugin} ***"; \
		$$(cd $(VIM_PACK_DIR) && git clone $${plugin} 2>/dev/null || true); \
	done


clean_plugins: $(VIM_PACK_DIR) vim_plugins.txt
	@for name in $$(find $(VIM_PACK_DIR) -maxdepth 1 -mindepth 1 -exec basename {} \;); do \
		if ! grep -q "$${name}.git$$" ./vim_plugins.txt; then \
			echo "*** Removing: $${name} ***"; \
			rm -rf $(VIM_PACK_DIR)/$${name}; \
		fi; \
	done

$(VIM_PACK_DIR):
	@mkdir -p $@

.PHONY: install prepare_vim check_vim_deps deploy_vim_configs manage_vim_plugins install_plugins clean_plugins
