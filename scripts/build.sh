#!/usr/bin/env bash
# Zip moi extension trong extensions/ va sinh lai catalog.json.
#
#   ./scripts/build.sh                               # dung URL prod mac dinh
#   ./scripts/build.sh <zip_base_url> [catalog_url]  # override cho test local
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROD_BASE_URL="https://github.com/quangman2211/speckit-catalog/releases/download/latest"
PROD_CATALOG_URL="https://raw.githubusercontent.com/quangman2211/speckit-catalog/main/catalog.json"
BASE_URL="${1:-$PROD_BASE_URL}"
CATALOG_URL="${2:-$PROD_CATALOG_URL}"
DIST="$ROOT/dist"

rm -rf "$DIST"; mkdir -p "$DIST"

for extdir in "$ROOT"/extensions/*/; do
  [ -f "$extdir/extension.yml" ] || continue
  id=$(python3 -c "import yaml,sys;print(yaml.safe_load(open(sys.argv[1]))['extension']['id'])" "$extdir/extension.yml")
  ver=$(python3 -c "import yaml,sys;print(yaml.safe_load(open(sys.argv[1]))['extension']['version'])" "$extdir/extension.yml")
  # Zip voi extension.yml o goc archive (khong boc them thu muc cha).
  ( cd "$extdir" && zip -qr "$DIST/${id}-${ver}.zip" . -x '.DS_Store' -x '*/__pycache__/*' )
  echo "packed ${id}-${ver}.zip"
done

# Bundle artifact duoc build SAU khi catalog.json da co, vi `bundle build` chay
# validate va validate resolve reference theo catalog cua project chua bundle.
build_bundles() {
  for bdir in "$ROOT"/bundles/*/; do
    [ -f "$bdir/bundle.yml" ] || continue
    bid=$(python3 -c "import yaml,sys;print(yaml.safe_load(open(sys.argv[1]))['bundle']['id'])" "$bdir/bundle.yml")
    bver=$(python3 -c "import yaml,sys;print(yaml.safe_load(open(sys.argv[1]))['bundle']['version'])" "$bdir/bundle.yml")
    if specify bundle build --path "$bdir" --output "$DIST" >/dev/null 2>&1; then
      echo "packed ${bid}-${bver}.zip"
    else
      echo "WARN: bundle build that bai cho '${bid}' (catalog khong resolve duoc?)" >&2
    fi
  done
}

python3 - "$ROOT" "$BASE_URL" "$CATALOG_URL" <<'PY'
import json, sys, datetime, pathlib, yaml

root = pathlib.Path(sys.argv[1])
base_url = sys.argv[2].rstrip("/")
catalog_url = sys.argv[3]

extensions = {}
for manifest in sorted(root.glob("extensions/*/extension.yml")):
    data = yaml.safe_load(manifest.read_text())
    ext = data["extension"]
    entry = {
        "id": ext["id"],
        "name": ext["name"],
        "version": ext["version"],
        "description": ext["description"],
        "author": ext.get("author", ""),
        "license": ext.get("license", "MIT"),
        "download_url": f"{base_url}/{ext['id']}-{ext['version']}.zip",
        "requires": data.get("requires", {"speckit_version": ">=0.9.0"}),
        "tags": data.get("tags", []),
    }
    if ext.get("repository"):
        entry["repository"] = ext["repository"]
    extensions[ext["id"]] = entry

catalog = {
    "schema_version": "1.0",
    "updated_at": datetime.date.today().isoformat(),
    "catalog_url": catalog_url,
    "extensions": extensions,
}
out = root / "catalog.json"
out.write_text(json.dumps(catalog, indent=2, ensure_ascii=False) + "\n")
print(f"wrote catalog.json ({len(extensions)} extension(s), zips={base_url})")
PY

build_bundles

# Bundle catalog la mot stack RIENG voi extension catalog (`specify bundle
# catalog add`, payload bat buoc co object `bundles`). Khong sinh file nay thi
# `specify bundle install <id>` theo ten luon bao "not found in any configured
# catalog" — bundle chi cai duoc tu duong dan zip.
python3 - "$ROOT" "$BASE_URL" "$CATALOG_URL" <<'BPY'
import json, sys, datetime, pathlib, hashlib, yaml

root = pathlib.Path(sys.argv[1])
base_url = sys.argv[2].rstrip("/")
catalog_url = sys.argv[3]
# Cung thu muc voi catalog.json, khac ten file.
bundle_catalog_url = catalog_url.rsplit("/", 1)[0] + "/bundle-catalog.json"
dist = root / "dist"

bundles = {}
for manifest in sorted(root.glob("bundles/*/bundle.yml")):
    data = yaml.safe_load(manifest.read_text())
    b = data["bundle"]
    artifact = dist / f"{b['id']}-{b['version']}.zip"
    entry = {
        "id": b["id"],
        "name": b["name"],
        "version": b["version"],
        "role": b.get("role", "developer"),
        "description": b["description"],
        "author": b.get("author", ""),
        "license": b.get("license", "MIT"),
        "download_url": f"{base_url}/{b['id']}-{b['version']}.zip",
        "requires": data.get("requires", {"speckit_version": ">=0.9.0"}),
        "provides": {k: len(v) for k, v in (data.get("provides") or {}).items()},
        "tags": data.get("tags", []),
    }
    if artifact.is_file():
        entry["sha256"] = hashlib.sha256(artifact.read_bytes()).hexdigest()
    bundles[b["id"]] = entry

out = root / "bundle-catalog.json"
out.write_text(json.dumps({
    "schema_version": "1.0",
    "updated_at": datetime.date.today().isoformat(),
    "catalog_url": bundle_catalog_url,
    "bundles": bundles,
}, indent=2, ensure_ascii=False) + "\n")
print(f"wrote bundle-catalog.json ({len(bundles)} bundle(s))")
BPY
