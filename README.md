# speckit-catalog

Hạ tầng Spec-Driven Development dùng chung cho mọi project trong `Quang-Man-Project/`:
catalog extension nội bộ, bundle, và skill `run-speckit` để chạy/verify toàn hệ thống.

```
.claude/skills/run-speckit/   # skill + driver — bản gốc duy nhất
  SKILL.md
  driver.mjs
extensions/masterplan/        # tầng dự án: blueprint → kiến trúc → hợp đồng → roadmap → lát
bundles/qm-sdd/           # bundle manifest (KHÔNG chứa payload)
scripts/bump.sh               # bump version extension + mọi bundle pin nó
scripts/build.sh              # zip extension + sinh catalog.json + build bundle
catalog.json                  # catalog extension — sinh ra, KHÔNG sửa tay
bundle-catalog.json           # catalog bundle — stack riêng, cũng sinh ra
dist/                         # artifact, gitignored
```

## Vì sao repo này tồn tại

`specify bundle install` **không đọc payload nằm trong thư mục bundle**. Artifact
bundle chỉ có `bundle.yml` + `README.md`. Lúc install, `specify` giải quyết extension
theo đúng hai đường: extension ship sẵn trong `specify-cli`, hoặc một catalog đang
active có `install_allowed: true`. Extension tự viết **bắt buộc** phải đi qua một
catalog — đó là repo này.

## Nối skill vào một project

Claude Code nạp `.claude/skills/` từ thư mục khởi động và các thư mục cha **tới repo
root**. Mỗi project là một git repo riêng nên walk-up không với tới `Quang-Man-Project/`.
Symlink được hỗ trợ đầy đủ:

```bash
cd <project>/.claude/skills
ln -s ../../../speckit-catalog/.claude/skills/run-speckit run-speckit
```

Đã dựng sẵn cho `Retail-OPS`. Restart Claude Code để `/run-speckit` xuất hiện.

## Cài đặt

### Yêu cầu

`uv`, `node >= 18`, `python3` kèm `pyyaml`, `zip`, `git`. Rồi cài `specify` CLI:

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git --force
specify --version
```

### 1 · Đăng ký catalog

`specify` có **hai stack catalog tách rời**: một cho extension, một cho bundle.
Cùng một repo phục vụ cả hai, nhưng phải đăng ký riêng — và cú pháp cờ khác nhau.
Làm một lần cho **mỗi project**; catalog public nên không cần token:

```bash
cd <project>

specify extension catalog add \
  https://raw.githubusercontent.com/quangman2211/speckit-catalog/main/catalog.json \
  --name quangman --priority 1 --install-allowed

specify bundle catalog add \
  https://raw.githubusercontent.com/quangman2211/speckit-catalog/main/bundle-catalog.json \
  --id quangman --priority 1 --policy install-allowed
```

Không phải gõ nhầm: extension catalog dùng `--name` + cờ `--install-allowed`,
còn bundle catalog dùng `--id` + `--policy install-allowed`.

Bỏ dòng đầu thì báo `Extension 'masterplan' not found in any catalog`; bỏ dòng
sau thì báo `Bundle 'qm-sdd' was not found in any configured catalog`.
Extension và bundle tự viết đều không đi kèm trong artifact — bắt buộc qua catalog.

`--priority 1` để catalog của mình thắng catalog mặc định của spec-kit khi trùng
tên. Chuyện này có thật: community catalog của spec-kit có sẵn một extension tên
`blueprint` làm việc hoàn toàn khác — đó là lý do extension ở đây tên `masterplan`.

### 2 · Cài

Cả bộ (`git` + `agent-context` + `masterplan`):

```bash
specify bundle install qm-sdd
```

Hoặc chỉ riêng `masterplan` (không cần bundle catalog):

```bash
specify extension add masterplan
```

### 3 · Nối hook — **không bỏ được**

```bash
specify integration upgrade claude
```

`specify bundle install` cài extension nhưng **không ghi khối `events:`** ra
`.claude/settings.json` — hàm ghi hook chỉ chạy từ đường `extension add/remove/update`
và `init`. Bỏ bước này thì 8 lệnh vẫn gọi tay được, chỉ mất phần gợi ý tự động.

### 4 · Restart Claude Code

Skill mới cài chỉ xuất hiện sau khi khởi động lại. Sau đó gõ `/speckit-masterplan-`
sẽ thấy 8 lệnh.

### 5 · Kiểm đã cài đúng chưa

```bash
specify extension list | grep Masterplan          # → ✓ Masterplan (v0.1.0)
ls .claude/skills | grep -c speckit-masterplan    # → 8
grep -o 'speckit\.masterplan\.status' .claude/settings.json   # → có dòng này
.specify/extensions/masterplan/scripts/bash/state.sh            # → JSON, altitude: blueprint
```

Bốn dòng đúng hết là xong. Muốn kiểm kỹ hơn thì chạy `driver.mjs all` ở mục dưới —
nó dựng hẳn một project trắng rồi cài lại từ đầu.

### Ai đã cài `phases` (bản cũ) thì gỡ tay

```bash
specify extension remove phases --force
```

`bundle install` kiểm idempotent theo **id**, không so version, nên cài bundle mới
sẽ **không** gỡ `phases` hộ — nó báo thành công và giữ nguyên extension cũ.

### Thử bản local chưa publish

```bash
specify extension add --dev ~/Quang-Man-Project/speckit-catalog/extensions/masterplan
```

Không cần bump version, không cần release. Đường này cũng tự ghi hook.

## Dùng masterplan

`masterplan` làm phần spec-kit không có: spec-kit dừng ở **một feature**, còn
`masterplan` làm tầng trên nó.

```
TẦNG DỰ ÁN (chạy một lần)
  /speckit-masterplan-architect     hỏi đáp 5 vòng → docs/01-blueprint.md
  /speckit-masterplan-design        → docs/02-architecture.md
  /speckit-masterplan-decide        → docs/04-decisions/ADR-NNN-*.md
  /speckit-masterplan-contracts     → contracts/*.md
  /speckit-masterplan-slice         → docs/05-roadmap.md + docs/slices/NNN-*.md
  /speckit-masterplan-check         9 tiêu chí tự kiểm, sửa hết [FAIL] rồi mới đi tiếp
  /speckit.constitution
       │
       ▼  mỗi lát = một prompt dán tay
TẦNG FEATURE (spec-kit)
  /speckit-masterplan-next          kiểm cổng chặn → in prompt
  /speckit.specify ← dán prompt
  /speckit.clarify → .plan → .tasks → .implement → .analyze
  merge → đánh dấu ✅ trong docs/05-roadmap.md
```

Chi tiết từng lệnh: `extensions/masterplan/README.md`.

## Chạy và verify

Project đích là thư mục đang đứng (`cwd`), hoặc tham số thứ hai.

```bash
cd <project>
node .claude/skills/run-speckit/driver.mjs all       # toàn bộ, exit 0 khi sạch
node .claude/skills/run-speckit/driver.mjs doctor    # toolchain + cấu trúc
node .claude/skills/run-speckit/driver.mjs build     # đóng gói trên bản sao tạm
node .claude/skills/run-speckit/driver.mjs e2e       # cài trên project TRẮNG
node .claude/skills/run-speckit/driver.mjs gate      # cổng "hệ thống trước, code sau"
node .claude/skills/run-speckit/driver.mjs update    # đồng bộ extension từ catalog
```

`e2e` dựng project spec-kit trắng trong `$TMPDIR` rồi cài catalog + bundle vào đó.
Verify trên máy đã cài sẵn là vô nghĩa: `bundle install` kiểm tra idempotent theo
**id**, không so version, nên bỏ qua thành phần đã có và che giấu cấu hình catalog sai.

## Build

```bash
./scripts/build.sh                                              # URL production
./scripts/build.sh http://localhost:8777/dist http://localhost:8777/catalog.json
```

## Test local

Catalog URL bắt buộc HTTPS, **trừ localhost được phép HTTP** — `file://` bị từ chối
thẳng. Chính ngoại lệ đó làm cho verify offline khả thi:

```bash
python3 -m http.server 8777 --directory .
specify extension catalog add http://localhost:8777/catalog.json \
  --name quangman --priority 1 --install-allowed
```

Driver tự làm việc này trên một **bản sao tạm**, nên `catalog.json` đã commit không
bao giờ bị ghi đè bằng URL localhost.

## Phát hành version mới

```bash
# sửa code trong extensions/<id>/ rồi:
./scripts/bump.sh masterplan 0.2.0  # bump extension + pin trong mọi bundle + version bundle
./scripts/build.sh                  # artifact + catalog.json với URL production
git add -A && git commit -m "masterplan 0.2.0: <mô tả>"
```

Rồi đẩy artifact lên release. Tag `latest` là **rolling** — `catalog.json` luôn trỏ
tới nó, nên lần đầu dùng `create`, các lần sau phải `upload --clobber` (asset trùng
tên sẽ bị từ chối nếu thiếu `--clobber`):

```bash
git push
gh release upload latest dist/*.zip --clobber
```

Đừng bump bằng tay: version pin được kiểm tra lúc `bundle install`, bump extension mà
quên bump pin sẽ làm mọi lần install bundle báo lỗi
`is pinned to version A ... but the resolved version is B`.

## Đẩy version mới vào các project đang dùng

```bash
cd <project> && node .claude/skills/run-speckit/driver.mjs update
```

Không dùng `specify extension update`: nó hỏi `[y/N]` và **không có `--yes`** nên
abort khi không có TTY, còn catalog bị cache 1 giờ (`CACHE_DURATION = 3600`) không
refresh được từ CLI nên thường báo "Up to date" sai.

Cũng đừng trông vào việc cài lại bundle mới — nó báo thành công nhưng giữ nguyên
extension cũ:

```
✓ Installed 'qm-sdd' (0 added, 3 already present).
  ✓ Masterplan (v0.1.0)            ← vẫn bản cũ
  qm-sdd v2.1.0                ← bundle báo 2.1.0
```

Chi tiết đầy đủ các bẫy nằm ở `.claude/skills/run-speckit/SKILL.md`.
