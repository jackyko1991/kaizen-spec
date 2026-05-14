#!/usr/bin/env python3
"""
Render .kaizen/board.html from tasks.json + templates/board.html.

Usage:
    python scripts/render_board.py
    python scripts/render_board.py --tasks path/to/tasks.json
    python scripts/render_board.py --out path/to/output.html

Single source of truth: tasks.json. The template provides shell/CSS/JS.
Agents must edit tasks.json, then run this script to update the board.
"""
import json
import re
import sys
from datetime import datetime, timezone
from html import escape
from pathlib import Path


REPO_ROOT = Path(__file__).parent.parent


def fmt_duration(seconds):
    if not seconds or seconds <= 0:
        return '—'
    s = int(seconds)
    if s < 60:
        return f'{s}s'
    if s < 3600:
        return f'{s // 60}m'
    return f'{s / 3600:.1f}h'


def sort_key(task):
    return (
        task.get('completed_at') or
        task.get('started_at') or
        task.get('created_at') or ''
    )


_TEST_DOT_CLASS = {'passing': 'test-passing', 'failing': 'test-failing', 'pending': 'test-pending'}
_TEST_DOT_LABEL = {'passing': 'Tests passing', 'failing': 'Tests failing', 'pending': 'Tests pending'}


def render_test_dot(test_status):
    cls = _TEST_DOT_CLASS.get(test_status or '')
    if not cls:
        return ''
    label = _TEST_DOT_LABEL[test_status]
    return f'<span class="test-dot {cls}" title="{label}"></span>'


def render_card(task):
    task_id     = escape(task['id'])
    title       = escape(task.get('title', ''))
    phase       = escape(task.get('phase', ''))
    desc        = escape(task.get('description', ''))
    blocked     = 'true' if task.get('status') == 'blocked' or task.get('blocked_reason') else 'false'
    created     = task.get('created_at', '') or ''
    started     = task.get('started_at', '') or ''
    completed   = task.get('completed_at', '') or ''
    ct          = fmt_duration(task.get('cycle_time_s'))
    lt          = fmt_duration(task.get('lead_time_s'))
    test_dot    = render_test_dot(task.get('test_status'))

    return (
        f'      <div class="kaizen-card" data-task-id="{task_id}" data-blocked="{blocked}"\n'
        f'           data-description="{desc}"\n'
        f'           data-created-at="{created}" data-started-at="{started}" data-completed-at="{completed}">\n'
        f'        <div class="card-id">{task_id}</div>\n'
        f'        <div class="fw-semibold">{title}</div>\n'
        f'        <div class="text-secondary card-phase">{phase}{test_dot}</div>\n'
        f'        <div class="card-times">\n'
        f'          <span class="ct" title="Cycle Time 週期時間">CT: {ct}</span>\n'
        f'          <span class="lt" title="Lead Time 交付周期">LT: {lt}</span>\n'
        f'        </div>\n'
        f'      </div>'
    )


def render_archive_stub(hidden_count):
    """Faded footer card shown when Done cards are capped."""
    return (
        f'      <div class="kaizen-card kaizen-card-archive" style="opacity:.45;cursor:default;font-size:.8rem;text-align:center;padding:.4rem">\n'
        f'        {hidden_count} older card{"s" if hidden_count != 1 else ""} archived — see tasks.json\n'
        f'      </div>'
    )


def inject_cards(html, col_status, tasks, done_max=None):
    """Replace <!-- cards injected here --> inside the column body for col_status."""
    visible = tasks
    hidden  = 0
    if col_status == 'done' and done_max and len(tasks) > done_max:
        visible = tasks[:done_max]
        hidden  = len(tasks) - done_max

    parts = [render_card(t) for t in visible]
    if hidden:
        parts.append(render_archive_stub(hidden))
    cards_html = '\n'.join(parts)
    pattern = (
        r'(<div[^>]+\bid="body-' + re.escape(col_status) + r'"[^>]*>)'
        r'[ \t]*\n?[ \t]*<!-- cards injected here -->[ \t]*\n?'
        r'([ \t]*</div>)'
    )
    replacement = r'\g<1>\n' + (cards_html + '\n' if cards_html else '') + r'\g<2>'
    result, n = re.subn(pattern, replacement, html)
    if n == 0:
        print(f'  WARNING: marker not found for column "{col_status}"', file=sys.stderr)
    return result


def parse_args():
    args = {'tasks': None, 'template': None, 'out': None}
    i = 1
    while i < len(sys.argv):
        if sys.argv[i] == '--tasks' and i + 1 < len(sys.argv):
            args['tasks'] = Path(sys.argv[i + 1]); i += 2
        elif sys.argv[i] == '--template' and i + 1 < len(sys.argv):
            args['template'] = Path(sys.argv[i + 1]); i += 2
        elif sys.argv[i] == '--out' and i + 1 < len(sys.argv):
            args['out'] = Path(sys.argv[i + 1]); i += 2
        else:
            i += 1
    return args


def main():
    args      = parse_args()
    tasks_path    = args['tasks']    or REPO_ROOT / '.kaizen' / 'tasks.json'
    template_path = args['template'] or REPO_ROOT / 'templates' / 'board.html'
    out_path      = args['out']      or REPO_ROOT / '.kaizen' / 'board.html'

    data     = json.loads(tasks_path.read_text())
    template = template_path.read_text()

    feature = data.get('feature', 'Development Board')
    now     = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')

    html = template.replace('{{FEATURE_NAME}}', feature).replace('{{LAST_UPDATED}}', now)

    # Group tasks by their kanban column, sort newest-first within each
    columns = ['backlog', 'in-progress', 'review', 'done']
    col_map = {c: [] for c in columns}
    for task in data.get('tasks', []):
        col = task.get('wip_column') or task.get('status') or 'backlog'
        if col not in col_map:
            col = 'backlog'
        col_map[col].append(task)

    for col in columns:
        col_map[col].sort(key=sort_key, reverse=True)

    done_max = data.get('done_visible_max')
    for col in columns:
        html = inject_cards(html, col, col_map[col], done_max=done_max if col == 'done' else None)

    # Atomic write
    tmp = out_path.with_name(out_path.name + '.tmp')
    tmp.write_text(html, encoding='utf-8')
    tmp.rename(out_path)

    counts = {c: len(col_map[c]) for c in columns}
    done_visible = min(counts['done'], done_max) if done_max else counts['done']
    done_hidden  = counts['done'] - done_visible
    print(f'Board rendered → {out_path}')
    print(f'  backlog={counts["backlog"]}  in-progress={counts["in-progress"]}  '
          f'review={counts["review"]}  done={done_visible} (+{done_hidden} archived)')


if __name__ == '__main__':
    main()
