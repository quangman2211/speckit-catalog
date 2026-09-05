# speckit-catalog

Hạ tầng Spec-Driven Development dùng chung cho mọi project trong `Quang-Man-Project/`:
catalog extension nội bộ, bundle, và skill `run-speckit` để chạy/verify toàn hệ thống.

```
.claude/skills/run-speckit/   # skill + driver — bản gốc duy nhất
  SKILL.md
  driver.mjs
extensions/frontend/          # source extension
bundles/retail-frontend/      # bundle manifest (KHÔNG chứa payload)
scripts/bump.sh               # bump version extension + mọi bundle pin nó
scripts/build.sh              # zip extension + sinh catalog.json + build bundle
catalog.json                  # sinh ra, KHÔNG sửa tay
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

## Cài cho một dev mới

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git --force

cd <project>
specify extension catalog add \
  https://raw.githubusercontent.com/quangman2211/speckit-catalog/main/catalog.json \
  --name quangman --priority 1 --install-allowed
specify bundle install retail-frontend
```

Catalog public nên không cần token. Chưa đăng ký catalog thì `bundle install` báo
`Extension 'frontend' not found in any catalog` — extension tự viết không đi kèm bundle.

## Chạy và verify

Project đích là thư mục đang đứng (`cwd`), hoặc tham số thứ hai.

```bash
cd <project>
node .claude/skills/run-speckit/driver.mjs all       # 21 check, exit 0 khi sạch
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
./scripts/bump.sh frontend 1.0.1   # bump extension + pin trong mọi bundle + version bundle
./scripts/build.sh                 # artifact + catalog.json với URL production
git add -A && git commit -m "frontend 1.0.1: <mô tả>"
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
✓ Installed 'retail-frontend' (0 added, 3 already present).
  ✓ Frontend Workflow (v1.0.0)     ← vẫn bản cũ
  retail-frontend v1.1.0           ← bundle báo 1.1.0
```

Chi tiết đầy đủ các bẫy nằm ở `.claude/skills/run-speckit/SKILL.md`.
