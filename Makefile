# Open Federated Database Specification -- Bikeshed build system
#
# The specification is authored as a single Bikeshed source document,
# $(BUILT), which is rendered to $(OUTPUT).
#
# Usage:
#   make            build the specification (default target)
#   make spec       build the specification from $(BUILT) to $(OUTPUT)
#   make watch      rebuild automatically whenever the source changes
#   make check      strict build; fails on any warning or error
#   make update     refresh Bikeshed specification data (run after upgrades)
#   make serve      serve the built specification locally
#   make clean      remove build artifacts
#   make deploy     publish $(OUTPUT) to the gh-pages branch
#   make install    install Bikeshed into the user environment
#   make help       print this help message

BIKESHED ?= pipx run bikeshed
BUILT    ?= index.bs
OUTPUT   ?= index.html
PORT     ?= 8000
DIRECTORIES ?= assets

GH_PAGES_DIR    ?= .gh-pages-worktree
GH_PAGES_BRANCH ?= gh-pages

.PHONY: all spec watch check update serve clean deploy install help

all: spec

spec: $(BUILT)
	@mkdir -p $(dir $(OUTPUT))
	@$(BIKESHED) spec $(BUILT) $(OUTPUT) --additional-directories $(DIRECTORIES)
	@echo "Built $(OUTPUT) from $(BUILT)."

watch:
	@echo "Watching $(BUILT) for changes..."
	@while true; do make -s spec 2>/dev/null || make -s spec; sleep 2; done

check: $(BUILT)
	@mkdir -p $(dir $(OUTPUT))
	@$(BIKESHED) spec $(BUILT) $(OUTPUT) -f fatal --additional-directories $(DIRECTORIES)
	@echo "Checked $(BUILT): no warnings or errors."

update:
	@$(BIKESHED) update

serve: spec
	@echo "Serving at http://127.0.0.1:$(PORT)/"
	@python3 -m http.server $(PORT) --bind 127.0.0.1

clean:
	@rm -f $(OUTPUT)
	@git worktree prune
	@rm -rf $(GH_PAGES_DIR)
	@echo "Removed build artifacts."

deploy: check
	@git worktree prune
	@if [ -d $(GH_PAGES_DIR) ]; then \
		git worktree remove -f $(GH_PAGES_DIR); \
	fi
	@git worktree add $(GH_PAGES_DIR) $(GH_PAGES_BRANCH) \
		|| git worktree add -b $(GH_PAGES_DIR) $(GH_PAGES_BRANCH)
	@cp $(OUTPUT) $(GH_PAGES_DIR)/
	@cp -r assets $(GH_PAGES_DIR)/
	@git -C $(GH_PAGES_DIR) add -A
	@git -C $(GH_PAGES_DIR) commit -m "Publish $(OUTPUT)" --allow-empty
	@git -C $(GH_PAGES_DIR) push origin $(GH_PAGES_BRANCH)
	@git worktree remove $(GH_PAGES_DIR)
	@echo "Published $(OUTPUT) to $(GH_PAGES_BRANCH)."

install:
	@pipx install bikeshed
	@$(BIKESHED) update

help:
	@echo "Targets:"
	@echo "  spec    build the specification ($(BUILT) -> $(OUTPUT))"
	@echo "  watch   rebuild on every change"
	@echo "  check   strict build; fails on warnings/errors"
	@echo "  update  refresh Bikeshed specification data"
	@echo "  serve   serve the built spec at http://127.0.0.1:$(PORT)/"
	@echo "  clean   remove build artifacts"
	@echo "  deploy  publish $(OUTPUT) to the $(GH_PAGES_BRANCH) branch"
	@echo "  install install Bikeshed via pipx"
	@echo ""
	@echo "Variables: BIKESHED, BUILT, OUTPUT, PORT"
