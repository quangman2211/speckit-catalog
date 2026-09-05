# Skill có sẵn của Anthropic

Tra cứu cho team: Anthropic đã làm sẵn skill nào, cài ở đâu, và dùng cho tầng nào
trong quy trình 4 tầng.

Nguyên tắc: **dùng đồ có sẵn trước, tự viết sau.** Trước khi viết một skill hay
extension mới, tra bảng này trước.

Đối chiếu ngày 05/09/2026 từ `github.com/anthropics/skills` (19 skill) và danh sách
skill dựng sẵn của Claude Code.

---

## Hai họ skill, khác nhau ở chỗ nào

| | Repo `anthropics/skills` | Dựng sẵn trong Claude Code |
|---|---|---|
| Số lượng | 19 | 17 |
| Phải cài | Có — qua plugin marketplace | Không |
| Dùng được ở | Claude Code · Claude.ai · Cowork · API | Chỉ Claude Code |
| Nguồn | Repo công khai, đọc được code | Đi kèm bản cài |

Cài họ thứ nhất:

```bash
/plugin marketplace add anthropics/skills
/plugin install document-skills@anthropic-agent-skills
/plugin install example-skills@anthropic-agent-skills
```

Năm plugin trong marketplace `anthropic-agent-skills`:

| Plugin | Skill |
|---|---|
| `document-skills` | xlsx · docx · pptx · pdf |
| `example-skills` | algorithmic-art · brand-guidelines · canvas-design · doc-coauthoring · frontend-design · internal-comms · mcp-builder · skill-creator · slack-gif-creator · theme-factory · web-artifacts-builder · webapp-testing |
| `claude-api` | claude-api |
| `academy-guide` | academy-guide |
| `discernment-nudge` | discernment-nudge |

---

## A · Repo `anthropics/skills`

### Tài liệu văn phòng

| Skill | Làm gì |
|---|---|
| `xlsx` | Mở, đọc, sửa, vá `.xlsx .xlsm .xltx .csv .tsv` — thêm cột, công thức, định dạng, biểu đồ, dọn dữ liệu bẩn. Cũng dùng để tạo bảng tính mới |
| `docx` | Tạo, đọc, sửa Word `.docx .dotx` — mục lục, heading, bảng, tài liệu có định dạng nghiêm chỉnh |
| `pptx` | Mọi việc dính `.pptx .potx`: dựng deck, và cả đọc rút text ra để dùng ở chỗ khác |
| `pdf` | Đọc, rút text và bảng, gộp, tách, xoay, đóng dấu mờ, tạo mới, điền form, mã hoá/giải mã |

### Thiết kế và giao diện

| Skill | Làm gì |
|---|---|
| `theme-factory` | 10 theme dựng sẵn (màu + font) áp cho artifact bất kỳ, **hoặc sinh theme mới tại chỗ**. Đây là chỗ `design-tokens.json` ra đời |
| `brand-guidelines` | Áp bộ nhận diện chính thức của Anthropic — màu và typography |
| `frontend-design` | Hướng thẩm mỹ khi dựng UI mới hoặc làm lại UI cũ: bảng màu, typography, tránh giao diện đọc ra là mặc định |
| `canvas-design` | Poster, tranh, thiết kế tĩnh, xuất `.png` và `.pdf` |
| `algorithmic-art` | Nghệ thuật sinh bằng p5.js — flow field, particle system, random có seed, chỉnh tham số trực tiếp |
| `web-artifacts-builder` | Artifact HTML nhiều thành phần bằng React + Tailwind + shadcn/ui. Dành cho cái cần state và routing — không dùng cho file đơn |
| `slack-gif-creator` | GIF động tối ưu cho Slack, kèm ràng buộc kích thước và công cụ kiểm |

### Viết và giao tiếp

| Skill | Làm gì |
|---|---|
| `doc-coauthoring` | Quy trình đồng tác giả 3 giai đoạn cho technical spec, decision doc, proposal, RFC. Chi tiết ở mục riêng bên dưới |
| `internal-comms` | Thông báo nội bộ theo format công ty: status report, cập nhật lãnh đạo, newsletter, FAQ, báo cáo sự cố, cập nhật dự án |

### Xây công cụ

| Skill | Làm gì |
|---|---|
| `skill-creator` | Viết mới, sửa, tối ưu skill. **Có phần chạy eval đo hiệu năng và phân tích phương sai**, và tối ưu description để trigger đúng |
| `mcp-builder` | Dựng MCP server chuẩn để LLM gọi API ngoài — Python (FastMCP) hoặc Node/TypeScript (MCP SDK) |
| `claude-api` | Tra cứu Claude API và SDK: model id, giá, tham số, streaming, tool use, MCP, caching, đếm token, di chuyển version |

### Kiểm thử và hành vi

| Skill | Làm gì |
|---|---|
| `webapp-testing` | Playwright: kiểm chức năng web chạy local, debug UI, chụp màn hình, đọc log trình duyệt |
| `academy-guide` | Chặn trước khi trả lời câu hỏi "làm sao để…" về Claude, gợi khoá học ở academy.claude.com |
| `discernment-nudge` | Sau khi đưa lời khuyên, bản nháp, ước tính hay phân tích, tự thêm 2–3 câu hỏi bám vào đúng thứ vừa tạo, để người dùng tự soi lại thay vì tin ngay |

---

## B · Skill dựng sẵn trong Claude Code

Không phải cài. Gõ `/<tên>` hoặc để Claude tự gọi khi hợp ngữ cảnh.

| Skill | Làm gì |
|---|---|
| `design` | Canvas nhiều artboard — bản Claude Design nằm trong phiên code, sửa trực tiếp rồi bàn giao để implement |
| `dataviz` | Bắt buộc đọc **trước** khi vẽ bất kỳ biểu đồ nào: chọn dạng biểu đồ, bảng màu đạt tương phản, quy tắc trục và nhãn |
| `artifact-design` | Nguyên tắc thiết kế trang artifact — đọc trước khi viết trang |
| `artifact-diagramming` | Vẽ sơ đồ SVG trong artifact: vẽ cơ chế chứ không vẽ trang trí |
| `artifact-capabilities` | Cấp năng lực động cho artifact: lưu dữ liệu, biết người xem là ai, hỏi ngược Claude, nhận file |
| `code-review` | Soát diff, PR, nhánh theo mức độ sâu. `ultra` bung nhiều agent soát trên cloud |
| `simplify` | Dọn code cho gọn, bớt trùng, bớt tầng thừa. Chỉ chất lượng — không săn bug |
| `security-review` | Soát bảo mật phần thay đổi trên nhánh hiện tại |
| `run` | Khởi động app của project để nhìn thay đổi chạy thật, không chỉ chạy test |
| `init` | Sinh `CLAUDE.md` từ codebase |
| `loop` | Chạy lặp một prompt hoặc slash command theo chu kỳ, hoặc để model tự canh nhịp |
| `schedule` | Tạo, sửa, liệt kê agent chạy theo lịch cron trên cloud |
| `workflow-authoring` | Viết script điều phối nhiều agent chạy song song |
| `update-config` | Sửa `settings.json`: hook, quyền, biến môi trường. **Hook là chỗ duy nhất chặn được thật** |
| `keybindings-help` | Đổi phím tắt trong `~/.claude/keybindings.json` |
| `fewer-permission-prompts` | Quét transcript, đề xuất allowlist để bớt bị hỏi quyền |
| `claude-api` | Bản dựng sẵn của skill cùng tên ở repo trên |

---

## Dùng cái nào ở tầng nào

Theo quy trình 4 tầng: ý tưởng → blueprint → hợp đồng → slice → 3 người song song.

| Tầng | Skill |
|---|---|
| **0** — ý tưởng → blueprint | `doc-coauthoring` · `internal-comms` · `pdf` `docx` nếu tài liệu nguồn ở dạng đó |
| **1** — blueprint → hợp đồng | `theme-factory` · `frontend-design` · `design` · `artifact-diagramming` · `web-artifacts-builder` |
| **2** — slice → code | `webapp-testing` · `run` · `code-review` · `security-review` · `simplify` · `dataviz` |
| **3** — 3 người song song | `code-review ultra` · `schedule` · `workflow-authoring` |
| Dựng bộ kit | `skill-creator` · `mcp-builder` · `update-config` |

Hai cái đáng dùng ngay:

- **`theme-factory`** lấp mắt xích đang trống ở tầng 1. Extension `frontend` trỏ vào
  `design-tokens.json` nhưng không tầng nào sinh ra file đó.
- **`skill-creator`** có phần chạy eval đo độ chính xác trigger — thứ mà skill tự viết
  hiện không có cách nào đo.

---

## C · Repo `anthropics/knowledge-work-plugins`

Kho thứ hai, xây **cho Cowork trước**, dùng được cả ở Claude Code. 98 plugin theo
20 vai trò. Ba plugin liên quan tới làm phần mềm, tổng 25 skill:

### `engineering` — 10 skill

| Skill | Làm gì |
|---|---|
| `system-design` | Khung 5 bước: yêu cầu → thiết kế tổng thể → đi sâu → quy mô & độ tin cậy → phân tích đánh đổi |
| `architecture` | Sinh ADR: Context · Decision · Options Considered · Trade-off · Consequences · Action Items |
| `code-review` | Soát bảo mật, hiệu năng, đúng sai — N+1, injection, thiếu case biên |
| `debug` | Tái hiện → cô lập → chẩn đoán → sửa |
| `testing-strategy` | Chiến lược test, độ phủ, kiến trúc test |
| `deploy-checklist` | Checklist trước khi ship, kèm điều kiện rollback |
| `incident-response` | Phân loại mức độ → thông báo → postmortem không đổ lỗi |
| `tech-debt` | Nhận diện, phân loại, xếp ưu tiên nợ kỹ thuật |
| `documentation` | README, runbook, onboarding, API doc |
| `standup` | Sinh standup từ commit/PR/ticket gần đây |

### `design` — 7 skill

| Skill | Làm gì |
|---|---|
| `design-handoff` | Spec bàn giao: layout, **bảng design token**, component props, trạng thái, responsive, edge case, animation, a11y |
| `design-system` | Ba chế độ: audit (tên đặt lệch, **giá trị hard-code lọt ra ngoài token**), document, extend |
| `accessibility-review` | Audit WCAG 2.1 AA: tương phản, bàn phím, vùng chạm, screen reader |
| `design-critique` | Phản hồi có cấu trúc về khả dụng, thứ bậc, nhất quán |
| `ux-copy` | Microcopy, thông báo lỗi, trạng thái rỗng, chữ trên nút |
| `user-research` · `research-synthesis` | Kế hoạch phỏng vấn; gom transcript thành theme |

### `product-management` — 8 skill

`write-spec` (PRD: problem → goals → non-goals → user story → MoSCoW → success metrics) ·
`product-brainstorming` · `roadmap-update` · `sprint-planning` · `synthesize-research` ·
`competitive-brief` · `metrics-review` · `stakeholder-update`

**Cài:**
```bash
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install engineering@knowledge-work-plugins
claude plugin install design@knowledge-work-plugins
```

Cài dạng plugin thì tên có tiền tố: `engineering:system-design`, `design:design-handoff`.

### Ba đặc điểm phải biết trước khi dùng

1. **Không skill nào ghi file.** Cả 25 chỉ in markdown ra chat. Muốn có artifact
   nằm trong repo thì phải tự thêm lớp ghi file — đó là việc extension `masterplan`
   của bộ kit này làm.
2. **Không có khái niệm giai đoạn.** Mỗi skill độc lập, kích hoạt bằng
   description matching. Thứ tự là thứ mình áp vào.
3. **Tool-agnostic có chủ ý.** Viết theo *loại* công cụ (`~~design tool`,
   `~~project tracker`) chứ không theo sản phẩm. Không có connector vẫn chạy —
   chỉ mất phần tự kéo dữ liệu.

License Apache-2.0, sao chép được. Nhưng **copy `product-management/LICENSE`**
(bản sạch 202 dòng) chứ đừng copy `LICENSE` ở gốc repo: nó bị chèn 10 dòng rác
qua PR #193.

---

## Đính chính: `system-architect`

Bản trước của tài liệu này viết "Anthropic không có skill quyết định kiến trúc".
**Sai** — nhận định đó chỉ đúng với repo `anthropics/skills`. `knowledge-work-plugins`
có `system-design` và `architecture`.

Còn `system-architect` thì vẫn **không** phải skill của Anthropic:

- Không có trong cả hai repo
- Là issue [#626](https://github.com/anthropics/skills/issues/626) do một người
  ngoài mở ngày 13/03/2026 — 0 comment, vẫn open
- Các trang bán nó (`claudecowork.im`, `mcpmarket.com`) là bên thứ ba

---

## Phụ lục — `doc-coauthoring` chi tiết

Một file `SKILL.md`, 15.8 KB, không kèm script. Claude đóng vai người dẫn.

**Giai đoạn 1 — gom bối cảnh.** Hỏi 5 câu mở đầu: loại tài liệu gì, người đọc chính
là ai, đọc xong muốn điều gì xảy ra, có template không, ràng buộc gì. Rồi bảo đổ hết
bối cảnh ra, không cần sắp xếp. Sau đó đặt 5–10 câu hỏi đánh số vào đúng chỗ hổng;
trả lời tốc ký được.

Điều kiện thoát: **khi nó hỏi được về trường hợp biên và đánh đổi mà không cần ai
giải thích lại điều cơ bản.**

**Giai đoạn 2 — dựng cấu trúc, tinh từng mục.** Mỗi section 6 bước: hỏi làm rõ →
brainstorm 5–20 ý → chọn giữ/bỏ/gộp kèm lý do ngắn → hỏi còn thiếu gì → viết → sửa
dần. Bắt đầu từ section nhiều ẩn số nhất; phần tóm tắt để cuối.

Hai chi tiết đáng chú ý: sửa bằng `str_replace` chứ không in lại cả tài liệu; và nó
dặn *đừng tự sửa file, hãy nói cần sửa gì* — để nó học gu cho các section sau. Sau 3
vòng không đổi gì đáng kể, nó tự hỏi bỏ bớt được chỗ nào không.

**Giai đoạn 3 — kiểm bằng người đọc.** Phần đáng giá nhất. Dự đoán 5–10 câu người đọc
sẽ hỏi, rồi gọi **subagent hoàn toàn không có context** đọc tài liệu và trả lời. Chỗ
nào subagent hiểu sai chính là chỗ tài liệu đang giả định ngầm. Hỏi thêm: chỗ nào mơ
hồ, ngầm giả định người đọc đã biết gì, có mâu thuẫn nội bộ không.

Trong Claude Code nó tự chạy hết vòng này vì có subagent. Trên claude.ai phải mở tab
mới dán tay.

**Chi phí:** mỗi section brainstorm 5–20 ý rồi chờ chọn. Đáng cho blueprint gốc,
không đáng cho tài liệu ngắn.

---

Nguồn: [anthropics/skills](https://github.com/anthropics/skills) ·
[Use skills in Claude](https://support.claude.com/en/articles/12512180-use-skills-in-claude)
