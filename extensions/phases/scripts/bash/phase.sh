#!/usr/bin/env bash
# Nhan dien giai doan hien tai cua mot spec-kit project, in ra JSON.
#
#   phase.sh [project-dir]      # mac dinh: cwd
#
# Thuan kiem file — khong goi LLM, khong doc prompt. Cung mot trang thai repo
# phai ra cung mot ket qua, moi luot.
#
# Hai giai doan:
#   spec  — dang lam ro CAI GI can lam (chua co plan.md)
#   plan  — dang quyet dinh LAM THE NAO (da co plan.md)
#
# Script nay la nguon su that dung chung: `suggest.sh` doc no de goi y skill,
# va extension `gates` sau nay doc no de phan quyet PASS/BLOCK. Khong ai
# duoc nhan dien lai giai doan bang cach khac.
set -uo pipefail

ROOT="${1:-$PWD}"
cd "$ROOT" 2>/dev/null || { printf '{"phase":"none","error":"khong vao duoc %s"}\n' "$ROOT"; exit 0; }

# ---------------------------------------------------------------- helpers
json_bool() { [ "$1" = "1" ] && printf 'true' || printf 'false'; }

# Escape mot chuoi cho JSON (chi can lo dau nhay va backslash — duong dan file).
json_str() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

# ---------------------------------------------------------------- tien de
# Ngoai spec-kit project thi khong noi gi ca. Hook chay moi luot, o moi repo.
if [ ! -d ".specify" ]; then
  printf '{"phase":"none","reason":"khong phai spec-kit project"}\n'
  exit 0
fi

# ---------------------------------------------------------------- slice
# Slice hien tai = thu muc specs/NNN-* co so thu tu lon nhat.
SLICE=""
if [ -d "specs" ]; then
  SLICE=$(ls -1 specs 2>/dev/null | grep -E '^[0-9]{3}-' | sort | tail -1)
fi
SLICE_DIR=""
[ -n "$SLICE" ] && SLICE_DIR="specs/$SLICE"

# ---------------------------------------------------------------- artifact
has_spec=0; has_plan=0; has_tasks=0; has_a11y=0
if [ -n "$SLICE_DIR" ]; then
  [ -f "$SLICE_DIR/spec.md" ]  && has_spec=1
  [ -f "$SLICE_DIR/plan.md" ]  && has_plan=1
  [ -f "$SLICE_DIR/tasks.md" ] && has_tasks=1
  [ -f "$SLICE_DIR/a11y-review.md" ] && has_a11y=1
fi

# Artifact cap project (dung chung moi slice)
has_ui=0;     [ -f "contracts/ui.md" ] && has_ui=1
has_tokens=0; [ -f "design-tokens.json" ] && has_tokens=1
has_arch=0;   [ -f "docs/02-architecture.md" ] && has_arch=1
adr_count=0
if [ -d "docs/04-decisions" ]; then
  adr_count=$(ls -1 docs/04-decisions 2>/dev/null | grep -c '^ADR-.*\.md$' || true)
fi
adr_count=${adr_count:-0}

# Constitution da viet chua (con placeholder = chua)
has_const=0
if [ -f ".specify/memory/constitution.md" ]; then
  grep -q '\[PROJECT_NAME\]' ".specify/memory/constitution.md" 2>/dev/null || has_const=1
fi

# ---------------------------------------------------------------- giai doan
# plan.md la duong ranh gioi. Co no = da chot CAI GI, dang ban LAM THE NAO.
# Da o trong mot spec-kit project thi luon co giai doan — project vua init
# cung dang o giai doan spec, va viec dau tien la viet constitution.
# `none` chi danh cho thu muc khong phai spec-kit project (da thoat o tren).
if [ "$has_plan" = "1" ]; then
  PHASE="plan"
else
  PHASE="spec"
fi

# ---------------------------------------------------------------- thieu gi
# Thu tu trong mang nay la thu tu uu tien — suggest.sh lay phan tu dau tien.
MISSING=""
add_missing() { MISSING="$MISSING${MISSING:+,}\"$1\""; }

case "$PHASE" in
  spec)
    [ "$has_const" = "0" ] && add_missing "constitution"
    [ -z "$SLICE_DIR" ]    && add_missing "slice"
    [ -n "$SLICE_DIR" ] && [ "$has_spec" = "0" ] && add_missing "spec"
    [ "$has_spec" = "1" ] && add_missing "plan"
    ;;
  plan)
    [ "$adr_count" = "0" ]  && add_missing "adr"
    [ "$has_arch" = "0" ]   && add_missing "architecture"
    [ "$has_ui" = "0" ]     && add_missing "ui_contract"
    [ "$has_ui" = "1" ] && [ "$has_tokens" = "0" ] && add_missing "tokens"
    [ "$has_tasks" = "0" ]  && add_missing "tasks"
    [ "$has_ui" = "1" ] && [ "$has_a11y" = "0" ] && add_missing "a11y"
    ;;
esac

# ---------------------------------------------------------------- output
cat <<JSON
{
  "phase": "$PHASE",
  "slice": "$(json_str "$SLICE")",
  "slice_dir": "$(json_str "$SLICE_DIR")",
  "have": {
    "constitution": $(json_bool "$has_const"),
    "spec": $(json_bool "$has_spec"),
    "plan": $(json_bool "$has_plan"),
    "tasks": $(json_bool "$has_tasks"),
    "a11y_review": $(json_bool "$has_a11y"),
    "architecture": $(json_bool "$has_arch"),
    "ui_contract": $(json_bool "$has_ui"),
    "tokens": $(json_bool "$has_tokens"),
    "adr_count": $adr_count
  },
  "missing": [$MISSING]
}
JSON
exit 0
