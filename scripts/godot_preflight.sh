#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT_DIR"

if command -v godot >/dev/null 2>&1; then
    GODOT_BIN=$(command -v godot)
elif command -v godot4 >/dev/null 2>&1; then
    GODOT_BIN=$(command -v godot4)
else
    echo "ERROR: Godot CLI not found. Install/enable Godot 4 and ensure godot or godot4 is on PATH." >&2
    exit 127
fi

echo "== Godot executable =="
echo "$GODOT_BIN"
"$GODOT_BIN" --version

echo
echo "== Headless editor/import check =="
"$GODOT_BIN" --headless --path "$ROOT_DIR/prototype_v2" --editor --quit

echo
echo "== Runtime smoke test =="
"$GODOT_BIN" --headless --path "$ROOT_DIR/prototype_v2" --quit-after 2

echo
echo "Godot preflight completed. Review the output above for warnings/errors."
