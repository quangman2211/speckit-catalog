---
name: run-speckit
description: Chạy, kiểm tra và verify hệ thống Spec-Driven Development cho bất kỳ project nào dùng speckit-catalog. Dùng khi cần run/start/test/validate/build speckit, kiểm tra toolchain specify, build extension hoặc bundle, sinh lại catalog.json, cài catalog nội bộ, phát hành version mới, đẩy cập nhật sang các project, hoặc kiểm tra xem đã được phép viết code ứng dụng chưa.
---

# run-speckit

Skill này **sống trong repo `speckit-catalog`** và được dùng chung cho mọi project.
Nó không gắn với project nào cụ thể: **project đích là thư mục đang đứng (`cwd`)**,
hoặc đối số thứ hai.

```bash
node .claude/skills/run-speckit/driver.mjs all            # project = cwd
node <driver> all /đường/dẫn/tới/project                  # project = tham số
SPECKIT_PROJECT=/path node <driver> all                   # project = biến môi trường
```

Chạy ngoài một spec-kit project thì driver dừng ngay với exit `2`:

```
FATAL: '/…/speckit-catalog' khong phai spec-kit project (thieu .specify/).
```

## Kiến trúc

| Thành phần | Vị trí | Vai trò |
|---|---|---|
| Skill + driver | `speckit-catalog/.claude/skills/run-speckit/` | Bản gốc duy nhất |
| Catalog repo | `speckit-catalog/` | Extension `masterplan` + bundle `retail-sdd` |
| Symlink trong project | `<project>/.claude/skills/run-speckit` | Để Claude Code thấy skill |
| Toolchain | `<project>/.specify/`, `<project>/.claude/skills/speckit-*` | 16 skill SDD + template |
| Constitution | `<project>/.specify/memory/constitution.md` | Luật project |

Driver tự định vị catalog repo bằng cách đi lên 3 cấp từ vị trí **thật** của
`driver.mjs`. Node resolve symlink trước khi đặt `import.meta.url`, nên gọi qua
symlink nào cũng ra đúng. Ghi đè được bằng `SPECKIT_CATALOG_DIR`.

## Cài skill vào một project mới

Claude Code chỉ nạp `.claude/skills/` từ thư mục khởi động **và các thư mục cha tới
repo root**. Mỗi project ở đây là một git repo riêng, nên walk-up **không** với tới
`Quang-Man-Project/`. Symlink được Claude Code hỗ trợ đầy đủ — đó là cách nối:

```bash
cd <project>/.claude/skills
ln -s ../../../speckit-catalog/.claude/skills/run-speckit run-speckit
```

Đường dẫn tương đối trên đúng khi project nằm ngang hàng với `speckit-catalog`
trong `Quang-Man-Project/`. Đã dựng sẵn cho `Retail-OPS`.

Restart Claude Code để `/run-speckit` xuất hiện.

## Prerequisites

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git --force
specify --version
```

Cần thêm: `node` (>=18, dùng global `fetch`), `python3` có `pyyaml`, `zip`, `git`.
Đã verify trên Node v25.9.0 / Python 3.9.6 / pyyaml 6.0.3 / specify 1.0.5.dev0.

## Run (agent path) — luôn bắt đầu ở đây

```bash
node .claude/skills/run-speckit/driver.mjs all
```

Thoát `0` khi mọi check pass, `1` khi có check fail, `2` khi thiếu tiền đề
(không thấy `specify` hoặc không thấy repo catalog).

Bốn lệnh con chạy riêng được:

```bash
node .claude/skills/run-speckit/driver.mjs doctor   # toolchain + cấu trúc project
node .claude/skills/run-speckit/driver.mjs build    # zip extension + sinh catalog.json + build bundle
node .claude/skills/run-speckit/driver.mjs e2e      # build rồi cài catalog + bundle trên project TRẮNG
node .claude/skills/run-speckit/driver.mjs gate     # cổng "hệ thống trước, code sau"
node .claude/skills/run-speckit/driver.mjs update [project]   # đồng bộ extension từ catalog vào project
```

Driver làm gì bên trong:

1. Copy `speckit-catalog` sang thư mục tạm (**không bao giờ ghi vào repo thật**).
2. Chạy `scripts/build.sh` trên bản sao đó với URL `localhost`.
3. Bật `python3 -m http.server 8777` phục vụ bản sao.
4. Tạo project spec-kit trắng trong `$TMPDIR`, `specify init`, rồi:
   - khẳng định `bundle install` **thất bại** khi chưa đăng ký catalog,
   - đăng ký catalog, cài lại, khẳng định đủ 3 extension, 8 skill `blueprint`,
     và hook `UserPromptSubmit` đã vào `.claude/settings.json`,
   - khẳng định token `__SPECKIT_COMMAND_*__` đã render thành `/speckit-*`.
5. Dọn sạch project tạm và bản sao.

Đổi cổng khi 8777 bận: `SPECKIT_CATALOG_PORT=9001 node .claude/skills/run-speckit/driver.mjs all`

Output đã verify:

```
doctor — toolchain va cau truc project
  PASS  specify CLI chay duoc
  ...
gate — "he thong truoc, code sau" (Constitution I & II)
  PASS  khong co code ung dung khi chua co spec

✓ tat ca check pass
```

## Run (human path) — quy trình SDD hằng ngày

Sau khi `doctor` xanh, làm việc bằng slash command trong Claude Code. Skill mới cài
**chỉ xuất hiện sau khi restart Claude Code**.

```
/speckit-constitution   # 1 lần cho cả project (đã viết sẵn)
/speckit-specify <mô tả>
/speckit-clarify
/speckit-plan <tech stack>
/speckit-tasks
/speckit-analyze
/speckit-implement
/speckit-converge
```

Extension `git` tự tạo branch `001-<slug>` ở `before_specify`. Auto-commit mặc định
tắt hết trong `.specify/extensions/git/git-config.yml`.

## Sửa extension / phát hành version mới

Làm trong repo `speckit-catalog`, **không bao giờ sửa trực tiếp trong
`.specify/extensions/`** của project — chỗ đó là bản cài, sẽ bị ghi đè.

```bash
cd ~/Quang-Man-Project/speckit-catalog
# 1. sửa code trong extensions/<id>/
# 2. bump version cho extension VÀ mọi bundle pin nó, trong một thao tác
./scripts/bump.sh blueprint 0.2.0
# 3. sinh lại artifact + catalog.json + bundle-catalog.json với URL production
./scripts/build.sh
git add -A && git commit -m "blueprint 0.2.0: <mô tả bug fix>"
```

Publish: tạo GitHub release, upload `dist/*.zip`, push `catalog.json` **và**
`bundle-catalog.json`.

Bundle dùng stack catalog riêng: `specify bundle catalog add <url> --id <name>
--policy install-allowed` (extension thì là `--name` + `--install-allowed`). Thiếu
`bundle-catalog.json` thì `bundle install <id>` theo tên báo `not found in any
configured catalog` còn cài theo path vẫn chạy — nên phải test theo tên, `e2e` có
check đúng chỗ đó.

Verify trước khi publish — chạy từ một project bất kỳ có symlink skill:

```bash
cd ~/Quang-Man-Project/Retail-OPS
node .claude/skills/run-speckit/driver.mjs all
```

Đẩy version mới vào từng project đang dùng:

```bash
node .claude/skills/run-speckit/driver.mjs update              # project này
node .claude/skills/run-speckit/driver.mjs update /path/khac   # project khác
```

`update` xoá cache catalog rồi chạy `specify extension add <id> --force` cho mọi
extension của catalog đang có mặt trong project đó. Config đã tuỳ chỉnh được giữ.

Thử nhanh khi đang sửa, chưa muốn bump version:

```bash
specify extension add --dev ~/Quang-Man-Project/speckit-catalog/extensions/masterplan
```

## Gotchas

**Bundle không chứa payload của extension.** Artifact `retail-sdd-1.0.0.zip`
chỉ có đúng 2 file (`bundle.yml` + `README.md`). Lúc install, `specify` chỉ giải
quyết extension theo 2 đường: extension ship sẵn trong `specify-cli`, hoặc catalog
đang active có `install_allowed`. Không có đường đọc payload từ thư mục bundle.
Extension tự viết **bắt buộc** phải qua catalog.

**Catalog URL bắt buộc HTTPS — trừ localhost được HTTP.** `file://` bị từ chối thẳng:
`Error: Catalog URL must use HTTPS (got file://). HTTP is only allowed for localhost.`
Chính ngoại lệ localhost làm cho việc verify offline khả thi, và đó là nền của `e2e`.

**Cài thành công trên máy anh không chứng minh được gì.** `bundle install` kiểm tra
idempotent theo **id**, không so version. Extension đã cài sẵn sẽ bị skip, nên bundle
báo thành công kể cả khi catalog cấu hình sai. Đây là lý do `e2e` luôn tạo project
trắng trong `$TMPDIR`. Chưa đăng ký catalog thì lỗi thật sẽ là:
`Error: Extension 'frontend' not found in any catalog.`

**`bundle validate` resolve reference theo project CHỨA bundle, không theo cwd.**
Cùng một `bundle.yml`, chạy từ `/tmp/cleanproj` (đã có catalog) vẫn FAIL vì bundle
nằm trong một project lúc đó chưa đăng ký catalog. Bundle nằm ngoài mọi spec-kit
project thì mới rơi về cwd.

**`validate` pass gần như không chứng minh gì.** Reference không verify được sẽ bị
hạ xuống *warning* rồi pass: `! Could not verify extension 'frontend' (catalog
unreachable); reference left unchecked.` Chỉ `bundle install` trên project trắng mới
là bằng chứng.

**`bundle install <path>` với path không tồn tại bị hiểu là bundle id**, và lỗi trả
về gây hiểu nhầm: `Bundle '/…/retail-sdd-1.0.0.zip' was not found in any
configured catalog.` Kiểm tra file có tồn tại trước.

**`scripts/build.sh` chạy `rm -rf dist/`.** Nó phải build bundle artifact *sau* khi
sinh `catalog.json`, nếu không artifact bundle sẽ bị xoá ngay ở lần build kế tiếp.

**Đừng hard-code `/speckit.plan` trong command body của extension.** Mỗi agent dùng
separator khác nhau. Dùng token `__SPECKIT_COMMAND_PLAN__`; driver có check khẳng
định nó render đúng thành `/speckit-implement` cho Claude Code.

**`~/.local/bin` không chắc nằm trong PATH của tiến trình con.** Driver tự dò
`specify` rồi fallback sang `~/.local/bin/specify`.

**`bundle install` không nối hook `events:` — phải chạy thêm một lệnh.** Extension
khai báo khối `events:` sẽ ghi một hook thật vào `.claude/settings.json`, nhưng chỉ khi
đi qua `extension add/remove/update` hoặc `init`. Hàm `_refresh_events_and_warn` **không
được bundler gọi** (`extensions/_commands.py:164`), nên cài bằng bundle thì extension có
mặt mà hook thì không. Nối lại bằng:

```bash
specify integration upgrade claude      # hoac: specify extension add <id> --force
```

`driver.mjs update` đã làm sẵn (nó chạy `extension add --force` cho mọi extension).

**Skill mới cài không xuất hiện tới khi restart Claude Code.**

**Version pin phải khớp tuyệt đối** giữa `extension.yml` và mọi `bundle.yml` tham
chiếu nó. Bump extension thì bump cả hai.

**Catalog bị cache 1 giờ và không có cách refresh từ CLI.** `CACHE_DURATION = 3600`
trong `specify_cli/extensions/__init__.py`. Sau khi publish version mới,
`specify extension update` vẫn báo `✓ frontend: Up to date (v1.0.0)`. Có tham số
`force_refresh` trong source nhưng **không expose ra CLI**. Cách duy nhất:
`rm -rf .specify/extensions/.cache`. Lệnh `update` của driver làm sẵn việc này.

**`specify extension update` là interactive và không có `--yes`.** Nó hỏi
`Update these extensions? [y/N]:` rồi `Aborted.` khi không có TTY — hỏng trong CI và
trong mọi script. Dùng `specify extension add <id> --force` thay thế: không cần TTY,
vẫn tải version mới, và **giữ nguyên config đã tuỳ chỉnh**
(`Config files already exist (preserved)`).

**Cài lại bundle mới KHÔNG cập nhật extension — và nó nói dối.** Đây là bẫy nguy
hiểm nhất. Kiểm tra idempotent theo **id**, không so version:

```
$ specify bundle install retail-sdd-1.1.0.zip
✓ Installed 'retail-sdd' (0 added, 3 already present).
$ specify extension list | grep Frontend
  ✓ Frontend Workflow (v1.0.0)     <-- van la ban cu, bug fix khong vao
$ specify bundle list | grep retail
  retail-sdd v1.1.0           <-- bundle bao 1.1.0
```

Bundle ghi nhận 1.1.0, pin frontend 1.0.1, nhưng project thực tế vẫn chạy 1.0.0.
Sửa bằng `driver.mjs update`, hoặc `specify extension add <id> --force` cho từng cái.

**Bump extension mà quên bump pin trong bundle sẽ làm hỏng mọi lần install bundle:**
`Error: Extension 'frontend' is pinned to version 1.0.0 in the bundle manifest, but
the resolved version is 1.0.1.` Dùng `./scripts/bump.sh <id> <version>` để bump cả
hai cùng lúc thay vì sửa tay.

**`specify bundle update <id>` cần bundle nằm trong một *bundle catalog*.** Bundle
cài từ file `.zip` local không update theo id được:
`Error: Bundle 'retail-sdd' was not found in any configured catalog.`
Với phân phối local, đường cập nhật là cài lại artifact mới rồi `driver.mjs update`.

## Troubleshooting

| Triệu chứng | Nguyên nhân → cách sửa |
|---|---|
| `FATAL: khong tim thay repo speckit-catalog` | `driver.mjs` bị copy ra ngoài repo catalog → `SPECKIT_CATALOG_DIR=<path> node <driver> all` |
| `FATAL: '<dir>' khong phai spec-kit project` | Đang đứng ngoài project → `cd` vào project, hoặc truyền đường dẫn làm tham số thứ hai |
| `catalog server khong len duoc tren cong 8777` | Còn server cũ chiếm cổng → `pkill -f "http.server 8777"`, hoặc đặt `SPECKIT_CATALOG_PORT` |
| `Error: Extension 'frontend' not found in any catalog.` | Chưa `specify extension catalog add … --install-allowed` trên project đích |
| `Manifest is invalid: Unresolved reference extension:frontend` | Chạy `bundle validate` từ project chưa đăng ký catalog → đăng ký rồi validate lại |
| `✓ <ext>: Up to date` dù đã publish version mới | Cache catalog 1 giờ → `rm -rf .specify/extensions/.cache`, hoặc dùng `driver.mjs update` |
| `Update these extensions? [y/N]: Aborted.` | `extension update` cần TTY → dùng `specify extension add <id> --force` |
| Bundle lên version mới nhưng extension vẫn cũ | Idempotent theo id → `driver.mjs update` |
| `is pinned to version X ... resolved version is Y` | Pin trong `bundle.yml` lệch → `./scripts/bump.sh <id> <version>` rồi build lại |
| `gate` FAIL với danh sách file code | Có code ứng dụng nhưng chưa có `specs/*/spec.md` → chạy `/speckit-specify` trước, hoặc xoá code |
