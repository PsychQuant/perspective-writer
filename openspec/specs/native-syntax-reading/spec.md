# native-syntax-reading Specification

## Purpose

Before a draft is delivered, an independent reader that does not know where the sentences came from reads the delivered text as a native writer of its language would, and flags sentences whose word order is a calque of another language. The capability exists because authoring agents cannot see the source of their own sentence structure, and the earlier checks judge vocabulary and rhetoric but not word order.

## Requirements

### Requirement: Native-syntax read runs after polish and before presentation

The native-syntax read SHALL run in both Compose and Revise modes after the cross-model polish step and before the draft is presented to the user. It SHALL NOT depend on any trigger decision by a genre facet. The judging criterion SHALL be the syntax and word order of the language the delivered text is written in, not the language of the recipient's location.

#### Scenario: Compose reaches the presentation step

- **WHEN** a Compose run finishes the cross-model polish step
- **THEN** the native-syntax read runs on the polished text before the draft is presented

#### Scenario: Output language differs from recipient location

- **WHEN** a letter written in Traditional Chinese is addressed to a recipient abroad
- **THEN** the reader judges the text against Traditional Chinese word order

---
### Requirement: Reader is an independent agent with no access to drafting context

The reader SHALL be a subagent dispatched by the drafting agent, separate from the drafting agent's conversation. A second reading by the drafting agent within the same session SHALL NOT satisfy this requirement. The reader SHALL receive only the text to be read, the language tag of that text, and the checkpoint list for that language when one exists. The reader SHALL NOT receive drafts, source material in another language, the voice model, recipient context, or the user's instructions.

#### Scenario: Reader is dispatched

- **WHEN** the native-syntax read starts
- **THEN** the dispatched reader's input contains the text, the language tag, and the checkpoint list
- **AND** the input contains no earlier draft, no source text in another language, and no recipient context

#### Scenario: No checkpoint list exists for the output language

- **WHEN** the delivered text is in a language with no checkpoint list
- **THEN** the reader still runs and judges by native word order alone

---
### Requirement: Reader flags sentences and does not rewrite the draft

The reader SHALL return one entry per flagged sentence containing the verbatim sentence, the reason (a checkpoint name or native intuition with a one-sentence explanation), and one suggested native rewrite, or a single line stating that nothing is flagged. The reader SHALL NOT return a rewritten draft. The drafting agent SHALL decide per entry whether to adopt the suggestion, and an adopted rewrite SHALL pass the same anchored-span verification as the cross-model polish step; a rewrite that fails it SHALL NOT be adopted. The presentation SHALL state how many sentences were flagged and how many were adopted, and SHALL list each flag that was not adopted with its sentence and reason.

#### Scenario: Reader flags a calque

- **WHEN** the reader finds a sentence whose word order is a calque
- **THEN** the returned entry contains the verbatim sentence, a reason, and a suggested rewrite
- **AND** the draft text itself is unchanged until the drafting agent adopts a suggestion

##### Example: Sentential subject followed by 是…的

- **GIVEN** the text contains 「精確的 rank 不會上升是可以證明的，我用 Lean 4 檢查過；」 and the language tag is zh-Hant
- **WHEN** the reader reads the text
- **THEN** the sentence is flagged with the reason naming the sentential-subject-plus-是…的 checkpoint and a suggestion such as 「可以證明精確的 rank 不會上升，這點我用 Lean 4 檢查過；」

#### Scenario: Suggested rewrite alters an anchored span

- **WHEN** adopting a suggestion would change or remove an anchored span
- **THEN** the suggestion is not adopted
- **AND** the presentation lists it among the flags not adopted

---
### Requirement: Native-syntax read degrades to plain delivery and never blocks

When the reader cannot be dispatched, fails, times out, or returns output that does not match the entry format, the draft SHALL be delivered unchanged with one line stating that the native-syntax read did not run and why. The step SHALL NOT retry, SHALL NOT ask the user, and SHALL NOT block delivery.

#### Scenario: Reader cannot be dispatched

- **WHEN** no subagent can be dispatched for the native-syntax read
- **THEN** the draft is presented unchanged
- **AND** the presentation includes one line stating that the native-syntax read did not run and the reason

---
### Requirement: Revision rounds re-read changed sentences with one neighbor on each side

After each revision round in the present-and-iterate step, the native-syntax read SHALL run before the revised draft is presented. Sentences SHALL be split at sentence-final punctuation (。！？； and . ! ? followed by whitespace) and at line breaks. A changed sentence SHALL be any sentence in the new version that does not appear verbatim in the version last presented to the user. The read range SHALL be every changed sentence plus the sentence immediately before and after it in the new version, with overlapping ranges merged. On the first presentation there is no earlier version and the whole text SHALL be read.

#### Scenario: One sentence is added in a revision

- **WHEN** a revision adds one sentence to a paragraph and changes nothing else
- **THEN** the reader receives that sentence and its immediate neighbors
- **AND** no other paragraph is sent to the reader

##### Example: Read range for a revision

| Previous version | New version | Read range |
| ---------------- | ----------- | ---------- |
| A。B。C。D。 | A。B。X。C。D。 | B。X。C。 |
| A。B。C。D。 | A。B2。C。D2。 | A。B2。C。D2。 (two ranges merged) |
| (none, first presentation) | A。B。C。 | A。B。C。 |

---
### Requirement: Native-syntax read does not run in calibrate mode

The native-syntax read SHALL NOT run when the skill is invoked through the programmatic calibration entry. The published consumer contract SHALL list the Native-syntax Read section among the core sections that do not apply in that mode, SHALL state the reason, and SHALL state that drafts produced through calibration are not read for native syntax.

#### Scenario: Skill is invoked through the calibration entry

- **WHEN** the skill is invoked with a calibration request block
- **THEN** the native-syntax read does not run
- **AND** the returned content is the status header followed by the calibrated draft and nothing else

#### Scenario: A contract reader checks whether the native-syntax read applies

- **WHEN** someone implementing a consumer reads the published contract's section mapping
- **THEN** the Native-syntax Read section appears in the enumeration with its classification and reason

---
### Requirement: Checkpoint list is a starting point with counter-examples

Each language checkpoint list SHALL state at its top that it is a starting point for the reader and not a closed enumeration, and that the final criterion is whether a native writer of the language would write the sentence that way. The Traditional Chinese list SHALL contain the sentential-subject-plus-是…的 checkpoint with the #17 instance and its rewrite, a counter-example section of sentences the reader SHALL NOT flag, and the failure history that motivated the list.

#### Scenario: Reader encounters a counter-example

- **WHEN** the text contains a sentence listed in the counter-example section
- **THEN** the reader does not flag that sentence

##### Example: Counter-examples that are not flagged

| Sentence | Expected |
| -------- | -------- |
| 這些定點我只抽查了一部分，抽查到的都不吸引。 | not flagged |
| 所以我想到的是，不必每個維度各追一次階段的路線，而是改用這個共同的形狀。 | not flagged |
| 一般維度真正要補的，是後面三件。 | not flagged |
| 修正後的證明，以及原本那一步的反例，都已經用 Lean 4 檢查過。 | not flagged |
| 正好會被帶到這些定點上的起點也是例外。 | not flagged |
