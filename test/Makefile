.PHONY: help h H compile c clean

INDENT=3 # spaces to indent target-list choose to mathc Usage or other text

help h H:     ## Show this help message
	@echo "Manage the building and testing this project"
	@echo ""
	@echo "Usage:"
	@echo "   make <target>  Examples make compile hw.c"
	@echo "                           make c hw.c"
	@echo ""
	@echo "Targets:"
	@awk -v indent=$(INDENT) -f support/target-list.awk $(lastword $(MAKEFILE_LIST))

lib.%:   ## `make lib.<cmd> PKG=<pkg>` -> `arduino-cli lib <cmd> "$(PKG)"`. For lib help `make lib.help`. Example: `make lib.install PKG="ArduinoJson"`
	@[ -n "$*" ] && arduino-cli lib "$*" "$(PKG)" \
	 || { echo "Error: missing cmd in lib.<cmd>" >&2; exit 1; }

compile c:    ## Build the project from source
	@echo "Translate source files to object files."

clean:        ## Remove build artifacts
	@echo "Remove any and all build artifacts."
