#!/usr/bin/env /tmp/bats-install/bin/bats
# kaizen-spec self-hosting acceptance tests
# Framework: bats-core (installed locally at /tmp/bats-install/bin/bats)
# Run: /tmp/bats-install/bin/bats tests/test_selfhost.bats
#
# ALL tests are expected to FAIL before implementation is complete.

REPO_ROOT="/home/jackyko/Projects/kaizen-spec"

# ---------------------------------------------------------------------------
# a) Self-hosting: CLAUDE.md
# ---------------------------------------------------------------------------

@test "a1: CLAUDE.md exists at repo root" {
  [ -f "$REPO_ROOT/CLAUDE.md" ]
}

@test "a2: CLAUDE.md references local skill pickup (.claude/commands)" {
  grep -q "\.claude/commands" "$REPO_ROOT/CLAUDE.md"
}

# ---------------------------------------------------------------------------
# b) curl install: install.sh presence and executability
# ---------------------------------------------------------------------------

@test "b1: install.sh exists at repo root" {
  [ -f "$REPO_ROOT/install.sh" ]
}

@test "b2: install.sh is executable" {
  [ -x "$REPO_ROOT/install.sh" ]
}

@test "b3: install.sh contains a curl or wget download mechanism" {
  grep -qE "(curl|wget)" "$REPO_ROOT/install.sh"
}

# ---------------------------------------------------------------------------
# c) curl install: install.sh actually installs the file to INSTALL_DIR
# ---------------------------------------------------------------------------

@test "c1: install.sh creates kaizen-spec.md under INSTALL_DIR when run" {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  # Run install.sh with a custom INSTALL_DIR; must not require network —
  # a conforming install.sh copies from the local repo or downloads the file.
  # We allow up to 30 s for network-based installs.
  INSTALL_DIR="$tmp_dir" bash "$REPO_ROOT/install.sh" >/dev/null 2>&1
  local result=$?
  # Check that the installed file exists at the expected path.
  local installed_file
  # install.sh should place the skill at $INSTALL_DIR/.claude/commands/kaizen-spec.md
  installed_file="$tmp_dir/.claude/commands/kaizen-spec.md"
  [ -f "$installed_file" ]
  rm -rf "$tmp_dir"
}

# ---------------------------------------------------------------------------
# d) Makefile: `make eval` target exists
# ---------------------------------------------------------------------------

@test "d1: Makefile exists at repo root" {
  [ -f "$REPO_ROOT/Makefile" ]
}

@test "d2: Makefile contains an 'eval' target" {
  grep -qE "^eval[[:space:]]*:" "$REPO_ROOT/Makefile"
}

# ---------------------------------------------------------------------------
# e) Philosophy: README.md must NOT contain "Ralph-style"
# ---------------------------------------------------------------------------

@test "e1: README.md does not contain the string 'Ralph-style'" {
  # Invert: test fails if the string IS present
  ! grep -q "Ralph-style" "$REPO_ROOT/README.md"
}

# ---------------------------------------------------------------------------
# f) Philosophy: README.md contains at least two Toyota/TPS concepts
# ---------------------------------------------------------------------------

@test "f1: README.md mentions at least two of: Jidoka Muda Poka-Yoke JIT TPS" {
  local count=0
  for term in Jidoka Muda "Poka-Yoke" JIT TPS; do
    grep -q "$term" "$REPO_ROOT/README.md" && count=$((count + 1))
  done
  [ "$count" -ge 2 ]
}

# ---------------------------------------------------------------------------
# g) Getting-started: curl is Option A (appears before git clone)
# ---------------------------------------------------------------------------

@test "g1: docs/guide/getting-started.md exists" {
  [ -f "$REPO_ROOT/docs/guide/getting-started.md" ]
}

@test "g2: getting-started.md mentions curl before git clone" {
  local file="$REPO_ROOT/docs/guide/getting-started.md"
  local curl_line git_line
  curl_line=$(grep -n "curl" "$file" | head -1 | cut -d: -f1)
  git_line=$(grep -n "git clone" "$file" | head -1 | cut -d: -f1)
  # Both must exist
  [ -n "$curl_line" ]
  [ -n "$git_line" ]
  # curl must appear on an earlier line than git clone
  [ "$curl_line" -lt "$git_line" ]
}

# ---------------------------------------------------------------------------
# h) Board: templates/board.html template exists (board.html itself is created
#    by implementation — we only verify the template source is present)
# ---------------------------------------------------------------------------

@test "h1: templates/board.html exists in repo" {
  [ -f "$REPO_ROOT/templates/board.html" ]
}
