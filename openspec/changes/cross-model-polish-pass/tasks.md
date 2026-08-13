## 1. Core skill：Phase 5d 主體

- [x] 1.1 在 core skill 落位 Phase 5d 段落，使 Compose 與 Revise 兩個 mode 在 anti-pattern checklist 之後、草稿呈現之前執行潤稿，實現 `Polish pass runs before the draft is presented`；依 design `D1: Phase 5d 置於 Phase 5c 之後、Phase 6 之前`。驗證：閱讀 plugins/perspective-writer/skills/perspective-writer/SKILL.md，確認新段落位於 Phase 5c 與 Phase 6 之間，且段內明寫「使用者看到的第一版即為潤稿後版本」。
- [x] 1.2 寫入三層 failure-driven ladder 與降級鐵律，使任一層不可用時逐層下墜且最終必定交付草稿，並確立不得詢問使用者是否具備外部帳號，實現 `Polish channel degrades through a fixed ladder and never blocks delivery`；依 design `D3: 三層 failure-driven ladder，不設帳號詢問步驟`。驗證：段落中三層各有明確 exit path 指向「照常交付」，且全段不含任何要求使用者回答帳號狀態的提問。
- [x] 1.3 明訂 fallback 層必須由未參與起草的獨立 agent 執行、同 session 第二次 pass 不成立，實現 `The fallback polisher is an independent agent`。驗證：段落明文排除「同一 session 的第二次 pass」並說明排除理由為獨立視角。
- [x] 1.4 寫入 frozen-span 清單的下達方式、回稿後的逐項驗證判準（仍存在且出現次數不變）、以及 mismatch 時回退潤稿前草稿並指名失敗 span 的行為，實現 `Anchored spans are preserved and verified after return`；依 design `D4: 潤稿約束採 frozen-span 義務與回稿後機械驗證`。驗證：段落明列受保護的內容類別（時間錨點、金額、經手人、流程細節、逐字引用），且明寫風格指示為附加而非替代。
- [x] 1.5 定義收斂三條件（差異僅剩不改變語意的措辭、span 驗證通過、無新增事實主張）與每輪輪次及差異摘要的輸出義務，且不設輪次上限，實現 `Convergence is observable and is not bounded by a round limit`；依 design `D5: 收斂條件可觀測但不設硬上限`。驗證：段落同時含三條件與每輪輸出義務，且不出現任何固定輪次數字。
- [x] 1.6 以引用上游 canonical 解析文件的方式寫入依賴解析與版本地板，使治理值於執行時取得、樹內不留解析邏輯複本，實現 `Polish governance is resolved at run time by reference`；依 design `D6: 依賴解析採引用 canonical 文件，樹內不留複本`。驗證：段落以引用形式指向上游文件而非貼上解析步驟，且缺依賴時的行為為降級加一步安裝提示。

## 2. 既有條款的連帶修改

- [x] 2.1 在 core skill 的 Phase 0 bootstrap stage task list 增列 Phase 5d 對應項，使該階段與既有七個 phase 受同一套追蹤紀律約束。驗證：bootstrap 區塊的 TaskCreate 清單含 Phase 5d 項，且描述指向本 change 的 ladder 與 span 驗證行為。
- [x] 2.2 為 Phase 5c 非目標條款「不要求 codex-pro」加上適用範圍限定，並明寫 Phase 5d 把它當可降級首選不違反該條，依 design `D7: Phase 5c 非目標條款限定適用範圍而非刪除`。驗證：該行仍存在於 Phase 5c 非目標段落內，且其後緊接適用範圍限定文字；不得以刪除該行的方式消解矛盾。
- [x] 2.3 在 core skill 的流程開頭加入**非阻斷的依賴缺席提示**，使未安裝者在起草之前就知道可以安裝，實現 `Absence of the polish dependency is surfaced before drafting begins`。驗證：提示位於 Phase 0 區塊、只在偵測不到依賴時輸出一行、不提問、不阻斷；依賴存在時無輸出。

  > **本 task 於 apply 階段新增。** 原始需求含「沒安裝的人可以一開始就安裝」（diagnosis 記為 R4），但 proposal / design / spec 三份 artifact 都只把安裝提示放在降級發生的當下（Phase 5d），「流程開頭」在轉寫過程中遺失。apply 階段回補，並同步新增對應的 spec requirement。

## 3. 消費者契約與變更紀錄

- [x] 3.1 在 README 消費者契約的具名 section 列舉中補入 Phase 5d 並歸類為不適用，使 calibrate mode 的行為維持與本次變更前完全相同，實現 `Polish does not run in calibrate mode`；同時比照補寫 Phase 5c 那段 optional-and-soft 說明的 5d 版本。依 design `D2: 潤稿不適用於 calibrate mode`。驗證：閱讀 README.md，確認契約 section 列舉可查到 Phase 5d 且分類明確，並確認 calibrate 的 return shape 條款未被修改。
- [x] 3.2 在 CHANGELOG 記錄本次契約段落變更，滿足 README 自身「契約變更須 bump 該段並記 CHANGELOG」的規定。驗證：plugins/perspective-writer/CHANGELOG.md 有本次條目，且內容指明契約變更為 additive 澄清、非 BREAKING。

## 4. Genre facet

- [x] 4.1 在 email facet 增補**書信文類特有的受保護範圍**，使 core 定義 frozen span 機制、facet 定義該文類還要把哪些內容放進清單。驗證：plugins/perspective-writer/skills/perspective-writer-email/SKILL.md 含 Phase 5d 增補段，明列書信特有的受保護要素（稱謂與敬語密度、署名格律、CC 對象、六段格律的段落界線），且明寫此為 core 五類之外的文類增補。

  > **本 task 於 apply 階段改寫**（原文：「增補書信文類的 Phase 5d 觸發判準，使 core 只定義偵測與降級語意、facet 決定何時觸發」）。改寫理由：原文照抄 Phase 5c 的分工，但 5c 有觸發決策（要不要提示使用者去跑），5d 沒有 —— core 明訂 5d 對 Compose 與 Revise 一律執行，只是可能落到第三層。依原文寫會在 facet 發明一個 core 不存在的閘。proposal 與 design 對此都寫的是條件句（「若採 core/facet 分工」），是本 task 把條件硬化成祈使句。

## 5. 驗收

> **5.1 與 5.2 於 2026-08-10 的 apply 明確延後（deferred-manual），不是遺漏。**
> 兩者是**行為驗收**，需要一次真實的寫信情境才能執行 —— 真實收件人、真實往來脈絡、真實的時間錨點（5.2 的 frozen span 要有真的東西可凍）。用虛構情境跑會直接違反本 skill 的反虛構核心，驗出來的結果也不具意義。
> **執行時機**：下一次真的用 perspective-writer 寫信時一併驗。
> **在此之前本 change 不得 archive** —— 降級鐵律（5.1）與 span 回退（5.2）是這次改動最關鍵的兩個行為，兩者都還沒有被實際觀察過，只有規格上寫著。

- [~] 5.1 **判準已失效，部分以靜態證據替代；tier-3 行為仍未觀察。**
  - **已驗**：4.2.0 → 4.3.0 的 skill 文本比對為 **0 刪除 / 134 新增** —— 嚴格超集，交付路徑上沒有任何一行被移除或修改。這支持「Phase 5d 未擾動既有管線」。
  - **判準失效**：原文寫「交付的草稿與本次變更前**逐字相同**」，但同一個 release 另外加了 `Definite reference to context the reader may no longer hold` 這條 anti-pattern，它**存在的目的就是讓草稿變得不一樣**。逐字相同反而代表該列沒生效。判準與它要保護的東西互相矛盾。
  - **未驗**：依賴真的缺席時 tier 3 是否確實觸發。要製造缺席須搬走 `codex-pro` 與 `parallel-ai-agents` 的 cache，那會同時弄壞 idd-verify 的 codex leg 與所有 ensemble，代價與測試不成比例。
- [~] 5.2 **核心謂詞已驗；wiring 未驗。**
  - **已驗**：frozen-span 驗證謂詞（span 仍存在 ∧ 出現次數不變）以決定性測試跑過 5 個 case，全數符合規格 —— 未改動→採用；職稱被改寫→回退並指名；恭喜被刪→回退並指名；**span 被重複一次（次數 1→2）→ 回退並指名**（最容易漏的一格）；只改非 span 措辭→採用。
  - **未驗**：真實的潤稿 round-trip 是否確實會呼叫到這個謂詞。測的是謂詞本身，不是它有沒有被接上。

  > **兩條共同的、無法靠本 change 解決的限制（2026-08-12 記）**：本 plugin 沒有編譯產物，Phase 5d 的「行為」就是模型對 markdown 指示的遵從度。於是**測試者與被測系統是同一個模型** —— 我明知在被評分「會不會遵守降級鐵律」，就不是公平樣本。而這正是 Phase 5d 存在要解決的盲點。
  >
  > 原本的 5.1／5.2 預設了一個外部測試框架，對散文 skill 而言那東西不存在。**這是驗收條件設計上的缺陷，不是執行上的偷懶。** 要真正驗證，需要一個不知道自己在被測的獨立執行者（fresh subagent 或另一個 session），那超出本 change 範圍。
  >
  > **殘留的接手人：`PsychQuant/perspective-writer#12`**（散文型 skill 的行為驗收需要不知情的獨立執行者）。本 change 以 13/15 封存，**不是因為那兩項不重要，而是因為它們需要本 change 內不存在的觀察手段**。#12 負責決定那個手段長什麼樣子；在它落地之前，Phase 5d 的降級鐵律與 span 回退在真實條件下仍屬未觀察。
- [x] 5.3 對本 repo 全樹搜尋模型名稱字面，確認命中數為零，證明治理值確實於執行時解析。驗證：搜尋結果為空；若有命中，逐一改為引用式解析後重跑。
