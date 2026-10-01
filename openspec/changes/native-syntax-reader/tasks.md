## 1. 起點清單

- [x] 1.1 新增 plugins/perspective-writer/skills/perspective-writer/references/zh-Hant-syntax-checkpoints.md，落實「起點清單不是封閉列舉並附反例」與 requirement「Checkpoint list is a starting point with counter-examples」：檔頭寫明清單是檢查起點、不是封閉列舉、最終判準是母語寫作者會不會這樣寫；第一條「整個子句當主語，再接『是…的』」附 #17 原句與改寫；反例一節列出五句不該標的句子；失敗史一節記錄 #17。驗證：人工檢查檔案含這四部分，且五句反例與 spec 的反例表逐字相同。

## 2. core skill：Phase 5e

- [x] 2.1 在 core perspective-writer skill 新增「Phase 5e: Native-syntax Read」一節，位於 Phase 5d 一節之後、Calibrate-draft entry 一節之前，落實「新 phase 編號為 5e 並排在 5d 之後」與 requirement「Native-syntax read runs after polish and before presentation」：寫明 Compose 與 Revise 一律執行、沒有 facet 開關、判準是產出本身所用語言而非收件人所在地。驗證：grep 找到該標題，且其位置介於 Phase 5d 與 Calibrate-draft entry 兩個標題之間。
- [x] 2.2 在 Phase 5e 一節寫出讀者派送與輸入，落實「讀者採同家族獨立 subagent」、「讀者輸入只給最終文字、語言標記與起點清單」與 requirement「Reader is an independent agent with no access to drafting context」：含一段可直接交給 subagent 的讀者指示，列出三樣輸入（文字、語言標記、起點清單）與五樣不得給的東西（草稿、其他語言的來源、聲音模型、收件人脈絡、使用者指示），並寫明沒有起點清單的語言照常執行、只憑母語語序判斷。驗證：人工通讀讀者指示，確認沒有任何一句要求附上草稿、來源或收件人脈絡，且無清單語言的處理已寫明。
- [x] 2.3 在 Phase 5e 一節寫出回傳格式與採納流程，落實「讀者只標記不改稿」與 requirement「Reader flags sentences and does not rewrite the draft」：每筆含原句、原因、建議三欄，沒有要標的回傳單獨一行「無」；起草 agent 逐筆決定是否採用，採用的改寫須通過 Phase 5d 的 frozen span 驗證，不通過就不採用；Phase 6 呈現時附標記數與採用數，並逐句列出未採用的標記。驗證：人工核對格式區塊與 design 的 Implementation Contract 所列格式逐字一致。
- [x] 2.4 在 Phase 5e 一節寫出降級，落實「降級時照常交付並附一行說明」與 requirement「Native-syntax read degrades to plain delivery and never blocks」：列出四種情形（派不出、失敗、逾時、回傳格式不符），皆照常交付並附一行「（語序檢查未執行：<原因>）」，不重試、不詢問、不阻斷。驗證：人工核對四種情形都列出，且說明行的格式與 design 一致。
- [x] 2.5 在 Phase 0 的 TaskCreate 清單加入 phase5e_native_syntax_read，描述概括 2.1 到 2.4 的四點，位置在 phase5d_cross_model_polish 與 phase6_present_and_iterate 之間；清單前後提到 phase 數量的文字一併更新。驗證：grep 找到 phase5e_native_syntax_read，且在清單中的順序正確。

## 3. core skill：Phase 6 修改輪

- [x] 3.1 在 Phase 6 一節加入修改輪規則，落實「修改輪只重讀改動句與前後各一句」與 requirement「Revision rounds re-read changed sentences with one neighbor on each side」：切句規則（。！？；以及 . ! ? 後接空白、換行）、改動句的定義（對照上一次呈現給使用者的版本，找不到逐字相同的句子即為改動句）、讀取範圍（改動句加前後各一句，相鄰範圍合併）、第一次呈現讀全文，並註明此定義供 #19 沿用。驗證：拿 spec 讀取範圍例表的三列，依文字定義手算讀取範圍，結果與例表相同。

## 4. 對外契約與 README

- [x] 4.1 在 README 的 EXTERNAL-CONSUMER CONTRACT 不適用具名列舉加入 *Native-syntax Read*，並同步 core skill 的 Calibrate-draft entry 具名對照，落實「calibrate 模式不執行 5e」與 requirement「Native-syntax read does not run in calibrate mode」：寫明排除理由（promise 7 限定回傳只有 status header 加草稿、沒有人可讀標記）與代價（經由 calibrate 產生的草稿不經語序檢查）。驗證：grep 在 README 與 core skill 兩處都找到 Native-syntax Read，且 README 契約標題仍為 v2。
- [x] 4.2 在 README 的 Pre-send review 表加入 Phase 5e 一列（時間尺度：單封、交付前；視角：一個、不是起草者、不知道來源；作用：依母語語序標記直譯句構），並補一段說明 5e 與 5d 的差別（5d 知道脈絡並改寫，5e 不知道脈絡且只標記）與降級行為。驗證：人工讀表格與段落，三欄皆已填，內容與 design 的 Decisions 一致。

## 5. 版本與發布紀錄

- [x] 5.1 將 plugins/perspective-writer/.claude-plugin/plugin.json 與 .claude-plugin/marketplace.json 的版本改為 4.7.0，並在 plugins/perspective-writer/CHANGELOG.md 新增 4.7.0 條目（Added：Phase 5e 語序讀者，Refs #17）。驗證：grep 兩個 version 欄位皆為 4.7.0，CHANGELOG 有 4.7.0 標題且提到 #17。

## 6. 回歸驗收

- [x] 6.1 依 Phase 5e 一節的讀者指示，派一個獨立 subagent 讀一段含驗收表六句的測試文字（語言標記 zh-Hant，附起點清單），確認正例被標出且原因對到「整句當主語＋是…的」、五個反例都沒有被標出；把讀者的原始回傳與判定結果記在 #17 的 comment。驗證：該 comment 存在且判定為六句全數符合；不符時回頭修改起點清單或讀者指示後重跑，直到符合。
