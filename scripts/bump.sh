#!/usr/bin/env bash
# Bump version mot extension VA moi bundle pin no, trong cung mot thao tac.
#
#   ./scripts/bump.sh frontend 1.0.1
#
# Ly do ton tai: version pin duoc kiem tra luc `bundle install`. Bump extension
# ma quen bump pin trong bundle.yml se lam moi lan install bundle bao loi:
#   Extension 'X' is pinned to version A ... but the resolved version is B
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXT_ID="${1:?usage: bump.sh <extension-id> <new-version>}"
NEW_VER="${2:?usage: bump.sh <extension-id> <new-version>}"

python3 - "$ROOT" "$EXT_ID" "$NEW_VER" <<'PY'
import pathlib, re, sys

root, ext_id, new_ver = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3]

if not re.fullmatch(r"\d+\.\d+\.\d+", new_ver):
    sys.exit(f"version phai la semver X.Y.Z, nhan duoc '{new_ver}'")

ext_file = root / "extensions" / ext_id / "extension.yml"
if not ext_file.exists():
    sys.exit(f"khong thay {ext_file}")

# 1. version trong khoi `extension:` cua extension.yml
text = ext_file.read_text()
new_text, n = re.subn(
    r'(?ms)(^extension:.*?^\s+version:\s*")[^"]+(")',
    lambda m: m.group(1) + new_ver + m.group(2),
    text, count=1)
if n != 1:
    sys.exit(f"khong tim thay dong version trong khoi extension: cua {ext_file}")
old = re.search(r'(?ms)^extension:.*?^\s+version:\s*"([^"]+)"', text).group(1)
ext_file.write_text(new_text)
print(f"extension {ext_id}: {old} -> {new_ver}")

# 2. moi bundle pin extension nay
touched = 0
for bfile in sorted(root.glob("bundles/*/bundle.yml")):
    btext = bfile.read_text()
    pin_re = re.compile(r'(- id:\s*"' + re.escape(ext_id) + r'"\s*\n\s+version:\s*")[^"]+(")')
    if not pin_re.search(btext):
        continue
    btext = pin_re.sub(lambda m: m.group(1) + new_ver + m.group(2), btext)
    # bundle nao doi pin thi phai co version moi -> tang patch
    bm = re.search(r'(?ms)(^bundle:.*?^\s+version:\s*")(\d+)\.(\d+)\.(\d+)(")', btext)
    if bm:
        bumped = f"{bm.group(2)}.{bm.group(3)}.{int(bm.group(4)) + 1}"
        btext = btext[:bm.start()] + bm.group(1) + bumped + bm.group(5) + btext[bm.end():]
        print(f"bundle {bfile.parent.name}: pin {ext_id}={new_ver}, bundle version -> {bumped}")
    bfile.write_text(btext)
    touched += 1

if touched == 0:
    print(f"(khong bundle nao pin '{ext_id}')")
print("\nBuoc tiep: ./scripts/build.sh   roi commit + tao release")
PY
