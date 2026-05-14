# Test Strategy: /export command for Python CLI

**Framework:** pytest (with click.testing.CliRunner for CLI invocation)
**Install:** pip install pytest
**Test files:** tests/test_export.py
**Tests written:** 8
**Status:** All failing (red) ✓

## Test List

1. `test_export_json_stdout` — Running `export` with no options returns valid JSON to stdout
2. `test_export_csv_stdout` — Running `export --format csv` returns well-formed CSV to stdout
3. `test_export_json_to_file` — Running `export -o output.json` writes valid JSON to the specified file
4. `test_export_csv_to_file` — Running `export --format csv -o output.csv` writes valid CSV to the specified file
5. `test_export_empty_data_exits_nonzero` — When the SQLite table is empty, the command exits with a non-zero exit code and prints an informative error message
6. `test_export_json_structure` — The exported JSON is a list of objects with keys matching the DB column names
7. `test_export_csv_header_row` — The exported CSV has a header row matching the DB column names
8. `test_export_unwritable_path_exits_nonzero` — Running `export -o /nonexistent/dir/file.json` exits non-zero with an error message

## Run command
```
pytest tests/test_export.py -v
```

## Notes
- playwright-python is not required: this is a pure CLI feature with no browser interaction.
  pytest + CliRunner is the appropriate choice.
- All 8 tests were confirmed failing before any implementation was written.
