.PHONY: eval test install-bats board board-render update help

BATS := $(shell command -v bats 2>/dev/null || echo /tmp/bats-install/bin/bats)
TESTS := tests/test_selfhost.bats

help: ## Show available targets
	@echo ""
	@echo "kaizen-spec Makefile"
	@echo "--------------------"
	@echo "  make eval          Run bats acceptance tests"
	@echo "  make test          Alias for eval"
	@echo "  make board         Render + serve .kaizen/board.html (auto-finds free port)"
	@echo "  make board-render  Regenerate board.html from tasks.json (no server)"
	@echo "  make update        Re-run install.sh to upgrade skill to latest version"
	@echo "  make ci-local      Run docs.yml locally via act (requires docker + act)"
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

board-render: ## Regenerate .kaizen/board.html from tasks.json (no server)
	python3 scripts/render_board.py

board: board-render ## Render + serve .kaizen/board.html — auto-finds a free port (override: PORT=9090 make board)
	@p=$${PORT:-8081}; \
	while ss -tlnH "sport = :$$p" 2>/dev/null | grep -q .; do p=$$((p + 1)); done; \
	LAN=$$(hostname -I 2>/dev/null | awk '{print $$1}'); \
	HOST=$${LAN:-localhost}; \
	echo ""; \
	echo "  Board (local)  → http://localhost:$$p/board.html"; \
	echo "  Board (network)→ http://$$HOST:$$p/board.html"; \
	echo "  SSH tunnel     → ssh -L $$p:localhost:$$p $$(whoami)@$$HOST"; \
	echo "  Ctrl-C to stop"; \
	echo ""; \
	xdg-open "http://localhost:$$p/board.html" 2>/dev/null || open "http://localhost:$$p/board.html" 2>/dev/null || true; \
	if command -v python3 >/dev/null 2>&1; then \
		python3 -m http.server --directory .kaizen --bind 0.0.0.0 $$p; \
	elif command -v npx >/dev/null 2>&1; then \
		npx serve .kaizen -p $$p; \
	else \
		echo "No python3 or npx found. Install one to serve the board."; \
		exit 1; \
	fi

update: ## Upgrade kaizen-spec skill to latest version from GitHub
	@echo "Fetching latest kaizen-spec skill ..."
	@curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
	@echo "Update complete."

ci-local: ## Run docs.yml workflow locally with act (requires: docker + act)
	@if ! command -v act >/dev/null 2>&1; then \
		echo "act not found. Install: https://github.com/nektos/act#installation"; \
		echo "  Ubuntu/Debian: curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash"; \
		exit 1; \
	fi
	act push --workflows .github/workflows/docs.yml --job build

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
