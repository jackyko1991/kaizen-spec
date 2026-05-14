.PHONY: eval test install-bats help

BATS := $(shell command -v bats 2>/dev/null || echo /tmp/bats-install/bin/bats)
TESTS := tests/test_selfhost.bats

help: ## Show available targets
	@echo ""
	@echo "kaizen-spec Makefile"
	@echo "--------------------"
	@echo "  make eval          Run bats acceptance tests"
	@echo "  make test          Alias for eval"
	@echo "  make install-bats  Install bats-core to /tmp/bats-install"
	@echo "  make help          Show this help"
	@echo ""
	@echo "Trigger-eval (description optimisation):"
	@echo "  Open evals/trigger-evals.json and run the eval harness manually."
	@echo "  See docs/guide/getting-started.md for instructions."
	@echo ""

eval: ## Run bats acceptance tests
	@if [ ! -x "$(BATS)" ]; then \
		echo "bats not found. Run: make install-bats"; \
		exit 1; \
	fi
	$(BATS) $(TESTS)
	@echo ""
	@echo "--- Trigger-eval (description optimisation) ---"
	@echo "To test trigger accuracy against the local skill:"
	@echo "  1. Open evals/trigger-evals.json"
	@echo "  2. Run the eval harness: npx kaizen-evals evals/trigger-evals.json"
	@echo "     (or see README for the manual eval workflow)"

test: eval ## Alias for eval

install-bats: ## Clone and install bats-core to /tmp/bats-install
	@if [ -x "/tmp/bats-install/bin/bats" ]; then \
		echo "bats already installed at /tmp/bats-install/bin/bats"; \
	else \
		echo "Installing bats-core to /tmp/bats-install ..."; \
		git clone https://github.com/bats-core/bats-core /tmp/bats-core-src; \
		/tmp/bats-core-src/install.sh /tmp/bats-install; \
		rm -rf /tmp/bats-core-src; \
		echo "Done. bats available at /tmp/bats-install/bin/bats"; \
	fi
