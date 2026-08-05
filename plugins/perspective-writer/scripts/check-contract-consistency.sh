#!/usr/bin/env bash
# Assert that every skill agrees with the writing-rules resolution contract.
#
# The contract (references/rules-resolution.md) is prose read by a model, so nothing
# can verify that a skill *follows* it. What this checks is the layer below that: the
# skills all point at the same contract, none of them assembles a storage path of its
# own, and every section a skill cites actually exists.
#
# That layer is where the silent failure lives. When a write site and a read site
# address different locations, nothing errors — rules get written and never load, and
# the only symptom is that drafts stop sounding like the writer.
#
# Deliberately shape-agnostic: no assertion counts skills or names them. The skill set
# grew from four to five when the core/facet split landed and will grow again with each
# genre facet. Assertions about counts would break on every such change, and a check
# that cries wolf gets ignored — which is the same as not having one.
#
# Usage: check-contract-consistency.sh [repo-root]   (default: git toplevel, else cwd)
# Exit:  0 all assertions hold | 1 one or more failed | 2 usage / layout error

set -uo pipefail

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
PLUGIN="$ROOT/plugins/perspective-writer"
SKILLS="$PLUGIN/skills"
CONTRACT="$PLUGIN/references/rules-resolution.md"
README="$ROOT/README.md"

for required in "$SKILLS" "$CONTRACT" "$README"; do
  [ -e "$required" ] || { echo "✗ layout: missing $required" >&2; exit 2; }
done

# Files allowed to contain storage-path literals. The contract defines the paths, and
# the migration script operates on them; every other mention is an inline construction.
ALLOWLIST_RE='references/rules-resolution\.md|scripts/migrate-rules\.sh|scripts/check-contract-consistency\.sh'

LEGACY_PATH='\.claude/rules/correspondence'
NS_PATH='\.perspective-writer/(subjects|genres)'

fail=0
note() { printf '  %s\n' "$1"; }
bad()  { printf '✗ %s\n' "$1"; fail=1; }
ok()   { printf '✓ %s\n' "$1"; }

# --- 1. No skill constructs the legacy path ---------------------------------
hits=$(grep -rlE "$LEGACY_PATH" "$SKILLS" 2>/dev/null | grep -vE "$ALLOWLIST_RE" || true)
if [ -n "$hits" ]; then
  bad "a skill constructs the legacy storage path inline:"
  printf '%s\n' "$hits" | sed "s|^$ROOT/|    |"
  note "resolve/persist are defined in the contract — cite them instead of a path."
else
  ok "no skill constructs the legacy storage path"
fi

# --- 2. No skill constructs the namespace path ------------------------------
hits=$(grep -rlE "$NS_PATH" "$SKILLS" 2>/dev/null | grep -vE "$ALLOWLIST_RE" || true)
if [ -n "$hits" ]; then
  bad "a skill constructs the namespace storage path inline:"
  printf '%s\n' "$hits" | sed "s|^$ROOT/|    |"
else
  ok "no skill constructs the namespace storage path"
fi

# --- 3. Every cited contract section exists ---------------------------------
# Sections are the contract's own `## ` headings. A skill cites one by naming it on a
# line that also references the contract file, or in an italicised *Section name* near
# such a reference. Compare the cited set against the defined set.
SECTIONS=$(grep '^## ' "$CONTRACT" | sed 's/^## //')
missing=""
while IFS= read -r skill; do
  grep -q 'rules-resolution' "$skill" || continue          # skill does not use the contract
  while IFS= read -r cited; do
    printf '%s\n' "$SECTIONS" | grep -qxF "$cited" || missing="$missing\n    $(basename "$(dirname "$skill")") → $cited"
  done < <(grep -oE '\*[A-Z][A-Za-z ,'"'"'-]+\*' "$skill" \
            | tr -d '*' \
            | while IFS= read -r c; do printf '%s\n' "$SECTIONS" | grep -qxF "$c" && printf '%s\n' "$c"; done \
            | sort -u)
done < <(find "$SKILLS" -name SKILL.md)
if [ -n "$missing" ]; then
  bad "a skill cites a contract section that does not exist:"; printf "$missing\n"
else
  ok "every contract section cited by a skill exists"
fi

# --- 4. Reader-based split criterion still names its exceptions -------------
# The two categories with no read site in this plugin must stay in the injected rules
# directory, and the contract must say so with the reason. Losing this text is how the
# criterion degrades into folklore.
split_ok=1
for needed in 'Split criterion by reader' 'code-comment writing style' 'general writing style' 'no skill in this plugin reads them'; do
  grep -qF "$needed" "$CONTRACT" || { bad "contract no longer states: $needed"; split_ok=0; }
done
# Local flag, not the global one: an earlier assertion's failure must not suppress this
# assertion's result. A checker whose output makes a passing check look like a skipped
# one is a checker people stop trusting.
[ "$split_ok" -eq 1 ] && ok "split criterion and its named exceptions are intact"

# --- 5. Published contract names the three outcome statuses ----------------
for st in 'subject-specific' 'legacy' 'generic'; do
  grep -qF "\`$st\`" "$README" || bad "README does not name outcome status: $st"
done
grep -qF 'subject-specific' "$README" && grep -qF 'generic' "$README" && ok "README names the outcome statuses"

echo
if [ "$fail" -eq 0 ]; then
  echo "contract consistency: OK"
else
  echo "contract consistency: FAILED — a write site and a read site may now disagree."
  echo "This failure mode is silent at runtime: rules get written and never load, and"
  echo "the only symptom is drafts that stop sounding like the writer."
fi
exit "$fail"
