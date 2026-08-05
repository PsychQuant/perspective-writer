# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> ⚠ This file was bootstrapped by `changelog-tools:changelog-init` from the
> `plugin.json` description field. Section categorization is best-effort —
> review and refine `Added` / `Changed` / `Fixed` etc. as needed.

## [Unreleased]

## [4.0.0] - 2026-08-05

### Changed

- **BREAKING — the writing skill is now a core plus genre facets.** Everything that does
  not vary with genre stays in `perspective-writer`; correspondence conventions move to a
  new `perspective-writer-email` facet. A genre other than correspondence now has somewhere
  to put its own conventions instead of inheriting letter rules or getting no structure.
- **The core keeps its name.** A downstream consumer hardcodes both the invocation and the
  presence probe, and its integration degrades gracefully — renaming would have broken the
  entry with no error, replies posting uncalibrated and nothing saying so. "Core" is a role
  here, not a suffix.
- **The facet is loaded by the core's body, not by its own trigger.** There is no skill
  inheritance mechanism in this harness; linking is prose. Making completeness depend on two
  independent semantic triggers would double the chance of drafting with half the rules, and
  that failure is silent. The core determines the genre in Phase 0a and instructs the load —
  the same shape the rules-resolution step already uses.
- **The published calibration contract now names sections instead of phase numbers**, so the
  mapping survives this and any future reordering. The calibration entry itself is unchanged.
- The anti-pattern checklist was split row by row, not moved as a block: 16 genre-independent
  rows stay in the core, 2 correspondence rows move to the facet. Moving it wholesale would
  either strip the core of its general checks or leave letter rules embedded in it.

### Notes

- **Trade-off accepted: completeness is now compositional.** Before, one trigger guaranteed a
  letter had everything it needed. Now it needs the core plus one loaded facet. Loading by
  instruction rather than by trigger is the strongest available mitigation, but it is an
  instruction, not a gate — a reader that skips it produces a genre-independent draft. The
  guarantee is weaker than it was; that is the price of letting other genres exist.
- Only the correspondence facet ships. Other genres have nothing to move yet, and an empty
  facet would be shape without substance.


## [3.1.0] - 2026-08-05

### Changed

- **Consumer degradation-disclosure obligations raised from SHOULD to SHALL.** The
  contract defined a degradation signal (`status=generic`) and then left consuming it
  optional. For a failure whose output looks normal — a generic-register draft reads
  fine and is not distinguishable from a calibrated one by inspection — SHOULD reads as
  permission to skip, and a signal nobody is required to consume has defined nothing.
- Reading the status header is now stated as an obligation in its own right, not as an
  implication of the disclosure clause. A consumer that never reads the header cannot
  disclose anything and would otherwise have no stated requirement it visibly fails.

### Added

- The conditions that produce `status=generic` are now enumerated in the consumer
  contract, so a consumer can turn its disclosure into an actionable message rather than
  a generic warning. The list **points at** the *Outcome statuses* section of
  `references/rules-resolution.md` rather than restating the semantics, so the two cannot
  drift as the resolution order gains sources.

### Notes

- **No existing consumer breaks.** A consumer that does not read the status header keeps
  working exactly as before; it is merely now out of compliance. The change alters the
  normative basis, not any observed behavior — hence a minor bump, not a major one.
- Downstream implementation of the disclosure is tracked in the consumer's own
  repository, not here. This release supplies the normative backing that request cites.


## [3.0.0] - 2026-08-05

### Changed

- **BREAKING — writing rules now live behind a named resolution contract.** Where a
  subject's rules are stored, how a skill finds them, and what it must disclose are
  defined once in `references/rules-resolution.md`. All four skills cite that document
  instead of constructing paths of their own; previously each assembled its own path
  and the README described a location without describing how to resolve it.
- **BREAKING — per-subject rules move out of the injected project rules directory.**
  A subject now has a directory holding a genre-independent `core.md` plus on-demand
  genre facets, under a dot-prefixed namespace that is not injected into session
  context. Rules were previously a single file per recipient in a directory whose
  entire contents reach every session regardless of task.
- **BREAKING — external consumer contract v2.** The `recipient-rules` field now refers
  to a resolved location rather than a single file, and the three outcome statuses
  (`subject-specific` / `legacy` / `generic`) are named. Consumers that reconstruct the
  canonical location themselves must follow the resolution order. `MIN_PW_CONTRACT`
  moves to `3.0.0`.
- Rules split by **who reads them**, not by how narrowly they apply. Categories this
  plugin reads move into the namespace; code-comment style and general writing style
  stay in the injected directory, because no skill here reads them and injection is
  their only delivery mechanism. Moving those would remove their only reader silently.

### Added

- `references/rules-resolution.md` — the resolution contract: storage layout,
  resolution order, outcome statuses, dual-location conflict, composition precedence,
  split criterion, and the load gate.
- Load gate: drafting is refused when no resolution was performed. The gate binds to
  the lookup not having run, not to the rules file being absent, so genuine first
  contact remains a normal path — disclosed, not blocked.
- Skill-packaged subject rules recognised as a **current** arrangement, not a legacy
  one. A workspace may package a subject's rules as `.claude/skills/correspondence-<subject>/`;
  resolution treats it as that subject's core and returns `subject-specific`, so the
  load gate does not falsely disclose "no existing rules". One skill per genre for the
  same subject is a core-and-facet split expressed with skill boundaries, not a conflict.
- `scripts/migrate-rules.sh` — idempotent one-time migration. Converts each legacy
  rules file into a subject `core.md` and leaves a redirect placeholder at the legacy
  path so a consumer's existence check keeps passing. Creates no facets.

### Notes

- Legacy locations remain readable; an unmigrated workspace keeps working and is told
  migration is available. Migration is reversible.
- Known residual: a resolution run against an incorrect location returns `generic` and
  is indistinguishable from genuine first contact. The load gate narrows the failure
  space; it does not close this gap.


## [2.11.0] - 2026-07-19

### Added

- **EXTERNAL-CONSUMER CONTRACT (STABLE) — programmatic calibrate-draft entry (#1)** — other plugins can now invoke `perspective-writer:perspective-writer` with a structured `CALIBRATE-DRAFT REQUEST` block to calibrate an already-anchored draft for a human recipient (first consumer: issue-driven-dev `idd-comment --type=reply`, soft integration with graceful degrade). Contract single source = README "EXTERNAL-CONSUMER CONTRACT" section; consumers pin `MIN_PW_CONTRACT=2.11.0`. Phase mapping: Phase 1 skipped (no interview), Phase 2 fed by the consumer's `recipient-rules` path (absent → conservative generic register + explicit note), Phase 4 runs as a Revise pass over the provided draft, Phase 5 anti-pattern check unchanged, Phases 6/6b/7 skipped (single pass, unattended-friendly). HARD RULE: `frozen-anchors` (verbatim blockquotes, commit SHAs / PR refs, file / theorem / symbol references) survive byte-identical — calibration touches tone, register, and connective prose only, and never adds claims (Fabrication Trap rules unchanged). Return shape: the final message is the calibrated draft text itself — no wrapper narration, no file edits.

## [2.10.0] - 2026-07-18

### Changed
- **Extracted to standalone repo + marketplace [`PsychQuant/perspective-writer`](https://github.com/PsychQuant/perspective-writer)** (from the `psychquant-claude-plugins` umbrella; PsychQuant/psychquant-claude-plugins#116, motivated by PsychQuant/issue-driven-development#269 soft-integration). Install now via `claude plugin marketplace add PsychQuant/perspective-writer` + `claude plugin install perspective-writer@perspective-writer`. No skill content changes.

## [2.9.0] - 2026-07-09

### Added
- **Fabrication Trap — third failure mode: asserting unverified external facts.** Beyond (1) embellishing the writer's experience and (2) writing claims the user cannot defend, a sentence can point to a real external referent yet still be *wrong*: a paper's citation (journal/volume/pages/DOI), a person's current title, a law's name and date, an institution's official name, a statistic. The writer's memory — or a slide/transcript/draft source — can be off (a misremembered volume, an outdated title, a rounded-up statistic), and a recipient who knows the real figure stops trusting the whole letter. Fix: verify every external fact against an authoritative source (the journal's page, the institution's site, the government record) before it goes in; when memory or the draft source disagrees with the authoritative source, **the source wins**. Adds a third question to "The test". Real trigger: a meeting record drafted from an ASR transcript + presentation slides carried a spoken "gap ≈ 10 years" against the official 8.17→6.19, wrote "CRP" for the official "CRB", and cited a *Nature* paper whose volume/pages needed checking against the journal page — all caught only by web-verifying the external facts.

## [2.8.0] - 2026-05-20

### Added
- **Mode: Compose vs. Revise section** (#86): the skill now explicitly distinguishes drafting a new letter from iteratively revising an existing draft. Revise mode does not skip Phase 1-2 (the understanding phases where prior correspondence gets read). Real-world trigger: a host-inquiry letter was iteratively revised across many rounds while Phase 1-3 was silently skipped every round — the recipient's verbatim "If you contact me in a year" was softened into "at a later point" with no archive re-read, and downstream judgments built on the erased timeline drifted unrecoverably.
- **Phase 5 anti-pattern row — English sincerity-intensifier adverbs**: `sincerely`, `deeply`, `truly`, `genuinely`, `wholeheartedly`, `really`, `very much` modifying verbs of gratitude / hope / appreciation. Native English correspondence carries sincerity in the verb structure, not in adverbs; stacking intensifiers ("I deeply appreciate", "I sincerely hope") reads as ESL or AI. Fix is almost always deletion. `Sincerely yours` at sign-off is the one fixed-slot exception.
- **Mode-independent rule**: whenever prior correspondence with the recipient exists, reading it (Phase 1-2) is mandatory — covers the in-between case (reply to an incoming message when no draft yet exists).

### Changed
- **Phase 0 TaskList** (#86): `phase1_understand_writer` and `phase2_understand_recipient` task descriptions now explicitly require reading the recipient's archived correspondence, not merely asking whether it exists.
- **Phase 1 "Sources to check"** (#86): the recipient's prior-correspondence archive is no longer an "ask which are available" item; it is a mandatory-read-if-it-exists item. Other sources (blog / CV / etc.) remain ask-which.
- **Phase 2 paraphrasing rule** (#86): paraphrasing the recipient is now an explicit T-schema referent. Distinguishes "softening the tentativeness of a polite refusal" (allowed — keep `may be able to consider` tentative) from "erasing factual guidance" (not allowed — a concrete time / condition / instruction the recipient gave is a referent, not bookkeeping to be loosened away). Erasing one and every downstream judgment drifts silently — invisibly, because the reworded sentence still reads fine.
- **Phase 6b** (#86): cross-references the new Mode section. Each user edit begins another Revise pass; re-anchor to prior correspondence before reworking the draft again.
- **Span label correction** (#86 verify): the reading claim now says "Phase 1-2" (where prior correspondence actually gets read) rather than "Phase 1-3" (Phase 3 is Simulate and reads nothing). The "understanding phases" label is kept for the Phase 1-3 block as a whole.

## [2.7.0] - 2026-05-15

### Added
- **Phase 1 temporal anchors**: explicit questions for today's date, writer's lifecycle stage (onboarding week N / post-acceptance / mid-sabbatical etc.), and last contact/event with the recipient. Required before writing any time-relative phrasing ("recently", "前幾天", "上週", "last month"). Real-world trigger: AI defaulted to "陳老師前幾天提到..." when the actual conversation was 1 week earlier at a specific named meeting (storyline 會議, 2026-05-08). Recipient's memory of the event would not match "前幾天" → instant AI-generation tell.

### Changed
- **Golden Rule (T-schema)**: time phrasing now explicitly listed as a referent. Words like "recently / 前幾天 / 上週" must be anchored to a specific date verified with the writer, not guessed by the AI. Anchored phrasing ("5/8 在 storyline 會議時") carries the same warmth without the AI smell.
- **Phase 5 anti-pattern checklist**: added row for "vague temporal phrasing without verified anchor". Fix is to ask the writer for the specific date and replace with anchored form.

## [2.6.0] - 2026-05-07

### Added
- New `save-feedback` skill (#28): captures **conversational feedback** that user gives mid-draft into reusable rules. Complements `draft-learner` (which only triggers on file-modification system-reminders). Real-world gap: when user gives verbal tone/style/relationship/structure feedback in conversation and agent rewrites the file each round, no file diff is produced → draft-learner never fires → feedback evaporates at session end. `save-feedback` fills that gap with explicit invocation (`/perspective-writer:save-feedback`) or proactive trigger phrases ("存 feedback" / "把這些建議記下來"). 6-step workflow (scan conversation → classify → extract concrete rules with **Why** field → locate `.claude/rules/` file → write → confirm). Distinct from draft-learner per a side-by-side comparison table in the SKILL.md.

## [2.5.0] - (date unknown — please fill in)

### Changed
- Write letters, emails, autobiographies, and formal documents by simulating the writer's authentic voice.
- Uses Tarski's T-Schema to ensure every sentence has a concrete referent, and a 6-phase process (understand writer, understand recipient, simulate, write, anti-pattern check, iterate) to produce writing that sounds like a real person, not AI
