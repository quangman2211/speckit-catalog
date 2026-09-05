# speckit-catalog

Catalog nội bộ chứa extension và bundle Spec Kit do team tự viết và tự kiểm duyệt.

```
extensions/frontend/        # source extension
bundles/retail-frontend/    # bundle manifest (không chứa payload)
scripts/bump.sh             # bump version extension + mọi bundle pin nó
scripts/build.sh            # zip extension + sinh catalog.json + build bundle
catalog.json                # sinh ra, KHÔNG sửa tay
dist/                       # artifact, gitignored
```

## Vì sao cần repo này

`specify bundle install` không đọc payload nằm trong thư mục bundle. Nó chỉ giải
quyết extension theo đúng hai đường: extension ship sẵn trong `specify-cli`, hoặc
một catalog đang active có `install_allowed: true`. Extension tự viết bắt buộc
phải đi qua một catalog — đó là repo này.

## Build

```bash
./scripts/build.sh                                              # URL production
./scripts/build.sh http://localhost:8777/dist http://localhost:8777/catalog.json
```

## Test local

Catalog URL bắt buộc là HTTPS, **trừ localhost được phép HTTP**. Nên toàn bộ chuỗi
verify được offline:

```bash
python3 -m http.server 8777 --directory .
specify extension catalog add http://localhost:8777/catalog.json \
  --name quangman --priority 1 --install-allowed
```

Harness tự động hoá việc này nằm ở `Retail-OPS/.claude/skills/run-speckit/driver.mjs`.

## Phát hành version mới

```bash
# sửa code trong extensions/<id>/ rồi:
./scripts/bump.sh frontend 1.0.1   # bump extension + pin trong mọi bundle + version bundle
./scripts/build.sh                 # sinh artifact + catalog.json với URL production
git add -A && git commit -m "frontend 1.0.1: <mô tả>"
```

Rồi tạo GitHub release và upload `dist/*.zip`.

Đừng bump bằng tay: version pin được kiểm tra lúc `bundle install`, bump extension
mà quên bump pin sẽ làm mọi lần install bundle báo lỗi
`is pinned to version A ... but the resolved version is B`.

## Đẩy version mới vào các project đang dùng

```bash
cd ../Retail-OPS
node .claude/skills/run-speckit/driver.mjs update /đường/dẫn/project
```

Không dùng `specify extension update` — nó hỏi `[y/N]` (không có `--yes`) và catalog
bị cache 1 giờ nên thường báo "Up to date" sai. Cũng đừng trông vào việc cài lại
bundle: idempotent theo id nên extension cũ bị giữ nguyên trong im lặng.
