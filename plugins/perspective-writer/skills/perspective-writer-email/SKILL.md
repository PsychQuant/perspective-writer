---
name: perspective-writer-email
description: >
  Correspondence facet for perspective-writer — the greeting, structure, pressure-calibration and
  output conventions specific to letters, emails, and replies. Loaded by the perspective-writer core
  during its bootstrap phase once the genre is determined; it is not a standalone answer to "write me
  a letter". Invoke directly by name only when you already have the core loaded and want just this
  genre's conventions.
---

# Perspective Writer — Correspondence Facet

> **繼承 `perspective-writer`（core）。使用本檔前必須先載入 core。**
> 本檔為**增補**，不重述 core 的內容：指涉紀律（T-schema）、捏造陷阱、理解寫作者、模擬、
> 呈現與迭代、規則解析與 load gate 全部在 core，此處不再複製。
>
> **覆蓋優先序**：本 facet 可覆蓋 core 的**一般慣例**，但**不得違背** core 的**誠實邊界**——
> 指涉紀律、捏造陷阱、以及任何「不可宣稱」的限制。與 `references/rules-resolution.md`
> *Composition precedence* 一節同一條規則。

## Phase 2: Understand the Recipient

Research who the recipient is and what the relationship looks like from the writer's side.

**Gather:**
- The recipient's position, research area, recent work
- The power dynamic (professor you've never met? someone who knows your advisor? a peer?)
- Cultural context (Taiwanese academic norms? Japanese? Western?)
- Any prior interaction between the writer and recipient — **read the actual archived messages, both sides, verbatim**

**Paraphrasing the recipient is a referent (T-schema).** When the letter restates something the recipient said, check that restatement against the recipient's actual words. Two distinct moves — do not conflate them:

- *Softening the tentativeness of a polite refusal* is allowed: "we may be able to consider" need not harden into "you will consider."
- *Erasing factual guidance the recipient gave* is not allowed: a concrete time ("in a year"), a condition, an instruction — these are referents, not bookkeeping to be loosened away. Drop one and every downstream judgment that rested on it (how early is "early", whether an apology is warranted, whether a deadline was missed) drifts silently — invisibly, because the reworded sentence still reads fine.

**Then ask yourself (and write down the answers before drafting):**
- What does this person probably care about when reading this letter?
- How many similar letters do they probably receive?
- What would make them stop and actually read carefully?
- What would make them think "this person is real" vs "this was generated"?

## Phase 4 增補：書信格律

**The #1 rule: Lead with WHY, not WHO (前置動機).**

The reader's first question is always "why am I receiving this?" — never "who is this person?"
The first sentence of any correspondence must answer WHY before WHO.

- BAD: "I am Che Cheng, I got my PhD from NTU... I am writing to apply for..."
  (Reader still doesn't know why you're writing to THEM specifically)
- GOOD: "I attended your keynote at IASC-ARS 2025 and am writing to apply for..."
  (Immediately answers: you're not spam, you have a specific reason)

For replies: the first sentence should respond to the other person's last message, not start
with your own agenda. ("Thank you for your reply. The earlier email didn't arrive..." — not
"I would like to update you on my plans...")

WHO (credentials, background) goes later in the email, compressed. The CV is attached.

**What real people do that AI doesn't:**
- Mention specific things about the recipient's work that actually connect to their situation
  (not a literature review, but "I read your paper on X, and it's relevant to a problem I'm facing")
- Express genuine motivation, not manufactured enthusiasm
- Leave some things unsaid. Not every qualification needs to be listed. Trust that the CV is attached.
- Be slightly imperfect. Real emails have personality.

**Cultural calibration (Taiwanese academic context):**
- Opening: use full name + title for first address (e.g., "程毅豪老師您好"), then "老師" afterward
- Don't address someone by full name repeatedly in the body (feels distant, like reading about a stranger)
- Closing: simple and warm, not stiff. "謝謝老師" is fine. "感謝老師撥冗審閱" is borderline robotic.
- The email itself serves as the cover letter. Don't repeat what's in the attached autobiography.

**Cultural calibration (Japanese academic context):**
- Leave space for the recipient to not respond, not commit, not feel obligated.
- Use softeners like "if by any chance" or "if it is convenient" before any request or proposal.
- If the recipient gave a vague timeline (e.g., "at least until 2027"), do NOT pin it down in your reply
  (e.g., "closer to 2027" feels like pressure). Use "in the future" or "when the time is right" instead.
- Japanese professors value indirectness. A sentence that says "I am available anytime" is less pressure
  than "I will contact you in January 2027."
- When the recipient has declined or delayed, your reply should convey understanding and zero urgency.
  The relationship is more important than the immediate opportunity.

**Pressure calibration (applies to all correspondence):**

After drafting, re-read every sentence and ask: **"How much social pressure does this sentence put on the
recipient?"** This is especially critical when:
- The recipient has already said no, or deferred
- There is a power asymmetry (you are junior)
- The cultural context values indirectness (Japanese, some Taiwanese formal contexts)

Common pressure traps:
- **Pinning down vague timelines.** If they said "maybe next year," don't reply with a specific month.
- **Listing specific ways you can help.** The more specific, the more it implies they should say yes.
  "I would be delighted to help" (open) vs "I could collect data, run analyses, and coordinate with
  your lab" (feels like you're already planning to move in).
- **Eagerness overflow.** The right word choice matters:

| Too eager (pressure) | Appropriate | Low-key |
|---------------------|-------------|---------|
| enthusiastic | delighted | happy |
| eager | glad | grateful |
| passionate about | interested in | appreciate |
| I can't wait to | I look forward to | I hope to |
| as soon as possible | at your convenience | when the time is right |

- **The "less is more" principle for proposals.** When offering to help or proposing collaboration,
  one short sentence is less pressure than a detailed paragraph. Let the recipient ask for details
  if they are interested.

**Ordering as a status signal (multi-recipient / list-bearing correspondence):**

When a message arranges people or options — the To/CC order, a name roster, a list of candidate
time slots — the *order itself* is read as a status signal. Every listed person notices where they
sit. Put external guests, invited experts, and senior figures **near the front, never last**: a lone
outside guest trailing a block of in-house names reads as an afterthought or filler, even when the
writer meant nothing by it. Before sending, re-read the recipient order and any roster the way each
person would see their *own* placement, and reorder so no one is left feeling put at the back. This is
courtesy expressed through arrangement rather than words — especially load-bearing in hierarchical /
relational cultures (Taiwanese, Japanese, and most cross-institutional settings).

## Phase 5 增補：書信專屬的 anti-pattern

core 的 anti-pattern 表對所有文類適用，仍然照跑。以下兩列是**書信與草稿呈現專屬**的增補：

| Pattern | Why it's a problem | Fix |
|---------|-------------------|-----|
| Ending with "期盼" "期許" "展望" | Overly formal, sounds like a press release | End like a person: "謝謝老師" or "希望有機會跟老師聊聊" |
| Extra `---` / `***` hrules inside letter body | AI uses horizontal rules to segment emails into card-like sections. Humans don't—they use paragraph breaks. | Delete every hrule except the Phase 5b wrapper pair. One paragraph = one idea; adjacent paragraphs separated by blank lines, not hrules |

## Phase 5b: Output Format

**CRITICAL: Never use markdown blockquote (`>`) for email/letter drafts.**
Blockquotes render with a left border line in terminals and chat UIs, making the draft look like
a quoted reply rather than original text. The user will copy this text to send — it must be clean.

**Correct format**: Use a horizontal rule (`---`) before and after the draft to visually separate it.
Write the body as plain paragraphs with no `>` prefix. Lists (`-`) are fine for bullet points
within the email (e.g., available time slots).

```
---

Recipient greeting,

Body paragraph 1.

Body paragraph 2.
- Item 1
- Item 2

Signature

---
```

### Only TWO `---` allowed per draft (before + after). Zero internal hrules.

Common AI mistakes (all are AI signatures — real people don't do any of these):

- ❌ Adding `---` between body paragraphs as section dividers
- ❌ Adding `---` before the signature line
- ❌ Using `---` or `***` to separate "main content" from "postscript"
- ❌ Using `---` to replace a period or comma transition

If the draft needs to signal structural shift, let paragraphs do it: blank line between
two paragraphs is enough. If two topics feel like they need a hard divider between them,
they probably belong in **two separate messages**, not one email with hrules.

**When you present the draft, count your `---`. There should be exactly 2.** More than 2
means you've accidentally built a template aesthetic into what should feel like a personal
letter. Delete the extras before showing the user.

### The Adjacency Principle (generalizes beyond `---`)

The real AI tell isn't "too many dividers"—it's **two dividers appearing back-to-back**
with nothing meaningful between them. This generalizes beyond markdown hrules to any
formatted output:

| Medium | Adjacent-pair anti-pattern |
|--------|---------------------------|
| Markdown letter/email | `---` then blank line then another `---` (both wrapping something trivial) |
| Markdown with sections | `---` section divider immediately after a `## heading` line |
| HTML / PDF drafts | `border-bottom` on one section + `border-top` on the next section with only margin between |
| HTML / PDF tables | Last `.row { border-bottom }` soft + `.total { border-top }` strong = double line above total |
| HTML / PDF typography | `::after { background }` decorative rule after heading + next section's `border-top` |

**Fix pattern**: remove one side of the pair. Default: keep the semantically stronger/structural
line, drop the decorative one. For table footers specifically: `.row:has(+ .row.total) { border-bottom: none }`.

### Default bias: human-messier > AI-tidy

When in doubt, **cut the divider**. Real human writing is structurally messier than AI
output—paragraphs end, new paragraphs start, and the reader infers structure from the
writing itself. AI compulsively adds visual scaffolding (hrules, borders, ::before rules,
card wrappers) because it feels "organized." Humans don't care, and the pattern betrays
the generator.

Heuristic: if you can remove a divider (hrule, border, `::after`, wrapper) and the adjacent
content is still comprehensible, **remove it**. Your default should skew toward "too few
dividers" rather than "just enough." Err on the side of typography doing the work, not
visual bars.

This heuristic applies not just to `---` in markdown but to **every CSS border declaration**
when generating HTML/PDF drafts (DMs, proposals, reports). Count rendered horizontal lines
per page; pairs with nothing meaningful between them are the AI tell to fix.

## Phase 5c 增補：何時提示 ensemble 複核

core 的「Phase 5c: Ensemble Review (optional)」定義了偵測與降級語意，但把「何時觸發」留給文類決定。書信的判準如下。

**本節在 Phase 5b 之後執行** —— 複核的對象是**已完成格式整理、準備寄出的那一版**。對半成品跑複核會把格式雜訊當成問題回報。

### 判定順序（兩關，反例優先）

**第一關 —— 反例 gate。任一命中就不提示，直接結束本節：**

反例的判準是**這封信有沒有新增任何可據以行動的內容** —— 沒有，才算反例：

- 內部同事的隨手訊息（「資料放好了」「明天十點可以」）
- **逐字**轉發、代為傳話 —— 若你在轉發時加上自己的背書、承諾或指示，那是新增內容，**不算**反例
- **純收訖確認**（「收到，謝謝」）—— **不論收件人是誰**。但只限於「我收到了」；只要同時確認或承諾了金錢、期限、出席、授權、或任何對方能據以行動的事，就**不算**純收訖確認

這三類的共同點是**錯了改口的成本很低**，跑 ensemble 的成本高於它擋下的風險。

> **不能只看長度與形式**。「我確認接受出版條件，並同意支付新臺幣三萬元版面費」只有一句、形式上是確認回覆，但它承諾了金錢 —— 錯了改口的成本極高，因此**不是**反例。反例要捕捉的是「改口成本低」這個性質，不是「短」這個外形；用外形當代理指標，會在兩者分岔的地方失效。

**第二關 —— 觸發條件。通過第一關後，任一命中即提示：**

- **收件人是機構或不熟識的對象** —— 學會、行政單位、期刊編輯、初次往來的合作者。判準不是對方的職級，是**你們之間有沒有既有的往來節奏**：每週開會的同事不算，一年通兩次信的窗口算
- **內容涉及金錢、承諾、道歉、申請、或正式請求** —— 這幾類的共同點是**寄出後會被引用**。對方可能轉發、存檔、據以行動；寫錯的代價不是尷尬，是要另外發一封更難寫的信去更正

> **為什麼反例優先**：兩關的判準會重疊 —— 寄給期刊編輯的一句「收到，謝謝」同時命中反例三與觸發條件一。若不定序，同一封信會得到相反指令。反例勝，因為它描述的是**這封信的實際份量**，而觸發條件描述的只是**收件人與主題的類別**；份量小的信不會因為收件人正式就變得值得複核。

### 長度不是獨立的觸發條件

長信的每一段都是新的出錯機會，寫的人到後段也看不見前段的問題 —— 但**長度本身不構成觸發**。一封三千字的內部技術說明不因為長就需要對外書信的複核；「僅對外正式信」是本 gate 的邊界，長度不能繞過它。

長度的正確用法是**邊界情況的加權**，且權限有明確上限：

**長度不得把第二關的明確未命中改判為命中。** 它只能在某個觸發條件本身處於邊界時（例如「這個窗口算不算不熟識」拿不定主意）調整傾向 —— 長草稿偏向提示、短草稿偏向不提示。兩個條件都明確落空時，不論多長都不提示。

這條上限是刻意的：沒有它，「長度」會靠著「猶豫時偏向提示」悄悄變回第三個觸發條件，繞過剛剛才劃定的正式書信邊界。

> 判準寫在 facet 而非 core，因為「何謂正式信」是書信文類特有的。**本節只適用於準備寄出的正式書信**；其他文類不在本節範圍內。
