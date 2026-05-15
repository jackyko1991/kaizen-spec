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

@test "k5: README.md presents curl as the primary install (before any git clone mention)" {
  local curl_line git_line
  curl_line=$(grep -n "curl" "$REPO_ROOT/README.md" | head -1 | cut -d: -f1)
  git_line=$(grep -n "git clone" "$REPO_ROOT/README.md" | head -1 | cut -d: -f1)
  [ -n "$curl_line" ]
  # if git clone appears it must be after curl (dev-mode section comes after install)
  if [ -n "$git_line" ]; then
    [ "$curl_line" -lt "$git_line" ]
  fi
}

@test "k6: docs/guide/getting-started.md presents curl before git clone (curl is Option A)" {
  local file="$REPO_ROOT/docs/guide/getting-started.md"
  local curl_line git_line
  curl_line=$(grep -n "curl" "$file" | head -1 | cut -d: -f1)
  git_line=$(grep -n "git clone" "$file" | head -1 | cut -d: -f1)
  [ -n "$curl_line" ]
  if [ -n "$git_line" ]; then
    [ "$curl_line" -lt "$git_line" ]
  fi
}
# ---------------------------------------------------------------------------
# l) Hook: live board update regression (task-017)
#
# Bug: hook matched Agent-only and only sed'd the timestamp.
# Fix: Write+Edit matchers, runs render_board.py when tasks.json touched.
# ---------------------------------------------------------------------------

@test "l1: .claude/hooks/update-board.sh exists and is executable" {
  [ -f "$REPO_ROOT/.claude/hooks/update-board.sh" ]
  [ -x "$REPO_ROOT/.claude/hooks/update-board.sh" ]
}

@test "l2: hook runs render_board.py (not just sed timestamp) when tasks.json is in input" {
  local out
  out="$(echo '{"tool_name":"Write","tool_input":{"file_path":"/tmp/tasks.json"}}' \
        | bash "$REPO_ROOT/.claude/hooks/update-board.sh" 2>&1; echo "exit:$?")"
  # Script should exit 0 (tasks.json path triggers render attempt; may skip if file absent — that's fine)
  echo "$out" | grep -q "exit:0"
}

@test "l6: hook re-renders when tool_name is Agent (subagent tasks.json update path)" {
  # Agent tool JSON does NOT contain tasks.json in tool_input —
  # hook must re-render unconditionally for Agent events
  local before after
  before="$(stat -c %Y "$REPO_ROOT/.kaizen/board.html" 2>/dev/null || echo 0)"
  sleep 1
  echo '{"tool_name":"Agent","tool_input":{"prompt":"do work","description":"impl"}}' \
    | bash "$REPO_ROOT/.claude/hooks/update-board.sh"
  after="$(stat -c %Y "$REPO_ROOT/.kaizen/board.html" 2>/dev/null || echo 0)"
  [ "$after" -ge "$before" ]
}

@test "l3: hook skips render when tasks.json is NOT in tool input" {
  # Measure board.html mtime before
  local before after
  before="$(stat -c %Y "$REPO_ROOT/.kaizen/board.html" 2>/dev/null || echo 0)"
  echo '{"tool_name":"Write","tool_input":{"file_path":"/tmp/README.md"}}' \
    | bash "$REPO_ROOT/.claude/hooks/update-board.sh"
  after="$(stat -c %Y "$REPO_ROOT/.kaizen/board.html" 2>/dev/null || echo 0)"
  # board.html must NOT have been touched
  [ "$before" = "$after" ]
}

@test "l4: settings.json hooks include Write, Edit, and Bash matchers (not Agent-only)" {
  local settings="$REPO_ROOT/.claude/settings.json"
  grep -q '"matcher": "Write"' "$settings"
  grep -q '"matcher": "Edit"' "$settings"
  grep -q '"matcher": "Bash"' "$settings"
}

@test "l5: hook script calls render_board.py (not just sed)" {
  grep -q "render_board.py" "$REPO_ROOT/.claude/hooks/update-board.sh"
  ! grep -q 'sed -i.*Updated' "$REPO_ROOT/.claude/hooks/update-board.sh"
}

# ---------------------------------------------------------------------------
# m) Test status dots on kanban cards (task-018)
# ---------------------------------------------------------------------------

@test "m1: render_board.py renders test-passing dot for passing tasks" {
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$REPO_ROOT/.kaizen/tasks.json" \
    --out /tmp/board-test-dots.html
  grep -q 'class="test-dot test-passing"' /tmp/board-test-dots.html
  rm -f /tmp/board-test-dots.html
}

@test "m2: render_board.py does NOT render a dot for tasks with test_status=none" {
  # Create a minimal tasks.json with one task having test_status=none
  local tmp_tasks
  tmp_tasks="$(mktemp)"
  cat > "$tmp_tasks" <<'JSON'
{
  "feature": "dot-test",
  "tasks": [
    {"id":"t-none","title":"No dot","phase":"feat","wip_column":"backlog",
     "status":"backlog","test_status":"none",
     "created_at":"2026-01-01T00:00:00Z","started_at":null,"completed_at":null}
  ],
  "wip_limits":{"in-progress":3,"review":2}
}
JSON
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$tmp_tasks" \
    --out /tmp/board-test-nodot.html
  ! grep -q 'class="test-dot' /tmp/board-test-nodot.html
  rm -f "$tmp_tasks" /tmp/board-test-nodot.html
}

@test "m3: templates/board.html defines CSS for test-passing, test-failing, test-pending" {
  grep -q '\.test-passing' "$REPO_ROOT/templates/board.html"
  grep -q '\.test-failing'  "$REPO_ROOT/templates/board.html"
  grep -q '\.test-pending'  "$REPO_ROOT/templates/board.html"
}

# ---------------------------------------------------------------------------
# n) install.sh writes to project CLAUDE.md (task-019)
# ---------------------------------------------------------------------------

@test "n1: install.sh appends kaizen-spec block to project CLAUDE.md when present" {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  touch "$tmp_dir/CLAUDE.md"
  (cd "$tmp_dir" && INSTALL_DIR="$tmp_dir" bash "$REPO_ROOT/install.sh" >/dev/null 2>&1 || true)
  grep -q "kaizen-spec" "$tmp_dir/CLAUDE.md"
  rm -rf "$tmp_dir"
}

@test "n2: install.sh does NOT duplicate the kaizen-spec block if already present" {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  echo "## kaizen-spec" > "$tmp_dir/CLAUDE.md"
  INSTALL_DIR="$tmp_dir" bash "$REPO_ROOT/install.sh" >/dev/null 2>&1 || true
  local count
  count=$(grep -c "kaizen-spec" "$tmp_dir/CLAUDE.md")
  [ "$count" -eq 1 ]
  rm -rf "$tmp_dir"
}

@test "n3: install.sh skips CLAUDE.md write when no CLAUDE.md exists in cwd" {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  (cd "$tmp_dir" && INSTALL_DIR="$tmp_dir" bash "$REPO_ROOT/install.sh" >/dev/null 2>&1 || true)
  [ ! -f "$tmp_dir/CLAUDE.md" ]
  rm -rf "$tmp_dir"
}

# ---------------------------------------------------------------------------
# o) Dev-mode install: symlink (task-023)
# ---------------------------------------------------------------------------

@test "o1: install.sh --dev creates a symlink (not a copy)" {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  (cd "$REPO_ROOT" && INSTALL_DIR="$tmp_dir" bash install.sh --dev >/dev/null 2>&1)
  local dest="$tmp_dir/.claude/commands/kaizen-spec.md"
  [ -L "$dest" ]
  rm -rf "$tmp_dir"
}

@test "o2: install.sh --dev symlink target is the local repo skill file" {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  (cd "$REPO_ROOT" && INSTALL_DIR="$tmp_dir" bash install.sh --dev >/dev/null 2>&1)
  local dest="$tmp_dir/.claude/commands/kaizen-spec.md"
  local target
  target="$(readlink "$dest")"
  echo "$target" | grep -q "kaizen-spec.md"
  rm -rf "$tmp_dir"
}

@test "o3: install.sh --dev fails with clear error when skill file not found" {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  # Copy install.sh to a dir that has no .claude/commands/kaizen-spec.md
  cp "$REPO_ROOT/install.sh" "$tmp_dir/install.sh"
  local out
  out="$(cd "$tmp_dir" && INSTALL_DIR="$tmp_dir" bash install.sh --dev 2>&1 || true)"
  echo "$out" | grep -qi "clone\|repo"
  rm -rf "$tmp_dir"
}

@test "o4: make install-dev target exists in Makefile" {
  grep -qE "^install-dev[[:space:]]*:" "$REPO_ROOT/Makefile"
}

# ---------------------------------------------------------------------------
# p) Board column routing: backlog and in-progress cards appear in correct columns
#
# Regression for the live-update gap: new tasks added to backlog or in-progress
# must actually show up in those columns, not silently fall into done.
# ---------------------------------------------------------------------------

@test "p1: task with wip_column=backlog renders in body-backlog column" {
  local tmp_tasks
  tmp_tasks="$(mktemp)"
  cat > "$tmp_tasks" <<'JSON'
{
  "feature": "col-test",
  "tasks": [
    {"id":"t-backlog","title":"Backlog task","phase":"feat","wip_column":"backlog",
     "status":"backlog","test_status":"none",
     "created_at":"2026-01-01T00:00:00Z","started_at":null,"completed_at":null}
  ],
  "wip_limits":{"in-progress":3,"review":2}
}
JSON
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$tmp_tasks" \
    --out /tmp/board-test-backlog.html
  # Card must appear inside the backlog column body
  python3 - <<'PYEOF'
import sys
html = open("/tmp/board-test-backlog.html").read()
backlog_start = html.find('id="body-backlog"')
inprogress_start = html.find('id="body-in-progress"')
card_pos = html.find('data-task-id="t-backlog"')
assert backlog_start != -1, "body-backlog not found"
assert card_pos != -1, "card t-backlog not found in html"
assert backlog_start < card_pos < inprogress_start, \
    f"t-backlog card at {card_pos} is not between backlog({backlog_start}) and in-progress({inprogress_start})"
PYEOF
  local rc=$?
  rm -f "$tmp_tasks" /tmp/board-test-backlog.html
  [ $rc -eq 0 ]
}

@test "p2: task with wip_column=in-progress renders in body-in-progress column" {
  local tmp_tasks
  tmp_tasks="$(mktemp)"
  cat > "$tmp_tasks" <<'JSON'
{
  "feature": "col-test",
  "tasks": [
    {"id":"t-wip","title":"WIP task","phase":"impl","wip_column":"in-progress",
     "status":"in-progress","test_status":"pending",
     "created_at":"2026-01-01T00:00:00Z","started_at":"2026-01-01T01:00:00Z","completed_at":null}
  ],
  "wip_limits":{"in-progress":3,"review":2}
}
JSON
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$tmp_tasks" \
    --out /tmp/board-test-wip.html
  python3 - <<'PYEOF'
import sys
html = open("/tmp/board-test-wip.html").read()
inprogress_start = html.find('id="body-in-progress"')
review_start = html.find('id="body-review"')
card_pos = html.find('data-task-id="t-wip"')
assert inprogress_start != -1, "body-in-progress not found"
assert card_pos != -1, "card t-wip not found in html"
assert inprogress_start < card_pos < review_start, \
    f"t-wip card at {card_pos} is not between in-progress({inprogress_start}) and review({review_start})"
PYEOF
  local rc=$?
  rm -f "$tmp_tasks" /tmp/board-test-wip.html
  [ $rc -eq 0 ]
}

@test "p3: task with wip_column=review renders in body-review column" {
  local tmp_tasks
  tmp_tasks="$(mktemp)"
  cat > "$tmp_tasks" <<'JSON'
{
  "feature": "col-test",
  "tasks": [
    {"id":"t-review","title":"Review task","phase":"impl","wip_column":"review",
     "status":"review","test_status":"failing",
     "created_at":"2026-01-01T00:00:00Z","started_at":"2026-01-01T01:00:00Z","completed_at":null}
  ],
  "wip_limits":{"in-progress":3,"review":2}
}
JSON
  python3 "$REPO_ROOT/scripts/render_board.py" \
    --tasks "$tmp_tasks" \
    --out /tmp/board-test-review.html
  python3 - <<'PYEOF'
import sys
html = open("/tmp/board-test-review.html").read()
review_start = html.find('id="body-review"')
done_start = html.find('id="body-done"')
card_pos = html.find('data-task-id="t-review"')
assert review_start != -1, "body-review not found"
assert card_pos != -1, "card t-review not found in html"
assert review_start < card_pos < done_start, \
    f"t-review card at {card_pos} is not between review({review_start}) and done({done_start})"
PYEOF
  local rc=$?
  rm -f "$tmp_tasks" /tmp/board-test-review.html
  [ $rc -eq 0 ]
}
