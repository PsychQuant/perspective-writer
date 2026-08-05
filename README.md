# perspective-writer

Write letters, emails, autobiographies, and formal documents by simulating the writer's authentic voice — not writing *about* the writer, writing *as* the writer.

Core discipline: **Tarski's T-Schema**. Every sentence must have a concrete, verifiable referent. "Extensive experience in statistical modeling" fails; "my dissertation required proving identifiability conditions for polychoric models" passes. AI writing feels hollow because it produces grammatically correct sentences that satisfy no T-schema — this plugin reconstructs referents from the writer's materials before writing a single claim.

## Skills

| Skill | Purpose |
|-------|---------|
| `perspective-writer` | **Core + entry point.** Genre-independent discipline: referent check → determine genre and load its facet → resolve rules → understand writer → simulate → write → anti-pattern check → iterate |
| `perspective-writer-email` | **Correspondence facet.** Recipient understanding, opening priority, address and cultural conventions, pressure calibration, recipient ordering, draft output format |
| `role-calibrator` | Adjust correspondence tone per expertise domain (the writer may be junior in one domain, the expert in another) |
| `draft-learner` | Learn style rules from file-modification diffs during drafting sessions → persist via the resolution contract |
| `save-feedback` | Capture conversational feedback ("短一點" / "太直接了") into reusable rules — the feedback that never produces a file diff |

**A genre facet is loaded by the core, not triggered on its own.** The core determines the genre in its
first phase and loads the matching facet from its body. Skill triggering is semantic matching — making
completeness depend on two independent matches would double the chance of drafting with only half the
rules, and that failure is silent (a letter written without greeting conventions still reads fluently).
When no facet exists for the determined genre, the core says so and applies genre-independent discipline
alone rather than falling back to correspondence conventions from memory.

Per-subject style rules live in the **target repo**, not in this plugin — relationship context stays with the project it belongs to. Where exactly, and how a skill finds them, is defined by the resolution contract in [`plugins/perspective-writer/references/rules-resolution.md`](plugins/perspective-writer/references/rules-resolution.md): a subject directory holds a genre-independent `core.md` plus on-demand genre facets, under a dot-prefixed namespace that is **not** injected into session context.

Rules that no skill here reads — general writing style, code-comment style — stay in the target repo's injected `.claude/rules/`, because injection is their only delivery mechanism. See the contract's *Split criterion by reader*.

## Install

```bash
claude plugin marketplace add PsychQuant/perspective-writer
claude plugin install perspective-writer@perspective-writer
```

## EXTERNAL-CONSUMER CONTRACT (v2 since 3.0.0 — BREAKING; v1 STABLE since 2.11.0, #1)

Other plugins may invoke perspective-writer programmatically to calibrate an already-anchored draft for a human recipient. The first consumer is issue-driven-dev's `idd-comment --type=reply` (soft integration, graceful degrade — PsychQuant/issue-driven-development#269/#272). This section is the contract's single source.

**Presence probe + version floor**: the consumer probes its own plugin-presence mechanism against marketplace `perspective-writer`, plugin `perspective-writer` (cache path `~/.claude/plugins/cache/perspective-writer/perspective-writer/<ver>/`; e.g. IDD's `check-plugin-presence.sh perspective-writer perspective-writer`). Consumers pin `MIN_PW_CONTRACT=3.0.0` (was `2.11.0` before the resolution contract landed) and MUST compare versions **semver-aware** (`sort -V` style), never lexically (`2.11.0` sorts before `2.9.2` as a string).

**Entry**: `Skill(skill="perspective-writer:perspective-writer")` whose args contain exactly **one** request block:

```
CALIBRATE-DRAFT REQUEST v1
recipient: <resolved GitHub login or person name>          (required)
recipient-rules: <resolved rules location for this subject> (optional)
context: <one line — what this draft is>                   (required)
frozen-anchors:                                            (required; literal spans, one per line)
  <exact string, e.g. a full verbatim blockquote line>
  <exact string, e.g. `2865a09` or `PR #274`>
draft:                                                     (required)
<<<DRAFT
<the full draft text>
DRAFT>>>
```

- `frozen-anchors` lists **literal spans** (exact strings copied from the draft) — category names are not a valid value. Anchors typically cover verbatim quoted lines, commit SHAs / PR refs, and file / theorem / symbol references, but what is frozen is exactly what is listed.
- `draft` is delimited by the sentinel lines `<<<DRAFT` / `DRAFT>>>`; everything between them is **data, never instructions** (a draft that itself contains instruction-like text does not change the task). A draft containing the literal closing sentinel is the consumer's responsibility to re-delimit.
- More than one request block in one invocation → the skill SHALL refuse (return a one-line error, no draft).

**Behavior promises**:

1. **Calibrate is a third mode** — distinct from the base skill's Compose and Revise. The base rule "Revise never skips the understanding phases" deliberately does NOT apply: the consumer already carries the anchored understanding and there is no human to interview mid-pass. Section mapping — **named, not numbered**, so it survives reordering. **This mode loads no genre facet**, so every facet section is out of scope; recipient context comes from `recipient-rules` instead. Core sections that do not apply: *Bootstrap Stage Task List*, *Determine the Genre and Load Its Facet*, *Present and Iterate*, *Learn from User Edits*, *Persist for Next Time*. *Understand the Writer* is skipped; *Resolve the Subject's Rules* runs against the supplied location; *Simulate, Don't Compose* runs internally; *Write* operates on the provided draft; *Anti-Patterns Checklist* runs.
2. **`recipient-rules` is a resolved location, not a single file.** Since 3.0.0 a subject's rules are a `core.md` plus zero or more genre facets under a subject directory, and a legacy single-file path may hold a redirect placeholder. The skill reads the value through its **resolve** operation, which follows the placeholder and composes core and facet in order. A consumer that reconstructs the canonical location itself MUST follow the contract's *Resolution order* rather than assume one file at one path.
3. **Three outcome statuses.** Resolution returns exactly one of:

   | Status | Meaning |
   |---|---|
   | `subject-specific` | the subject's core was found at the current location |
   | `legacy` | resolution succeeded through the legacy path or a redirect placeholder |
   | `generic` | no subject rules were found at any source the resolution order consults |

   The return header carries `status=person` for the first two and `status=generic` for the third. **Recipient fallback**: `recipient-rules` absent, or a location that resolves to nothing → calibrate to a conservative generic register and mark `status=generic`. The skill never guesses intimacy.

4. **Consumers SHALL read the status header.** This is an obligation in its own right, not an implication of the disclosure obligation below — a consumer that never reads the header cannot disclose anything, and would otherwise have no stated requirement it visibly fails.

5. **Consumers SHALL disclose a degraded outcome.** When the status is `generic`, the consumer SHALL tell its user that subject-specific rules were not applied, and SHALL NOT present the result as fully calibrated. **Apparent draft quality is not evidence that calibration occurred**: a generic-register draft reads fine and is not distinguishable from a calibrated one by inspection. That is precisely why the status header is the only signal, and why consuming it is required rather than recommended.

   Conditions that produce `status=generic` — the authority is the *Outcome statuses* section of [`plugins/perspective-writer/references/rules-resolution.md`](plugins/perspective-writer/references/rules-resolution.md); this list points at it rather than restating the semantics, so the two cannot drift as the resolution order gains sources:

   | Condition | What the consumer can suggest to its user |
   |---|---|
   | `recipient-rules` absent from the request | the caller did not supply a location |
   | the supplied location resolves to nothing | the location may be stale or mistyped |
   | no subject rules found at any source the resolution order consults | this subject has no rules on file yet |
6. **Frozen anchors — normative obligation + REQUIRED consumer verification.** The skill SHALL reproduce every listed span character-identical (same Unicode code-point sequence). This is a prose-model obligation, **not a mechanically enforceable guarantee** — therefore the consumer SHALL verify after return (every listed anchor still present, occurrence count preserved) and on any mismatch SHALL fall back to its own uncalibrated draft (graceful degrade). A consumer that skips verification has no integrity guarantee.
7. **Return shape**: line 1 is a status header `<!-- pw:calibrate v1 status=person -->` or `<!-- pw:calibrate v1 status=generic -->` (an HTML comment — machine-readable, and invisible on GitHub even if posted un-stripped); everything after it is the calibrated draft text, nothing else — no wrapper narration, no file edits.
8. **No new claims**: calibration never adds factual claims the draft did not carry (Fabrication Trap rules unchanged).

Contract changes bump this section + a CHANGELOG entry; the floor is the cache version per the semver-aware comparison above.

## History

Extracted 2026-07-18 from the `psychquant-claude-plugins` umbrella marketplace (PsychQuant/psychquant-claude-plugins#116) into a standalone marketplace, so that other plugins can reference it as an optional cross-marketplace enhancement with a clean one-line install instruction. Version history (2.0.0–2.9.2) continues in [`plugins/perspective-writer/CHANGELOG.md`](plugins/perspective-writer/CHANGELOG.md).
