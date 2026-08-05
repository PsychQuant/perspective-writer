# Writing-Rules Resolution Contract

This document is the single source for where writing rules live, how a skill finds
them, and what a skill must do with what it finds. Every skill in this plugin that
reads or persists writing rules cites a section of this document instead of
constructing a path of its own.

Two operations are defined:

- **resolve** — given a subject and a genre, return an ordered list of existing
  rule files plus an outcome status.
- **persist** — given a subject and a genre, return the single file a newly
  learned rule should be written to.

A skill names the operation it performs and cites the relevant section here. A
skill does not assemble a directory path, a filename, or a glob pattern inline.

## Storage layout

Rules this plugin reads live under a dot-prefixed namespace inside the
workspace's Claude configuration directory. Dot-prefixed namespace directories
are not injected into session context; they are read on demand.

```
.claude/.perspective-writer/
  subjects/
    <subject-slug>/
      core.md          # required whenever the subject directory exists
      <genre-slug>.md  # zero or more genre facets, created on demand
  genres/
    <genre-slug>.md    # subject-independent genre conventions
```

**core** carries everything about a subject that does not vary with genre: tone
calibration, word preferences, relationship position, fact fixpoints, and red
lines. **A facet** carries what that one genre needs: structure, conventions,
formatting obligations.

A subject that writes in only one genre has a core file and no facet. Nothing
forces a split. Facets appear when a second genre first arises.

A subject directory that exists but contains no core file is malformed. Resolve
reports it as malformed rather than treating the subject as unresolved — the
distinction matters, because "no rules for this subject" and "this subject's
rules are broken" call for different responses.

Slugs are kebab-case. A subject slug identifies a person or party; a genre slug
identifies a document kind (`email`, `proposal`, and others as they arise).

## Resolution order

Resolve returns files **least-specific first**, so that a later file's general
conventions override an earlier file's:

1. `genres/<genre>.md` — the subject-independent convention for this genre, when present.
2. `subjects/<subject>/core.md` — the subject's cross-genre layer, when the subject directory is present.
3. `subjects/<subject>/<genre>.md` — the subject's facet for this genre, when present.

When step 2 finds no subject directory, resolve consults the legacy location for
that subject before concluding. See **Legacy location remains readable**.

Example with all three levels present:

| Position | File | Overrides |
| -------- | ---- | --------- |
| 1 | genre convention | nothing |
| 2 | subject core | genre convention |
| 3 | subject facet | subject core, genre convention |

With only a core file and no genre convention or facet, resolve returns a
single-element list.

## Outcome statuses

Resolve returns exactly one of three statuses:

| Status | Meaning | Disclosure obligation |
| ------ | ------- | --------------------- |
| **subject-specific** | The subject's core file was found at the current location. | none |
| **legacy** | Resolution succeeded through the legacy location or a redirect placeholder. | name the location used; offer migration |
| **generic** | No subject file was found at the current location or the legacy location. | state that this subject has no existing rules |

A skill receiving a status other than subject-specific discloses it to the user
**before** presenting a draft. The disclosure is not waived because the draft
reads well — a draft produced without a subject's rules can read perfectly and
still not sound like the writer, which is precisely why the absence has to be
stated rather than inferred from the output.

## Dual-location conflict

When rules for the same subject exist at both the current location and the legacy
location — and the legacy file is real content, not a redirect placeholder —
resolve uses the current location and **reports the conflict**.

Choosing either side silently is prohibited. A half-migrated workspace is a state
the user needs to know about; picking a winner without saying so converts a
visible inconsistency into an invisible one.

## Composition precedence

A facet **may** override the general conventions its subject's core states.

A facet **may not** override the honesty boundaries its subject's core states —
the claims marked as red lines, the fact fixpoints, the limits on what may be
asserted on the writer's behalf.

Every facet file states this precedence in its header. There is no interpreter
for these files; the precedence is prose because prose is what reads them.

## Named resolution contract

The contract is this document. A skill cites the section it depends on:

| Skill need | Operation | Section to cite |
| ---------- | --------- | --------------- |
| read a subject's rules before drafting | resolve | Resolution order, Outcome statuses |
| write a newly learned rule for a subject | persist | Storage layout, Split criterion by reader |
| locate rules to rewrite | resolve | Resolution order, Dual-location conflict |

`persist` targets `subjects/<subject>/core.md` when the rule does not vary with
genre, and `subjects/<subject>/<genre>.md` when it does. A rule with no subject —
a convention that belongs to the genre rather than to a party — targets
`genres/<genre>.md`.

## Split criterion by reader

**A writing rule belongs in this plugin's namespace when a skill in this plugin
reads it. It belongs in the injected project rules directory when no skill reads
it and it functions by being injected into general session context.**

The criterion is which reader consumes the rule, not how narrowly the rule
applies. Those two criteria disagree, and they disagree exactly where the
consequences are worst.

Categories and their placement:

| Rule category | Read by a skill in this plugin | Placement |
| ------------- | ------------------------------ | --------- |
| per-subject correspondence rules | yes | plugin namespace |
| document-type genre conventions | yes | plugin namespace |
| code-comment writing style | **no** | injected project rules directory |
| general writing style | **no** | injected project rules directory |

**Code-comment writing style and general writing style stay in the injected
project rules directory because no skill in this plugin reads them.** They are
written by the diff-learner and consumed by general session activity through
injection. Moving them into this namespace would remove their only delivery
mechanism: nothing would ever fetch them, the discipline would stop applying, and
no error would be raised.

The failure modes are asymmetric:

- Moving a general-discipline rule into the namespace produces **no error and no
  attributable output change**. The rule simply stops arriving.
- Leaving a party-specific rule in the injected directory merely continues an
  already-tolerated context cost.

**When the criterion is ambiguous for a rule, the rule stays in the injected
project rules directory.** The safe direction is the one whose failure is visible.

## Load gate

A skill that drafts must have performed a resolve for the subject and genre it is
drafting for, and must have recorded the resulting outcome status.

**Drafting without a recorded resolution outcome is refused**, and the refusal
names the lookup that was not performed.

The gate is conditioned on the lookup having run, **not** on the rules file
existing. Binding refusal to file absence would block genuine first contact —
writing to a subject for the first time, when no rules could exist — which is a
normal path, not a failure. A resolve that ran and returned `generic` proceeds.

## Load gate does not close the wrong-path gap

A resolve performed against an incorrect location returns `generic`, and that
outcome is **indistinguishable from genuine first contact**. Both disclose the
same thing: this subject has no existing rules.

This is a known residual, not a solved case. The load gate narrows the failure
space — a skipped lookup is now a hard refusal rather than a silent default — but
it does not detect a lookup that ran against the wrong place. Closing that gap
requires observability at the consumer boundary, which is out of scope here.

Do not read the load gate as restoring the guarantee that injection provided.
Injection guaranteed the rules were present before drafting could begin. The gate
approximates that; it does not reproduce it.

## Legacy location remains readable

Before this contract, per-subject correspondence rules lived at
`.claude/rules/correspondence-<subject>.md`. Resolve consults that location for a
subject when no subject directory exists in the namespace.

A workspace that has not migrated continues to resolve its existing rules, with
the `legacy` outcome status and an offer to migrate. Upgrading the plugin does
not break an unmigrated workspace.

## Redirect placeholder is followed once

A file at the legacy location whose content is a redirect placeholder resolves to
the location the placeholder names, and is **followed exactly once**. A
placeholder naming a subject directory that does not exist is reported as
unresolved; resolve does not follow any further redirect.

Placeholder form — a single line naming the subject directory:

```
<!-- pw:redirect subjects/<subject-slug>/ -->
```

The placeholder exists so that an external consumer which tests for the legacy
path before handing it over continues to find that path present after migration.
See the consumer-contract section of the repository README.

## Migration is reversible

To reverse a migration:

1. For each redirect placeholder at a legacy path, replace the placeholder's
   content with the content of the corresponding `subjects/<subject>/core.md`.
2. Remove the subject directory.

Because legacy consultation is retained, a reversed workspace continues to
resolve — the rules are found at the legacy location and the outcome status is
`legacy`.

Migration itself is performed by the migration script shipped with this plugin.
The script creates subject directories with core files, replaces legacy files
with placeholders, and creates no facets: separating genre-specific content out
of a migrated core file is a judgment made when a second genre for that subject
first arises, and the script cannot make it.
