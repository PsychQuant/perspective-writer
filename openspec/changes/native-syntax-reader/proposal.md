## Why

perspective-writer 目前沒有任何一關檢查產出是否符合「產出本身所用語言」的語序。PsychQuant/perspective-writer#17 的實例：一封中文學術回信裡出現「精確的 rank 不會上升是可以證明的，我用 Lean 4 檢查過」，是把英文「子句當主語＋is provable」直譯成中文。這句是在 Phase 6 修改時才加入的，從沒經過任何檢查；而且就算經過，Phase 5a 的清單抄自英文 field guide，也沒有一項可以對照。

## What Changes

- 在 core 新增 **Phase 5e：語序讀者**，排在 Phase 5d 之後、Phase 6 呈現之前。Compose 與 Revise 一律執行，沒有觸發開關。
- 5e 派出一個**同家族的獨立 subagent**當讀者。讀者只拿到三樣東西：最終文字、它的語言標記、該語言的起點清單。它拿不到草稿、英文來源、聲音模型或收件人脈絡。
- 讀者**只標記、不改稿**：逐句列出不順的句子、不順的原因、母語的改寫建議。是否採用由起草的 agent 決定，採用時仍受 Phase 5d frozen span 的約束。
- 降級：派不出讀者時照常交付，並附一行說明語序檢查未執行。任何情況都不阻斷交付。
- **Phase 6 修改輪**：每輪修改後，只對「新增或改動的句子」加上前後各一句重跑讀者，不整封重讀。「改動句」的定義寫在本 change，供 #19 沿用。
- **calibrate 模式不執行 5e**。README 的 EXTERNAL-CONSUMER CONTRACT 把這一節加進「不適用」的具名列舉；這是範圍說明，不改變 consumer 已依賴的任何行為。
- 新增繁體中文起點清單：第一條是「整個子句當主語，再接『是…的』」並附 #17 實例；另列使用者判為可接受的四句作為反例，防止讀者過度標記。清單明寫是檢查起點，不是封閉列舉，最終判準是母語寫作者會不會這樣寫。
- Phase 0 的 TaskCreate 清單加一項 `phase5e_native_syntax_read`；README 的 Pre-send review 表加一列並補一段說明；版本 4.6.0 → 4.7.0。

## Capabilities

### New Capabilities

- `native-syntax-reading`: 交付前由不知道句子來源的獨立讀者，依產出語言的母語語序逐句標記直譯句構；含輸入限制、只標記不改稿、降級、修改輪重讀範圍與 calibrate 模式排除。

### Modified Capabilities

(none)

## Impact

- Affected specs: `native-syntax-reading`（新）
- Affected code:
  - New: plugins/perspective-writer/skills/perspective-writer/references/zh-Hant-syntax-checkpoints.md
  - Modified: plugins/perspective-writer/skills/perspective-writer/SKILL.md
  - Modified: README.md
  - Modified: plugins/perspective-writer/CHANGELOG.md
  - Modified: plugins/perspective-writer/.claude-plugin/plugin.json
  - Modified: .claude-plugin/marketplace.json
