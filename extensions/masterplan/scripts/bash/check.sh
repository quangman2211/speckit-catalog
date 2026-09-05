#!/usr/bin/env bash
# Tam tieu chi tu kiem cho roadmap + prompt lat — nhung cai KIEM DUOC BANG MAY.
#
#   check.sh [project-dir]
#
# Hai tieu chi con lai cua bo chin ("lat 001 co phai walking skeleton khong",
# "moi tinh nang trong blueprint da nam trong mot lat hoac muc Ngoai pham vi
# chua") can doc hieu, nen thuoc phan LLM cua lenh /speckit-masterplan-check.
# Script nay co y KHONG doan nhung cho do.
#
# In tung dong `[OK]` / `[FAIL]` / `[INFO]`, ket bang mot dong tong.
# Exit 1 neu co bat ky FAIL nao — de CI hoac extension `gates` dung duoc.
set -uo pipefail

ROOT="${1:-$PWD}"
cd "$ROOT" 2>/dev/null || { echo "[FAIL] khong vao duoc $ROOT"; exit 1; }

CONFIG=".specify/extensions/masterplan/masterplan-config.yml"
cfg() {
  local v=""
  [ -f "$CONFIG" ] && v=$(sed -n "s/^[[:space:]]*$1:[[:space:]]*\([^#]*\).*/\1/p" "$CONFIG" | head -1 | tr -d ' "')
  printf '%s' "${v:-$2}"
}
ROADMAP=$(cfg roadmap "docs/05-roadmap.md")
SLICE_DIR=$(cfg slice_dir "docs/slices")
MIN=$(cfg prompt_min_lines 10)
MAX=$(cfg prompt_max_lines 25)
case "$MIN" in ''|*[!0-9]*) MIN=10 ;; esac
case "$MAX" in ''|*[!0-9]*) MAX=25 ;; esac

FAILED=0
ok()   { printf '[OK]   %s\n' "$*"; }
bad()  { printf '[FAIL] %s\n' "$*"; FAILED=1; }
info() { printf '[INFO] %s\n' "$*"; }

[ -f "$ROADMAP" ] || { bad "khong tim thay $ROADMAP — chay /speckit-masterplan-slice truoc"; exit 1; }

# Rut cac dong lat ra file tam: "id<TAB>ten<TAB>demo<TAB>phu-thuoc"
TMP=$(mktemp) || exit 1
trap 'rm -f "$TMP"' EXIT
awk -F'|' '
  /^[[:space:]]*\|/ && NF >= 9 {
    id = $2; gsub(/[[:space:]]/, "", id)
    if (id !~ /^[0-9][0-9][0-9]$/) next
    name = $3; gsub(/`/, "", name); gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
    demo = $4; gsub(/^[[:space:]]+|[[:space:]]+$/, "", demo)
    dep  = $5; gsub(/^[[:space:]]+|[[:space:]]+$/, "", dep)
    printf "%s\t%s\t%s\t%s\n", id, name, demo, dep
  }
' "$ROADMAP" > "$TMP"

TOTAL=$(wc -l < "$TMP" | tr -d ' ')
[ "$TOTAL" -gt 0 ] || { bad "$ROADMAP khong co dong lat nao doc duoc (can bang 8 cot, cot dau la 3 chu so)"; exit 1; }
info "doc duoc $TOTAL lat tu $ROADMAP"

# ---------------------------------------------------------------- C1 ten lat
# Ten lat la ten mot TANG KY THUAT = da cat theo tang, khong cat theo lat.
# Cat theo tang thi khong lat nao demo duoc mot minh.
LAYERS="database|backend|frontend|setup|infra|infrastructure|db|ui|migration|refactor|config|boilerplate|scaffold|api"
c1=1
while IFS=$'\t' read -r id name demo dep; do
  n=$(printf '%s' "$name" | tr 'A-Z' 'a-z')
  all_layer=1
  for tok in $(printf '%s' "$n" | tr '_-' '  '); do
    printf '%s' "$tok" | grep -qE "^($LAYERS)$" || { all_layer=0; break; }
  done
  [ "$all_layer" = "1" ] && { bad "C1 ten lat: $id \`$name\` la ten tang ky thuat, khong phai mot lat demo duoc"; c1=0; }
done < "$TMP"
[ "$c1" = "1" ] && ok "C1 ten lat: khong lat nao dat ten theo tang ky thuat"

# ---------------------------------------------------------------- C2 demo
c2=1
while IFS=$'\t' read -r id name demo dep; do
  d=$(printf '%s' "$demo" | tr -d ' —-')
  [ -z "$d" ] && { bad "C2 demo: $id \`$name\` khong tra loi duoc \"merge xong demo duoc gi\""; c2=0; }
done < "$TMP"
[ "$c2" = "1" ] && ok "C2 demo: moi lat deu noi ro merge xong demo duoc gi"

# ---------------------------------------------------------------- C3 phu thuoc
# Phu thuoc phai tro NGUOC ve lat co so nho hon. Tro toi = khong bao gio chay duoc.
c3=1
while IFS=$'\t' read -r id name demo dep; do
  for d in $(printf '%s' "$dep" | grep -oE '[0-9]{3}' || true); do
    if [ "$d" -ge "$id" ] 2>/dev/null; then
      bad "C3 phu thuoc: $id \`$name\` phu thuoc $d — bang hoac di sau chinh no"; c3=0
    fi
    grep -q "^$d	" "$TMP" || { bad "C3 phu thuoc: $id \`$name\` phu thuoc $d nhung khong co lat $d trong roadmap"; c3=0; }
  done
done < "$TMP"
[ "$c3" = "1" ] && ok "C3 phu thuoc: thu tu khong co phu thuoc nguoc"

# ---------------------------------------------------------------- C4 co prompt
c4=1
while IFS=$'\t' read -r id name demo dep; do
  f=$(find "$SLICE_DIR" -maxdepth 1 -name "$id-*.md" 2>/dev/null | head -1)
  [ -z "$f" ] && { bad "C4 co prompt: lat $id \`$name\` chua co file prompt trong $SLICE_DIR/"; c4=0; }
done < "$TMP"
[ "$c4" = "1" ] && ok "C4 co prompt: moi lat trong roadmap deu co file prompt"

# ---------------------------------------------------------------- C5 do dai
# Dai qua = lat om nhieu quyet dinh, /speckit.clarify se hoi lap.
# Ngan qua = chua du de specify, spec se toan suy dien.
c5=1; any_prompt=0
for f in "$SLICE_DIR"/[0-9][0-9][0-9]-*.md; do
  [ -f "$f" ] || continue
  any_prompt=1
  n=$(grep -cvE '^[[:space:]]*(<!--.*-->)?[[:space:]]*$' "$f" | tr -d ' ')
  if [ "$n" -lt "$MIN" ] || [ "$n" -gt "$MAX" ]; then
    bad "C5 do dai: $(basename "$f") co $n dong, gioi han $MIN-$MAX"; c5=0
  fi
done
[ "$any_prompt" = "0" ] && { bad "C5 do dai: khong co file prompt nao trong $SLICE_DIR/"; c5=0; }
[ "$c5" = "1" ] && ok "C5 do dai: moi prompt nam trong $MIN-$MAX dong"

# ---------------------------------------------------------------- C6 framework
# Prompt cua /speckit.specify noi CAI GI. Framework, thu vien, san pham CSDL
# la viec cua /speckit.plan. Nhac o day = chot ky thuat truoc khi chot pham vi.
FW='react|vue\.js|angular|svelte|next\.js|nextjs|nuxt|remix|django|flask|fastapi|express\.js|nestjs|rails|laravel|spring boot|postgres|postgresql|mysql|sqlite|mongodb|redis|kafka|rabbitmq|tailwind|bootstrap|prisma|sequelize|typeorm|kubernetes|graphql|grpc|typescript|golang'
c6=1
for f in "$SLICE_DIR"/[0-9][0-9][0-9]-*.md; do
  [ -f "$f" ] || continue
  hits=$(grep -ioE "$FW" "$f" 2>/dev/null | sort -u | tr '\n' ' ')
  [ -n "$hits" ] && { bad "C6 framework: $(basename "$f") nhac ky thuat cu the: $hits"; c6=0; }
done
[ "$c6" = "1" ] && [ "$any_prompt" = "1" ] && ok "C6 framework: khong prompt nao nhac framework hay san pham cu the"

# ---------------------------------------------------------------- C7 cho treo
# Khong phai loi. Nhung con nhieu cho treo ma da chay specify thi
# /speckit.clarify se phai hoi lai dung nhung cho do.
PENDING=0
CONTRACTS_DIR=$(cfg contracts_dir "contracts")
for f in "$ROADMAP" "$SLICE_DIR"/[0-9][0-9][0-9]-*.md "$CONTRACTS_DIR"/*.md ".specify/memory/constitution.md"; do
  [ -f "$f" ] || continue
  n=$(grep -o '\[CAN USER QUYET\]\|\[CẦN USER QUYẾT\]\|\[CAN QUYET\]\|\[NEEDS CLARIFICATION\]' "$f" 2>/dev/null | wc -l | tr -d ' ')
  PENDING=$((PENDING + ${n:-0}))
done
info "C7 cho treo: $PENDING cho danh dau can nguoi quyet (roadmap, prompt, contracts, constitution)"

# ---------------------------------------------------------------- C8 constitution
# Cau chung chung trong constitution khong rang buoc duoc ai. "Viet code sach"
# khong bao gio lam mot PR bi tu choi.
CONST=".specify/memory/constitution.md"
if [ -f "$CONST" ]; then
  VAGUE=$(grep -ioE 'code sach|clean code|best practice|thuc hanh tot|maintainable|de bao tri|chat luong cao|high quality' "$CONST" 2>/dev/null | sort -u | tr '\n' ' ')
  if [ -n "$VAGUE" ]; then
    bad "C8 constitution: co cau chung chung khong rang buoc duoc ai: $VAGUE"
  else
    ok "C8 constitution: khong co cau chung chung"
  fi
else
  info "C8 constitution: chua co $CONST"
fi

# ---------------------------------------------------------------- tong
echo
if [ "$FAILED" = "0" ]; then
  echo "TONG: dat het cac tieu chi kiem duoc bang may."
else
  echo "TONG: co tieu chi chua dat (xem cac dong [FAIL] o tren)."
fi
echo "Con hai tieu chi phai doc moi biet — lenh /speckit-masterplan-check se soat tiep:"
echo "  - lat dau tien co phai walking skeleton (chay duoc, khong nghiep vu) khong"
echo "  - moi tinh nang trong blueprint da nam trong mot lat hoac muc 'Ngoai pham vi' chua"
exit $FAILED
