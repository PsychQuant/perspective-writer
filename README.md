# perspective-writer

Write letters, emails, autobiographies, and formal documents by simulating the writer's authentic voice — not writing *about* the writer, writing *as* the writer.

Core discipline: **Tarski's T-Schema**. Every sentence must have a concrete, verifiable referent. "Extensive experience in statistical modeling" fails; "my dissertation required proving identifiability conditions for polychoric models" passes. AI writing feels hollow because it produces grammatically correct sentences that satisfy no T-schema — this plugin reconstructs referents from the writer's materials before writing a single claim.

## Skills

| Skill | Purpose |
|-------|---------|
| `perspective-writer` | Main 6-phase drafting flow: understand writer → understand recipient → simulate → write → anti-pattern check → iterate |
| `role-calibrator` | Adjust correspondence tone per expertise domain (the writer may be junior in one domain, the expert in another) |
| `draft-learner` | Learn style rules from file-modification diffs during drafting sessions → persist to `.claude/rules/` |
| `save-feedback` | Capture conversational feedback ("短一點" / "太直接了") into reusable rules — the feedback that never produces a file diff |

Per-recipient style rules live in the **target repo's** `.claude/rules/correspondence-*.md`, not in this plugin — relationship context stays with the project it belongs to.

## Install

```bash
claude plugin marketplace add PsychQuant/perspective-writer
claude plugin install perspective-writer@perspective-writer
```

## EXTERNAL-CONSUMER CONTRACT (STABLE since 2.11.0, #1)

Other plugins may invoke perspective-writer programmatically to calibrate an already-anchored draft for a human recipient. The first consumer is issue-driven-dev's `idd-comment --type=reply` (soft integration, graceful degrade — see PsychQuant/issue-driven-development#269/#272). This section is the contract's single source; consumers pin `MIN_PW_CONTRACT=2.11.0`.

**Presence probe**: `check-plugin-presence.sh perspective-writer perspective-writer` (marketplace name + plugin name; cache path `~/.claude/plugins/cache/perspective-writer/perspective-writer/<ver>/`).

**Entry**: `Skill(skill="perspective-writer:perspective-writer")` with a structured request block in the args:

```
CALIBRATE-DRAFT REQUEST
- draft: <the full anchored draft text>
- recipient: <resolved GitHub login or person name>
- recipient-rules: <path to the target repo's .claude/rules/correspondence-<person>.md, if it exists>
- frozen-anchors: verbatim blockquotes, commit SHAs / PR refs, file / theorem / symbol references
- context: <one line — what this draft is (e.g. point-by-point review reply on issue #N)>
```

**Behavior promises**:

1. **Single-pass, unattended-friendly.** A calibrate-draft request maps onto the 6-phase flow with Phase 1 (writer interview) skipped and Phase 2 fed by `recipient-rules`; the skill does not pause to interview. When `recipient-rules` is absent, calibration falls back to a conservative generic register and the reply notes that person-level calibration did not run.
2. **Frozen anchors are immutable.** Calibration adjusts tone, register, and connective prose only. It SHALL NOT alter verbatim quoted text, commit SHAs, PR references, or file / theorem / symbol references — the consumer's referent anchoring survives byte-identical (the T-Schema discipline, mirrored for consumers).
3. **Return shape.** The skill's final message is the calibrated draft text itself — full body, no wrapper narration, no in-place file edits.
4. **No new claims.** Calibration never adds factual claims the draft did not carry (the Fabrication Trap rules apply unchanged).

Version note: generation bumps that change this contract update this section plus a CHANGELOG entry; consumers detect the floor by cache version ≥ 2.11.0.

## History

Extracted 2026-07-18 from the `psychquant-claude-plugins` umbrella marketplace (PsychQuant/psychquant-claude-plugins#116) into a standalone marketplace, so that other plugins can reference it as an optional cross-marketplace enhancement with a clean one-line install instruction. Version history (2.0.0–2.9.2) continues in [`plugins/perspective-writer/CHANGELOG.md`](plugins/perspective-writer/CHANGELOG.md).
