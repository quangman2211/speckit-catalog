#!/usr/bin/env bash
# Nhan dien du an dang o TANG nao, in ra JSON.
#
#   state.sh [project-dir]      # mac dinh: cwd
#
# Thuan kiem file — khong goi LLM, khong doc prompt nguoi dung. Cung mot trang
# thai repo phai ra cung mot ket qua, moi luot.
#
# Hai tang:
#   blueprint — chua co roadmap va prompt lat. Dang tra loi CAI GI xay, xay
#               theo hinh gi, va cat lam may lat.
#   slice     — da co roadmap + prompt. Tu day tro di spec-kit lam viec cua no;
#               tang nay chi con viec bao lat ke tiep va cong chan cua no.
#
# Script nay la nguon su that dung chung: `suggest.sh` doc no de goi y, lenh
# `status`/`next` doc no de bao cao, va extension `gates` sau nay doc no de
# phan quyet PASS/BLOCK. Khong ai duoc nhan dien lai bang cach khac.
set -uo pipefail

ROOT="${1:-$PWD}"
cd "$ROOT" 2>/dev/null || { printf '{"altitude":"none","error":"khong vao duoc %s"}\n' "$ROOT"; exit 0; }

json_bool() { [ "$1" = "1" ] && printf 'true' || printf 'false'; }
json_str()  { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

# ---------------------------------------------------------------- cau hinh
CONFIG=".specify/extensions/masterplan/masterplan-config.yml"
cfg() { # cfg <key> <mac-dinh>
  local v=""
  [ -f "$CONFIG" ] && v=$(sed -n "s/^[[:space:]]*$1:[[:space:]]*\([^#]*\).*/\1/p" "$CONFIG" | head -1 | tr -d ' "')
  printf '%s' "${v:-$2}"
}

BLUEPRINT=$(cfg blueprint "docs/01-blueprint.md")
ARCH=$(cfg architecture "docs/02-architecture.md")
ADR_DIR=$(cfg adr_dir "docs/04-decisions")
ROADMAP=$(cfg roadmap "docs/05-roadmap.md")
SLICE_DIR=$(cfg slice_dir "docs/slices")
CONTRACTS=$(cfg contracts_dir "contracts")

# ---------------------------------------------------------------- tien de
# Ngoai spec-kit project thi khong noi gi ca. Hook chay moi luot, o moi repo.
if [ ! -d ".specify" ]; then
  printf '{"altitude":"none","reason":"khong phai spec-kit project"}\n'
  exit 0
fi

# ---------------------------------------------------------------- artifact
has_bp=0;   [ -f "$BLUEPRINT" ] && has_bp=1
has_arch=0; [ -f "$ARCH" ] && has_arch=1
has_rm=0;   [ -f "$ROADMAP" ] && has_rm=1

adr_count=0
[ -d "$ADR_DIR" ] && adr_count=$(find "$ADR_DIR" -maxdepth 1 -name 'ADR-*.md' 2>/dev/null | wc -l | tr -d ' ')
adr_count=${adr_count:-0}

contract_count=0
[ -d "$CONTRACTS" ] && contract_count=$(find "$CONTRACTS" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
contract_count=${contract_count:-0}

prompt_count=0
[ -d "$SLICE_DIR" ] && prompt_count=$(find "$SLICE_DIR" -maxdepth 1 -name '[0-9][0-9][0-9]-*.md' 2>/dev/null | wc -l | tr -d ' ')
prompt_count=${prompt_count:-0}

# Constitution da viet chua (con placeholder = chua)
has_const=0
if [ -f ".specify/memory/constitution.md" ]; then
  grep -q '\[PROJECT_NAME\]' ".specify/memory/constitution.md" 2>/dev/null || has_const=1
fi

# ---------------------------------------------------------------- roadmap
# Mot dong lat = dong bang co cot dau la 3 chu so va du 8 cot (bang "Sau moc"
# chi co 5 cot nen tu dong bi loai).
SLICE_TOTAL=0; SLICE_DONE=0; NEXT_ID=""; NEXT_NAME=""; NEXT_GATE=""
if [ "$has_rm" = "1" ]; then
  read -r SLICE_TOTAL SLICE_DONE NEXT_ID NEXT_NAME NEXT_GATE <<EOF2
$(awk -F'|' '
  /^[[:space:]]*\|/ && NF >= 9 {
    id = $2; gsub(/[[:space:]]/, "", id)
    if (id !~ /^[0-9][0-9][0-9]$/) next
    name = $3; gsub(/^[[:space:]]*`?|`?[[:space:]]*$/, "", name); gsub(/[[:space:]]/, "_", name)
    gate = $6; gsub(/[[:space:]*]/, "", gate); if (gate == "" || gate == "—" || gate == "-") gate = "none"
    st = $9; total++
    if (st ~ /✅/) { done++ }
    else if (nid == "") { nid = id; nname = name; ngate = gate }
  }
  END { printf "%d %d %s %s %s\n", total+0, done+0, (nid==""?"-":nid), (nname==""?"-":nname), (ngate==""?"-":ngate) }
' "$ROADMAP" 2>/dev/null)
EOF2
fi
[ "$NEXT_ID" = "-" ] && NEXT_ID=""
[ "$NEXT_NAME" = "-" ] && NEXT_NAME=""
[ "$NEXT_GATE" = "-" ] && NEXT_GATE=""
NEXT_NAME=$(printf '%s' "$NEXT_NAME" | tr '_' ' ')

# File prompt cua lat ke tiep
NEXT_PROMPT=""
if [ -n "$NEXT_ID" ] && [ -d "$SLICE_DIR" ]; then
  NEXT_PROMPT=$(find "$SLICE_DIR" -maxdepth 1 -name "$NEXT_ID-*.md" 2>/dev/null | head -1)
fi

# ---------------------------------------------------------------- tang
if [ "$has_rm" = "1" ] && [ "$prompt_count" -gt 0 ]; then
  ALTITUDE="slice"
else
  ALTITUDE="blueprint"
fi

# ---------------------------------------------------------------- thieu gi
# Thu tu trong mang nay la thu tu uu tien — suggest.sh lay phan tu dau tien.
MISSING=""
add_missing() { MISSING="$MISSING${MISSING:+,}\"$1\""; }

case "$ALTITUDE" in
  blueprint)
    [ "$has_bp" = "0" ]        && add_missing "blueprint"
    [ "$has_arch" = "0" ]      && add_missing "architecture"
    [ "$adr_count" = "0" ]     && add_missing "adr"
    [ "$contract_count" = "0" ] && add_missing "contracts"
    [ "$has_rm" = "0" ]        && add_missing "roadmap"
    [ "$has_rm" = "1" ] && [ "$prompt_count" = "0" ] && add_missing "prompts"
    ;;
  slice)
    [ "$has_const" = "0" ] && add_missing "constitution"
    if [ -n "$NEXT_ID" ]; then add_missing "next"; else add_missing "done"; fi
    ;;
esac

# ---------------------------------------------------------------- output
cat <<JSON
{
  "altitude": "$ALTITUDE",
  "have": {
    "blueprint": $(json_bool "$has_bp"),
    "architecture": $(json_bool "$has_arch"),
    "roadmap": $(json_bool "$has_rm"),
    "constitution": $(json_bool "$has_const"),
    "adr_count": $adr_count,
    "contract_count": $contract_count,
    "prompt_count": $prompt_count
  },
  "slices": {
    "total": ${SLICE_TOTAL:-0},
    "done": ${SLICE_DONE:-0},
    "next_id": "$(json_str "$NEXT_ID")",
    "next_name": "$(json_str "$NEXT_NAME")",
    "next_gate": "$(json_str "$NEXT_GATE")",
    "next_prompt": "$(json_str "$NEXT_PROMPT")"
  },
  "paths": {
    "blueprint": "$(json_str "$BLUEPRINT")",
    "architecture": "$(json_str "$ARCH")",
    "adr_dir": "$(json_str "$ADR_DIR")",
    "roadmap": "$(json_str "$ROADMAP")",
    "slice_dir": "$(json_str "$SLICE_DIR")",
    "contracts_dir": "$(json_str "$CONTRACTS")"
  },
  "missing": [$MISSING]
}
JSON
exit 0
