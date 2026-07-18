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

## History

Extracted 2026-07-18 from the `psychquant-claude-plugins` umbrella marketplace (PsychQuant/psychquant-claude-plugins#116) into a standalone marketplace, so that other plugins can reference it as an optional cross-marketplace enhancement with a clean one-line install instruction. Version history (2.0.0–2.9.2) continues in [`plugins/perspective-writer/CHANGELOG.md`](plugins/perspective-writer/CHANGELOG.md).
