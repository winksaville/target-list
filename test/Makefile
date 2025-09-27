.PHONY: help h H compile c clean

INDENT_PAD=3 # spaces to indent target-list choose to mathc Usage or other text
DESC_PAD=6 # spaces between target and description columns

help h H:## Show this help message
	@echo "Manage the building and testing this project"
	@echo ""
	@echo "Usage:"
	@echo "   make <target>  Examples make compile hw.c"
	@echo "                           make c hw.c"
	@echo ""
	@echo "Targets:"
	@awk -v indent_pad=$(INDENT_PAD) -v desc_pad=$(DESC_PAD) -f support/target-list.awk $(lastword $(MAKEFILE_LIST))

# The nothing does nothing and allows you to see resulting command line:
#    $ make lib.install PKG="two words"
#    ./nothing lib install "two words"
#    $
lib.%:	## Runs: nothing lib <cmd> "$(PKG)"
	./nothing lib $(@:lib.%=%) $(if $(PKG),"$(PKG)")

compile c: ## Build the project from source
	@echo "Translate source files to object files."

clean: ## Remove build artifacts
	@echo "Remove any and all build artifacts."
