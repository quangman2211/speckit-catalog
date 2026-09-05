# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repo này là gì

`speckit-catalog` là **hạ tầng**, không phải app: nó xuất bản extension và bundle
Spec-Driven Development cho spec-kit (`specify` CLI) dùng chung cho mọi project
trong `Quang-Man-Project/`. Không có code ứng dụng ở đây, và không có test
framework — bộ test chính là `driver.mjs`.

Đọc `README.md` và `.claude/skills/run-speckit/SKILL.md` trước khi sửa gì: SKILL.md
chứa danh sách đầy đủ các bẫy của `specify` CLI đã được verify bằng tay.

## Lệnh

```bash
./scripts/bump.sh <ext-id> <x.y.z>   # bump extension + MỌI bundle pin nó (+ patch bundle)
./scripts/build.sh                   # zip extensions/* → dist/, sinh catalog.json (URL prod), build bundle
./scripts/build.sh <zip_base_url> [catalog_url]   # override URL cho test local
```

Verify/test — `driver.mjs` **phải chạy từ trong một spec-kit project** (thư mục có
`.specify/`). Repo này không phải, nên chạy ở đây sẽ exit `2`; `cd` sang project
tiêu thụ (vd `../Retail-OPS`) hoặc truyền đường dẫn làm tham số thứ hai:

```bash
cd ../Retail-OPS
node .claude/skills/run-speckit/driver.mjs all      # toàn bộ: doctor + build + e2e + gate
node .claude/skills/run-speckit/driver.mjs doctor   # chỉ toolchain + cấu trúc project
node .claude/skills/run-speckit/driver.mjs build    # chỉ đóng gói (trên bản sao tạm)
node .claude/skills/run-speckit/driver.mjs e2e      # chỉ install thật trên project trắng
node .claude/skills/run-speckit/driver.mjs gate     # chỉ cổng "spec trước, code sau"
node .claude/skills/run-speckit/driver.mjs update [project]   # đẩy version mới vào project
```

Chạy một nhóm check lẻ = chạy đúng subcommand đó; không có granularity nhỏ hơn.
Exit `0` mọi check pass, `1` có check fail, `2` thiếu tiền đề (`specify` hoặc repo
catalog). Cổng 8777 bận: `SPECKIT_CATALOG_PORT=9001`. Repo catalog ở chỗ khác:
`SPECKIT_CATALOG_DIR=<path>`.

Prereq: `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`,
`node >=18`, `python3` + `pyyaml`, `zip`.

## Kiến trúc

Chuỗi phân phối, mỗi mắt xích tồn tại vì một ràng buộc của `specify`:

```
extensions/<id>/extension.yml  →  build.sh  →  dist/<id>-<ver>.zip
                                       ↓
                                  catalog.json  (GitHub raw, HTTPS)
                                       ↓
bundles/<id>/bundle.yml (pin version)  →  dist/<bundle>-<ver>.zip
                                       ↓
                    project: .specify/extensions/ + .claude/skills/speckit-*
```

**Bundle không chứa payload extension.** Artifact bundle chỉ có `bundle.yml` +
`README.md`. Lúc install, `specify` chỉ giải quyết extension theo hai đường:
extension ship sẵn trong `specify-cli`, hoặc một catalog active có
`install_allowed: true`. Vì vậy extension tự viết **bắt buộc** đi qua
`catalog.json` — đó là lý do repo này tồn tại.

**`catalog.json` là file sinh ra.** Không sửa tay; chạy `./scripts/build.sh`.

**`.claude/skills/run-speckit/` là bản gốc duy nhất của skill + driver.** Các
project nối vào bằng symlink (`ln -s ../../../speckit-catalog/.claude/skills/run-speckit`),
không copy. Driver tự định vị repo catalog bằng cách đi lên 3 cấp từ vị trí *thật*
của `driver.mjs` (Node resolve symlink trước khi đặt `import.meta.url`), còn project
đích lấy từ `argv[3]` → `SPECKIT_PROJECT` → `cwd` — nên một bản driver phục vụ mọi
project.

**Driver không bao giờ ghi vào repo thật.** `build`/`e2e`/`update` copy repo sang
`$TMPDIR`, chạy `build.sh` trên bản sao đó với URL `localhost:8777`, rồi serve bằng
`python3 -m http.server`. Nhờ vậy `catalog.json` đã commit không bị ghi đè bằng URL
localhost. (Catalog URL bắt buộc HTTPS, **trừ localhost được HTTP**; `file://` bị từ
chối — chính ngoại lệ đó làm verify offline khả thi.)

**`e2e` luôn dựng project spec-kit trắng.** `bundle install` kiểm tra idempotent
theo **id**, không so version, nên cài trên máy đã có sẵn sẽ skip và che giấu cấu
hình catalog sai. `e2e` khẳng định cả chiều âm: chưa đăng ký catalog thì install
**phải** fail với `not found in any catalog`.

## Bất biến khi sửa

- **Không sửa `.specify/extensions/` trong project tiêu thụ** — đó là bản cài, sẽ bị
  ghi đè. Sửa ở `extensions/<id>/` trong repo này.
- **Version pin phải khớp tuyệt đối** giữa `extension.yml` và mọi `bundle.yml` tham
  chiếu nó, nếu không mọi `bundle install` sẽ lỗi `is pinned to version A ... but the
  resolved version is B`. Luôn dùng `./scripts/bump.sh`, đừng sửa version bằng tay.
- **Trong command body của extension, dùng token `__SPECKIT_COMMAND_PLAN__` /
  `__SPECKIT_COMMAND_TASKS__` / `__SPECKIT_COMMAND_IMPLEMENT__` / `__SPECKIT_COMMAND_SPECIFY__`**,
  không hard-code `/speckit.plan` — mỗi agent dùng separator khác nhau. `e2e` có
  check khẳng định token render đúng thành `/speckit-*`.
- **`build.sh` chạy `rm -rf dist/`**, nên bundle artifact phải build *sau* khi sinh
  `catalog.json` (`bundle build` gọi validate, mà validate resolve reference theo
  catalog). Giữ nguyên thứ tự đó.
- **`bundle validate` resolve reference theo project CHỨA bundle, không theo cwd**, và
  reference không verify được bị hạ xuống warning rồi pass. `validate` xanh gần như
  không chứng minh gì — chỉ `e2e` mới là bằng chứng.

## Phát hành và đẩy xuống project

```bash
# sửa extensions/<id>/ rồi:
./scripts/bump.sh phases 0.2.1
./scripts/build.sh
cd ../Retail-OPS && node .claude/skills/run-speckit/driver.mjs all   # verify trước khi publish
git add -A && git commit -m "phases 0.2.1: <mô tả>"
git push                                    # catalog.json phải lên `main` trước
gh release upload latest dist/*.zip --clobber
```

Remote: `quangman2211/speckit-catalog` (public). `catalog_url` là raw của nhánh
`main`, `download_url` trỏ tới **rolling tag `latest`** — nên release và
`catalog.json` phải cập nhật cùng lúc, và `--clobber` là bắt buộc vì asset trùng tên.
Catalog public: dev khác không cần token.

Đẩy vào project đang dùng: `node <driver> update [project]`. **Đừng dùng
`specify extension update`** (interactive, không có `--yes`, abort khi không TTY) và
đừng trông vào cài lại bundle mới (idempotent theo id → báo thành công nhưng giữ
extension cũ). Catalog bị cache 3600s không refresh được từ CLI; `update` xoá
`.specify/extensions/.cache` rồi chạy `specify extension add <id> --force` (giữ
nguyên config đã tuỳ chỉnh).

Thử nhanh khi chưa muốn bump version:
`specify extension add --dev <path>/extensions/phases`.

Skill mới cài chỉ xuất hiện sau khi **restart Claude Code**.

## Thêm extension / bundle mới

Extension: tạo `extensions/<id>/` với `extension.yml` (`extension`, `requires`,
`provides.commands` + `provides.config`, `hooks`, `config.defaults`), các file
command trong `commands/`, `config-template.yml`, `.extensionignore`. `build.sh` tự
nhặt mọi thư mục có `extension.yml`; không cần sửa script.

Bundle: tạo `bundles/<id>/bundle.yml` liệt kê extension trong `provides.extensions`
kèm version pin — kể cả extension ship sẵn của `specify-cli` (`git`,
`agent-context`).
