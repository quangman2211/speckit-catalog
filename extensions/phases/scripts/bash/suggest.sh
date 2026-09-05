#!/usr/bin/env bash
# Hook entry cho `user_prompt_submit`. Doc trang thai tu phase.sh roi bom mot
# goi y ngan vao context — hoac im lang.
#
# Chay qua dispatcher: .specify/events.py -> command speckit.phases.suggest
# -> frontmatter `scripts.sh` -> file nay. Payload JSON cua hook den qua stdin,
# cwd la goc project.
#
# Ba luat, theo dung thu tu quan trong:
#   1. Khong co gi de noi thi KHONG IN GI. Hook chay moi luot; on ao la bi go.
#   2. Khong lap lai cung mot goi y moi luot — chi nhac lai khi doi noi dung,
#      hoac sau `repeat_after` luot.
#   3. Luon exit 0. Hook nay chi goi y, khong bao gio chan.
set -uo pipefail

# Nuot stdin de dispatcher khong gap broken pipe. Khong dung toi noi dung:
# giai doan duoc suy tu file, khong suy tu cau nguoi dung go.
cat >/dev/null 2>&1 || true

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHASE_SH="$HERE/phase.sh"
[ -x "$PHASE_SH" ] || exit 0

STATE_JSON=$("$PHASE_SH" "$PWD" 2>/dev/null) || exit 0

field() { printf '%s' "$STATE_JSON" | sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p" | head -1; }

PHASE=$(field phase)
[ -n "$PHASE" ] || exit 0
[ "$PHASE" = "none" ] && exit 0

SLICE=$(field slice)

# Phan tu dau tien cua mang `missing` — thu tu trong phase.sh la thu tu uu tien.
NEXT=$(printf '%s' "$STATE_JSON" \
  | tr -d '\n' \
  | sed -n 's/.*"missing": *\[\([^]]*\)\].*/\1/p' \
  | sed -n 's/^ *"\([^"]*\)".*/\1/p')
[ -n "$NEXT" ] || exit 0

# ---------------------------------------------------------------- cau hinh
CONFIG=".specify/extensions/phases/phases-config.yml"
cfg() { # cfg <key> <mac-dinh>
  local v=""
  [ -f "$CONFIG" ] && v=$(sed -n "s/^[[:space:]]*$1:[[:space:]]*\([^#]*\).*/\1/p" "$CONFIG" | head -1 | tr -d ' "')
  printf '%s' "${v:-$2}"
}
[ "$(cfg enabled true)" = "false" ] && exit 0
REPEAT_AFTER=$(cfg repeat_after 10)
case "$REPEAT_AFTER" in ''|*[!0-9]*) REPEAT_AFTER=10 ;; esac

# ---------------------------------------------------------------- goi y
# Moi muc thieu -> mot lenh nen chay, va mot cau noi vi sao no dang.
case "$NEXT" in
  constitution) CMD="/speckit-constitution"           ; WHY="Luat du an chua viet — moi thu sau se khong co gi de doi chieu." ;;
  slice)        CMD="/speckit-specify"                ; WHY="Chua co lat nao. Cat mot lat mong, demo duoc, roi hay di tiep." ;;
  spec)         CMD="/speckit-specify"                ; WHY="Lat da mo nhung chua co spec.md." ;;
  plan)         CMD="/speckit-phases-write-spec"      ; WHY="Spec da co. Truoc khi sang plan, soat lai goals / non-goals / tieu chi nghiem thu." ;;
  adr)          CMD="/speckit-phases-architecture"    ; WHY="Chua ADR nao. Quyet dinh mot chieu ma khong ghi lai thi ba thang sau khong ai biet vi sao." ;;
  architecture) CMD="/speckit-phases-system-design"   ; WHY="Chua co docs/02-architecture.md — ranh gioi service va hop dong API con bo ngo." ;;
  ui_contract)  CMD="/speckit-phases-design-handoff"  ; WHY="Chua co contracts/ui.md. Ba vai lam song song se tu bia giao dien." ;;
  tokens)       CMD="/speckit-phases-design-handoff"  ; WHY="Co contracts/ui.md nhung thieu design-tokens.json — cong a11y va component contract dang tro vao file khong ton tai." ;;
  tasks)        CMD="/speckit-tasks"                  ; WHY="Plan da co nhung chua chia task." ;;
  a11y)         CMD="/speckit-phases-a11y"            ; WHY="Co hop dong giao dien nhung chua soat a11y. Sua luc con la chu re hon nhieu lan sua khi da thanh component." ;;
  *) exit 0 ;;
esac

# ---------------------------------------------------------------- lenh co that
# Extension nay bo sung skill dan dan. Goi y mot lenh chua duoc cai la day
# nguoi dung vao ngo cut, nen kiem truoc: skill nao chua co thi ha xuong lenh
# thay the, khong co thay the thi thoi khong noi gi.
have_cmd() { # have_cmd /speckit-phases-abc
  [ -d ".claude/skills/$(printf '%s' "$1" | sed 's|^/||')" ]
}
if ! have_cmd "$CMD"; then
  case "$NEXT" in
    plan)         CMD="/speckit-clarify" ; WHY="Spec da co. Lam ro cac cho con mo ho truoc khi sang plan." ;;
    architecture) CMD="/speckit-phases-architecture" ; WHY="Chua co docs/02-architecture.md — ghi thiet ke va cac quyet dinh keo theo thanh ADR." ;;
    *) exit 0 ;;
  esac
  have_cmd "$CMD" || exit 0
fi

# ---------------------------------------------------------------- chong lap
SIG="$PHASE:$SLICE:$NEXT"
STATE_FILE=".specify/extensions/phases/.hint-state"
LAST_SIG=""; COUNT=0
if [ -f "$STATE_FILE" ]; then
  LAST_SIG=$(sed -n '1p' "$STATE_FILE")
  COUNT=$(sed -n '2p' "$STATE_FILE")
  case "$COUNT" in ''|*[!0-9]*) COUNT=0 ;; esac
fi

if [ "$SIG" = "$LAST_SIG" ] && [ "$COUNT" -lt "$REPEAT_AFTER" ]; then
  # Cung goi y, chua toi luc nhac lai — dem them roi im lang.
  mkdir -p "$(dirname "$STATE_FILE")" 2>/dev/null
  printf '%s\n%s\n' "$SIG" "$((COUNT + 1))" > "$STATE_FILE" 2>/dev/null
  exit 0
fi

mkdir -p "$(dirname "$STATE_FILE")" 2>/dev/null
printf '%s\n%s\n' "$SIG" "1" > "$STATE_FILE" 2>/dev/null

# ---------------------------------------------------------------- in
# `user_prompt_submit` cho phep stdout thuong di thang vao context model doc duoc.
WHERE="$PHASE"
[ -n "$SLICE" ] && WHERE="$PHASE · lat $SLICE"
cat <<HINT
<phase-hint>
Giai doan: $WHERE
Thieu: $WHY
Nen chay: $CMD
(Goi y tu extension phases. Tat bang enabled: false trong $CONFIG)
</phase-hint>
HINT
exit 0
