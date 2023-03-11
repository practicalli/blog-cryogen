# ------------------------------------------
# Practicalli Blog
#
# Makefile for Cryogen powered blog
# using Clojure CLI and deps.edn configuration
#
# ------------------------------------------


# ------- Makefile Variables --------- #

# run help if no target specified
.DEFAULT_GOAL := help

# Column the target description is printed from
HELP-DESCRIPTION-SPACING := 24

# Makefile file and directory name wildcard
MARKDOWN-FILES := $(wildcard *.md)

# ------------------------------------ #


# ------- Help ----------------------- #

# Source: https://nedbatchelder.com/blog/201804/makefile_help_target.html

help:  ## Describe available tasks in Makefile
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | \
	sort | \
	awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-$(HELP-DESCRIPTION-SPACING)s\033[0m %s\n", $$1, $$2}'

# ------------------------------------ #


# ------ Static Site Generator ------ #

blog:  ## Generate blog and run local server
	$(info --------- Static Site Generator ---------)
	clojure -X:serve

# ------------------------------------ #


# ------- Code Quality --------------- #

lint:  ## Run MegaLinter with custom configuration
	$(info --------- MegaLinter Runner ---------)
	mega-linter-runner --flavor documentation --env 'MEGALINTER_CONFIG=.github/linters/mega-linter.yml'

lint-clean:  ## Clean MegaLinter report information
	$(info --------- MegaLinter Clean Reports ---------)
	- rm -rf ./megalinter-reports

# ------------------------------------ #
