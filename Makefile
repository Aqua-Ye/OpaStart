.PHONY: all clean run plugins test

EXE = my_app.exe
OPA ?= opa
OPA_PLUGIN ?= opa-plugin-builder
OPA_OPT ?=
MINIMAL_VERSION = 1466 # 0.9.1
CONF_FILE = opa.conf
BUILD_DIR ?= _build
PLUGIN_DIR = plugins

_ = $(shell mkdir -p $(BUILD_DIR))

default: $(EXE)

plugins: plugins/*/*.opa plugins/*/*.js
	@echo "### Building all plugins... ###"
	@for plugin in `ls $(PLUGIN_DIR)`; do \
		echo "--> Building plugin $$plugin"; \
		$(OPA_PLUGIN) --js-validator-off \
		--build-dir $(BUILD_DIR) \
		$(PLUGIN_DIR)/$$plugin/*.js \
		-o $$plugin.opp; \
		$(OPA) $(OPA_OPT) \
		--opx-dir $(BUILD_DIR) \
		--build-dir $(BUILD_DIR) \
		$(PLUGIN_DIR)/$$plugin/*.opa \
		$$plugin.opp; \
	done;

$(EXE): plugins resources/* src/*.opa
	@echo "### Building CSS... ###"
	recess --compress --compile resources/css/*.less > resources/css/style.css
	@echo "### Building $(EXE)... ###"
	@$(OPA) $(OPA_OPT) --minimal-version $(MINIMAL_VERSION) \
	--conf $(CONF_FILE) --conf-opa-files \
	--opx-dir $(BUILD_DIR) \
	--build-dir $(BUILD_DIR) \
	-o $(EXE)

run: $(EXE)
	./$(EXE) $(RUN_OPT) || true ## prevent ugly make error 130 :) ##

test: $(EXE) test/*.opa
	@echo "### Running Tests... ###"

clean::
	rm -Rf *.exe _build _tracks *.log **/#*#
	rm -Rf $(PLUGIN_DIR)/*/*.exe
