# speckit-catalog

Catalog nội bộ chứa extension và bundle Spec Kit do team tự viết và tự kiểm duyệt.

```
extensions/frontend/        # source extension
bundles/retail-frontend/    # bundle manifest (không chứa payload)
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

## Publish

1. Bump `version` trong `extensions/<id>/extension.yml` **và** trong mọi
   `bundles/*/bundle.yml` tham chiếu tới nó — version pin phải khớp tuyệt đối.
2. `./scripts/build.sh` với URL production.
3. Commit `catalog.json`, tạo GitHub release, upload `dist/*.zip`.
