.PHONY: help h H compile c clean

help h H:     ## Show this help message
	@echo "Manage the building and testing this project"
	@echo ""
	@echo "Usage:"
	@echo "   make <target>  Examples make compile hw.c"
	@echo "                           make c hw.c"
	@echo ""
	@echo "Targets:"
	@awk -f support/target-list.awk $(lastword $(MAKEFILE_LIST))

compile c:    ## Build the project from source
	echo "Translate source files to object files."

clean:        ## Remove build artifacts
	echo "Remove any and all build artifacts."