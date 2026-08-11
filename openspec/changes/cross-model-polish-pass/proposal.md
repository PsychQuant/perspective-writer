## Why

`perspective-writer` 目前只有作者自審（Phase 5 anti-pattern checklist）與一個可選、需人工觸發的多視角複核（Phase 5c）。兩者都在同一個模型內完成 —— 作者看不見的盲點，複核者也看不見。

同 repo #7 的四輪跨模型盲驗留下一個對照事實：**所有 blocking finding 全部出自跨模型驗證，作者自審每輪都報「完全符合」。** 交付前若有一道真正外部的潤稿，能補上這層。本次 `/spectra-discuss` 本身也重演了同一模式：兩個最有價值的發現都出自使用者對 AI 假設的反對，而非 AI 自審。

## What Changes

- 新增 **Phase 5d: Cross-model Polish**，位於 Phase 5c 之後、Phase 6 之前。Compose 與 Revise 兩個 mode 適用；使用者看到的第一版草稿即為潤稿後版本。
- 潤稿管道為 **failure-driven 三層 ladder**：第一層送外部模型（Codex）；偵測到 OAuth 失效或依賴缺席即降第二層（獨立 Opus subagent）；兩層皆不可用則第三層照常交付。**不新增任何「先問使用者有沒有帳號」的提問步驟。**
- 潤稿的約束以 **frozen-span 義務**下達，而非風格建議。回稿後對每個 span 做機械驗證（仍存在、出現次數不變），任一 mismatch 即回退到潤稿前的自家草稿。此機制復用 README 既有 consumer 契約 promise #6 的形狀，角色對調（本 skill 由被驗證方轉為驗證方）。
- 收斂條件**可觀測但不設硬上限**：每輪印出輪次與差異摘要。
- **Phase 5d 明確不適用於 calibrate mode**，並寫入 README 消費者契約的具名 section 列舉。此為 additive 澄清，calibrate 既有行為不變，**非 BREAKING**；依 README 規定仍需 bump 契約段落並記 CHANGELOG。
- Phase 5c 現行非目標條款「不要求 codex-pro」**限定適用範圍**為「5c 的 ensemble 複核不得把 codex-pro 升格為前置條件」，並明寫 5d 把它當可降級首選不違反該條。該行不得刪除。
- 外部依賴的解析流程採**引用**既有 canonical 文件的形式，樹內不留解析邏輯複本、不留 model 字面。

## Capabilities

### New Capabilities

- `cross-model-polish`: 交付前的跨模型潤稿階段 —— 階段位置、三層降級 ladder、frozen-span 保全與回退、可觀測收斂、calibrate mode 排除、以及依賴解析的引用式約束。

### Modified Capabilities

(none)

## Impact

- Affected specs: 新增 `cross-model-polish`
- Affected code:
  - Modified: plugins/perspective-writer/skills/perspective-writer/SKILL.md（新增 Phase 5d 段；Phase 0 bootstrap task list 增列；Phase 5c 非目標條款加適用範圍限定）
  - Modified: README.md（消費者契約的具名 section 列舉補 Phase 5d 歸屬；Phase 5c 的 optional-and-soft 說明段比照補 5d）
  - Modified: plugins/perspective-writer/CHANGELOG.md（契約變更依 README 規定強制記錄）
  - Modified: plugins/perspective-writer/skills/perspective-writer-email/SKILL.md（若 5d 沿用 5c 的 core/facet 分工，新增文類特有的觸發判準增補段）
- 外部依賴（執行時解析，不進樹內）：`codex-pro` 提供治理契約，`parallel-ai-agents` 提供執行檔
- 相關 issue：PsychQuant/perspective-writer#10（本體）、PsychQuant/perspective-writer#11（契約列舉完整性，pre-existing）、PsychQuant/codex-pro#15（呼叫面歸屬與雙向依賴）
