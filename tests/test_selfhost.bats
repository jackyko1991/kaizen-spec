#!/usr/bin/env /tmp/bats-install/bin/bats
# kaizen-spec self-hosting acceptance tests
# Framework: bats-core (installed locally at /tmp/bats-install/bin/bats)
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
  local installed_file
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

@test "g2: getting-started.md mentions curl as primary install (git clone absent or appears after curl)" {
  local file="$REPO_ROOT/docs/guide/getting-started.md"
  local curl_line git_line
  curl_line=$(grep -n "curl" "$file" | head -1 | cut -d: -f1)
  git_line=$(grep -n "git clone" "$file" | head -1 | cut -d: -f1)
  # curl must be present
  [ -n "$curl_line" ]
  # if git clone appears, it must be after curl
  if [ -n "$git_line" ]; then
    [ "$curl_line" -lt "$git_line" ]
  fi
}

# ---------------------------------------------------------------------------
# h) Board: templates/board.html template exists (board.html itself is created
#    by implementation — we only verify the template source is present)
# ---------------------------------------------------------------------------

@test "h1: templates/board.html exists in repo" {
  [ -f "$REPO_ROOT/templates/board.html" ]
}

# ---------------------------------------------------------------------------
# i) Render script: scripts/render_board.py exists and runs without error
# ---------------------------------------------------------------------------

@test "i1: scripts/render_board.py exists" {
  [ -f "$REPO_ROOT/scripts/render_board.py" ]
}

@test "i2: render_board.py runs and produces .kaizen/board.html" {
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$REPO_ROOT/.kaizen/tasks.json" \
    --out /tmp/board-test-output.html
  [ -f /tmp/board-test-output.html ]
  rm -f /tmp/board-test-output.html
}

@test "i3: rendered board contains all visible task IDs (respects done_visible_max cap)" {
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$REPO_ROOT/.kaizen/tasks.json" \
    --out /tmp/board-test-ids.html
  python3 - <<'PYEOF'
import json, sys

data  = json.loads(open("/home/jackyko/Projects/kaizen-spec/.kaizen/tasks.json").read())
tasks = data["tasks"]
cap   = data.get("done_visible_max")
html  = open("/tmp/board-test-ids.html").read()

# Determine which done tasks are visible (newest-first, capped)
def sort_key(t):
    return t.get("completed_at") or t.get("started_at") or t.get("created_at") or ""

done_tasks    = sorted([t for t in tasks if t.get("wip_column") == "done"], key=sort_key, reverse=True)
visible_done  = set(t["id"] for t in (done_tasks[:cap] if cap else done_tasks))
non_done      = [t for t in tasks if t.get("wip_column") != "done"]

expected = [t["id"] for t in non_done] + list(visible_done)
missing  = [tid for tid in expected if tid not in html]
if missing:
    print("Missing visible task IDs:", missing, file=sys.stderr)
    sys.exit(1)
PYEOF
  local rc=$?
  rm -f /tmp/board-test-ids.html
  [ $rc -eq 0 ]
}

@test "i4: archived Done cards (beyond done_visible_max) are absent from board HTML" {
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$REPO_ROOT/.kaizen/tasks.json" \
    --out /tmp/board-test-archive.html
  python3 - <<'PYEOF'
import json, sys

data  = json.loads(open("/home/jackyko/Projects/kaizen-spec/.kaizen/tasks.json").read())
cap   = data.get("done_visible_max")
if not cap:
    sys.exit(0)  # no cap configured — nothing to check

tasks = data["tasks"]
def sort_key(t):
    return t.get("completed_at") or t.get("started_at") or t.get("created_at") or ""

done_tasks = sorted([t for t in tasks if t.get("wip_column") == "done"], key=sort_key, reverse=True)
archived   = done_tasks[cap:]
html       = open("/tmp/board-test-archive.html").read()

present = [t["id"] for t in archived if t["id"] in html]
if present:
    print("Archived task IDs should not appear in board:", present, file=sys.stderr)
    sys.exit(1)
PYEOF
  local rc=$?
  rm -f /tmp/board-test-archive.html
  [ $rc -eq 0 ]
}

# ---------------------------------------------------------------------------
# j) CI docs workflow: no dead links in docs/ (local vitepress build check)
# ---------------------------------------------------------------------------

@test "j1: docs/.vitepress/config.mts exists (not config.ts — ESM fix)" {
  [ -f "$REPO_ROOT/docs/.vitepress/config.mts" ]
  [ ! -f "$REPO_ROOT/docs/.vitepress/config.ts" ]
}

@test "j2: docs/guide/getting-started.md contains no clickable localhost:5173 link (causes VitePress dead-link error)" {
  # Only Markdown link syntax [text](url) is checked by VitePress — plain text/backtick URLs are fine
  ! grep -qE "\[.*\]\(http://localhost" "$REPO_ROOT/docs/guide/getting-started.md"
}
# ---------------------------------------------------------------------------
# k) Skill: board card discipline — regressions for three bugs fixed today
#
# Bug 1: TRIVIAL tasks skipped board card creation entirely
# Bug 2: Phase 1 did not create a board card after spec commit
# Bug 3: board.html was hand-edited instead of generated by render script
# ---------------------------------------------------------------------------

@test "k1: skill TRIVIAL path instructs agent to update tasks.json before starting" {
  local skill="$REPO_ROOT/.claude/commands/kaizen-spec.md"
  # The TRIVIAL section must mention tasks.json (adding a card) — not just board.html
  local trivial_block
  trivial_block=$(sed -n '/^For TRIVIAL requests:/,/^Tell the user:/p' "$skill")
  echo "$trivial_block" | grep -q "tasks.json"
}

@test "k2: skill TRIVIAL path instructs agent to run render_board.py (not hand-edit board.html)" {
  local skill="$REPO_ROOT/.claude/commands/kaizen-spec.md"
  local trivial_block
  trivial_block=$(sed -n '/^For TRIVIAL requests:/,/^Tell the user:/p' "$skill")
  echo "$trivial_block" | grep -q "render_board.py"
}

@test "k3: skill Phase 1 creates board card immediately after spec commit (before Phase 2)" {
  local skill="$REPO_ROOT/.claude/commands/kaizen-spec.md"
  # Phase 1 section must mention tasks.json entry creation AND render_board.py
  # before the Phase 2 header appears
  local phase1_block
  phase1_block=$(sed -n '/^## Phase 1/,/^## Phase 2/p' "$skill")
  echo "$phase1_block" | grep -q "tasks.json"
  echo "$phase1_block" | grep -q "render_board.py"
}

@test "k4: skill Board Update Rules forbid direct edits to board.html" {
  local skill="$REPO_ROOT/.claude/commands/kaizen-spec.md"
  local rules_block
  rules_block=$(sed -n '/^## Board Update Rules/,/^---/p' "$skill")
  # Must contain the prohibition on direct edits
  echo "$rules_block" | grep -qi "never edit"
}

@test "k5: README.md contains no git clone instruction" {
  ! grep -q "git clone" "$REPO_ROOT/README.md"
}

@test "k6: docs/guide/getting-started.md contains no git clone instruction" {
  ! grep -q "git clone" "$REPO_ROOT/docs/guide/getting-started.md"
}
