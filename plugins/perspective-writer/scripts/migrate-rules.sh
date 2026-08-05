#!/usr/bin/env bash
# Migrate legacy per-subject correspondence rules into the plugin namespace.
#
#   legacy:  <workspace>/.claude/rules/correspondence-<subject>.md
#   current: <workspace>/.claude/.perspective-writer/subjects/<subject>/core.md
#
# Each migrated legacy file is replaced by a one-line redirect placeholder so that
# an external consumer which tests for the legacy path before handing it over keeps
# finding that path present. See references/rules-resolution.md, sections
# "Redirect placeholder is followed once" and "Migration is reversible".
#
# Idempotent: a legacy path already holding a placeholder is left untouched, and an
# existing subject directory is never overwritten.
#
# Creates no facets. Separating genre-specific content out of a migrated core file
# is a judgment made when a second genre for that subject first arises, and this
# script cannot make it.
#
# Usage: migrate-rules.sh [workspace-root]     (default: current directory)

set -euo pipefail

ROOT="${1:-.}"
LEGACY_DIR="$ROOT/.claude/rules"
NS_DIR="$ROOT/.claude/.perspective-writer"
SUBJECTS_DIR="$NS_DIR/subjects"

[ -d "$LEGACY_DIR" ] || { echo "No legacy rules directory at $LEGACY_DIR — nothing to migrate."; exit 0; }

migrated=0; skipped=0; kept=0

for f in "$LEGACY_DIR"/correspondence-*.md; do
  [ -e "$f" ] || continue          # glob did not match

  base=$(basename "$f" .md)
  subject="${base#correspondence-}"
  [ -n "$subject" ] || { echo "  ! skipping $f — empty subject slug"; skipped=$((skipped+1)); continue; }

  # Already a placeholder → idempotent no-op.
  if grep -q '^<!-- pw:redirect ' "$f" 2>/dev/null; then
    echo "  = $base already migrated (placeholder present)"
    kept=$((kept+1))
    continue
  fi

  target_dir="$SUBJECTS_DIR/$subject"
  target="$target_dir/core.md"

  # Never overwrite an existing subject directory's core file.
  if [ -f "$target" ]; then
    echo "  ! $base has content at BOTH locations — leaving legacy file untouched."
    echo "    Current location wins at resolve time; reconcile by hand, then re-run."
    skipped=$((skipped+1))
    continue
  fi

  mkdir -p "$target_dir"
  cp "$f" "$target"
  printf '<!-- pw:redirect subjects/%s/ -->\n' "$subject" > "$f"
  echo "  + $subject → subjects/$subject/core.md (legacy path now a placeholder)"
  migrated=$((migrated+1))
done

echo
echo "migrated: $migrated | already migrated: $kept | skipped: $skipped"

if [ "$migrated" -gt 0 ]; then
  cat <<'EOF'

No facet files were created. When a subject's rules later need genre-specific
content, split it out of that subject's core.md into a facet at that time.

To reverse: replace each placeholder with the content of the corresponding
subjects/<subject>/core.md and remove the subject directory. Legacy consultation
is retained, so a reversed workspace continues to resolve.
EOF
fi
