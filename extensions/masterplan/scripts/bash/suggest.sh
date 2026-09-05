#!/usr/bin/env bash
# Hook entry cho `user_prompt_submit`. Doc trang thai tang du an tu state.sh
# roi bom mot goi y ngan vao context — hoac im lang.
#
# Chay qua dispatcher: .specify/events.py -> command speckit.masterplan.status
# -> frontmatter `scripts.sh` -> file nay. Payload JSON den qua stdin, cwd la
# goc project.
#
# Ba luat, theo dung thu tu quan trong:
#   1. Khong co gi de noi thi KHONG IN GI. Hook chay moi luot; on ao la bi go.
#   2. Khong lap lai cung mot goi y moi luot — chi nhac khi doi noi dung,
#      hoac sau `repeat_after` luot.
#   3. Luon exit 0. Hook nay chi goi y, khong bao gio chan.
set -uo pipefail

# Nuot stdin de dispatcher khong gap broken pipe. Khong dung toi noi dung:
# tang duoc suy tu file, khong suy tu cau nguoi dung go.
cat >/dev/null 2>&1 || true

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_SH="$HERE/state.sh"
[ -x "$STATE_SH" ] || exit 0

STATE_JSON=$("$STATE_SH" "$PWD" 2>/dev/null) || exit 0

field() { printf '%s' "$STATE_JSON" | sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p" | head -1; }

ALT=$(field altitude)
[ -n "$ALT" ] || exit 0
[ "$ALT" = "none" ] && exit 0

NEXT_ID=$(field next_id)
NEXT_NAME=$(field next_name)
NEXT_GATE=$(field next_gate)
[ "$NEXT_GATE" = "none" ] && NEXT_GATE=""

# Phan tu dau tien cua mang `missing` — thu tu trong state.sh la thu tu uu tien.
NEXT=$(printf '%s' "$STATE_JSON" \
  | tr -d '\n' \
  | sed -n 's/.*"missing": *\[\([^]]*\)\].*/\1/p' \
  | sed -n 's/^ *"\([^"]*\)".*/\1/p')
[ -n "$NEXT" ] || exit 0

CONFIG=".specify/extensions/masterplan/masterplan-config.yml"
cfg() {
  local v=""
  [ -f "$CONFIG" ] && v=$(sed -n "s/^[[:space:]]*$1:[[:space:]]*\([^#]*\).*/\1/p" "$CONFIG" | head -1 | tr -d ' "')
  printf '%s' "${v:-$2}"
}
[ "$(cfg enabled true)" = "false" ] && exit 0
REPEAT_AFTER=$(cfg repeat_after 10)
case "$REPEAT_AFTER" in ''|*[!0-9]*) REPEAT_AFTER=10 ;; esac

# ---------------------------------------------------------------- goi y
case "$NEXT" in
  blueprint)
    CMD="/speckit-masterplan-architect"
    WHY="Chua co blueprint. Cat lat truoc khi biet dang xay gi thi lat nao cung phai sua lai." ;;
  architecture)
    CMD="/speckit-masterplan-design"
    WHY="Co blueprint nhung chua co ban thiet ke he thong — chua biet ranh gioi nam o dau thi khong cat duoc." ;;
  adr)
    CMD="/speckit-masterplan-decide"
    WHY="Chua ADR nao. Quyet dinh mot chieu ma khong ghi lai thi ba thang sau khong ai biet vi sao." ;;
  contracts)
    CMD="/speckit-masterplan-contracts"
    WHY="Chua co hop dong dung chung. Moi lat se tu dat ten bang va endpoint theo y no." ;;
  roadmap)
    CMD="/speckit-masterplan-slice"
    WHY="Da co thiet ke nhung chua cat lat. Day la buoc noi tang du an voi spec-kit." ;;
  prompts)
    CMD="/speckit-masterplan-slice"
    WHY="Co roadmap nhung chua sinh prompt cho tung lat." ;;
  constitution)
    CMD="/speckit-constitution"
    WHY="Luat du an chua viet — moi spec sau se khong co gi de doi chieu." ;;
  next)
    CMD="/speckit-masterplan-next"
    WHY="Lat ke tiep: $NEXT_ID $NEXT_NAME${NEXT_GATE:+ (cong chan: $NEXT_GATE)}." ;;
  done|*) exit 0 ;;
esac

# ---------------------------------------------------------------- lenh co that
have_cmd() { [ -d ".claude/skills/$(printf '%s' "$1" | sed 's|^/||')" ]; }
have_cmd "$CMD" || exit 0

# ---------------------------------------------------------------- chong lap
SIG="$ALT:$NEXT:$NEXT_ID"
STATE_FILE=".specify/extensions/masterplan/.hint-state"
LAST_SIG=""; COUNT=0
if [ -f "$STATE_FILE" ]; then
  LAST_SIG=$(sed -n '1p' "$STATE_FILE")
  COUNT=$(sed -n '2p' "$STATE_FILE")
  case "$COUNT" in ''|*[!0-9]*) COUNT=0 ;; esac
fi

mkdir -p "$(dirname "$STATE_FILE")" 2>/dev/null
if [ "$SIG" = "$LAST_SIG" ] && [ "$COUNT" -lt "$REPEAT_AFTER" ]; then
  printf '%s\n%s\n' "$SIG" "$((COUNT + 1))" > "$STATE_FILE" 2>/dev/null
  exit 0
fi
printf '%s\n%s\n' "$SIG" "1" > "$STATE_FILE" 2>/dev/null

# ---------------------------------------------------------------- in
# `user_prompt_submit` cho phep stdout thuong di thang vao context model doc duoc.
DONE=$(printf '%s' "$STATE_JSON" | sed -n 's/.*"done": *\([0-9]*\).*/\1/p' | head -1)
TOTAL=$(printf '%s' "$STATE_JSON" | sed -n 's/.*"total": *\([0-9]*\).*/\1/p' | head -1)
case "$ALT" in
  blueprint) WHERE="tang du an — chua cat lat" ;;
  slice)     WHERE="tang lat — ${DONE:-0}/${TOTAL:-0} lat da merge" ;;
esac
cat <<HINT
<masterplan-hint>
Dang o: $WHERE
Thieu: $WHY
Nen chay: $CMD
(Goi y tu extension masterplan. Tat bang enabled: false trong $CONFIG)
</masterplan-hint>
HINT
exit 0
