# masterplan — tang du an cho spec-kit

Spec-kit quan ly **mot feature**. Tren no khong co gi: grep toan bo core pack
khong file nao nhac `roadmap`, `blueprint` hay `milestone`; chu "slice" xuat hien
dung mot lan, va nghia la mot user story **ben trong** mot feature.

Extension nay lam phan con thieu o tren: tu y tuong → blueprint → kien truc →
hop dong → cac lat. Moi lat la mot prompt dan vao `/speckit.specify`.

```
TANG DU AN  (extension nay — chay mot lan)
  architect  → docs/01-blueprint.md        hoi dap tung vong, khong can tai lieu san
  design     → docs/02-architecture.md     thanh phan, ranh gioi, danh doi
  decide     → docs/04-decisions/ADR-*.md  quyet dinh mot chieu
  contracts  → contracts/*.md              thu moi lat deu doc, khong lat nao tu sua
  slice      → docs/05-roadmap.md + docs/slices/NNN-*.md
  check      → chin tieu chi tu kiem
  next       → in prompt lat ke tiep, sau khi kiem cong chan
       │
       ▼  moi lat = mot prompt dan vao
TANG FEATURE  (spec-kit, extension nay khong dung toi)
  specify → clarify → plan → tasks → implement → analyze
```

## Vi sao khong trung voi spec-kit

`contracts/` o goc repo la hop dong **ca du an**; `specs/NNN/contracts/` ma
`/speckit.plan` sinh ra la chi tiet **rieng cua mot lat**. Hai cho khac nhau va
khong giam nhau. Tuong tu, `/speckit-masterplan-design` ve **hinh dang he thong**
de biet cat lat o dau, con `/speckit.plan` thiet ke **ben trong mot lat** da chot.

## Cai

```bash
specify extension catalog add <catalog-url> --name quangman --priority 1 --install-allowed
specify extension add masterplan
specify integration upgrade claude    # noi hook `events:` vao .claude/settings.json
```

Buoc thu ba khong bo duoc: `specify bundle install` **khong** ghi hook
`user_prompt_submit` — no chi duoc ghi tu duong `extension add/remove/update`
va `init`. Bo qua thi 8 lenh van chay tay duoc, chi mat phan goi y tu dong.

Sau khi cai, khoi dong lai Claude Code de `/speckit-masterplan-*` xuat hien.

## Trinh tu dung

```
# mot lan, truoc khi cham spec-kit
/speckit-masterplan-architect          hoi dap 5 vong
/speckit-masterplan-design
/speckit-masterplan-decide "<quyet dinh mot chieu>"   (lap lai cho tung cai)
/speckit-masterplan-contracts
/speckit-masterplan-slice 8
/speckit-masterplan-check              sua het [FAIL] roi moi di tiep
/speckit.constitution

# lap cho tung lat
/speckit-masterplan-next               kiem cong chan, in prompt
/speckit.specify  ← dan prompt
/speckit.clarify → /speckit.plan → /speckit.tasks → /speckit.implement → /speckit.analyze
merge → danh dau ✅ trong docs/05-roadmap.md
```

## Chin tieu chi tu kiem

`check.sh` chay bay cai bang script, exit 1 neu co `[FAIL]`:

| | Tieu chi | Bat gi |
|---|---|---|
| C1 | ten lat khong phai ten tang ky thuat | cat theo tang → khong lat nao demo duoc mot minh |
| C2 | moi lat noi ro merge xong demo duoc gi | cong viec bi nham la lat |
| C3 | khong phu thuoc nguoc | lat khong bao gio chay duoc |
| C4 | moi lat trong roadmap co file prompt | lat bi bo quen luc sinh prompt |
| C5 | prompt dai 10-25 dong | dai = lat to qua; ngan = chua du de specify |
| C6 | prompt khong nhac framework | chot ky thuat truoc khi chot pham vi |
| C7 | dem cho `[CAN QUYET]` | (thong tin, khong fail) |
| C8 | constitution khong co cau chung chung | "code sach" khong tu choi duoc PR nao |

Hai cai con lai phai doc moi biet, nen thuoc phan LLM cua `/speckit-masterplan-check`:
lat 001 co phai walking skeleton khong, va moi tinh nang trong blueprint da nam
trong mot lat hoac muc "Ngoai pham vi" chua.

## Hook

`events.user_prompt_submit` → `speckit.masterplan.status` → `scripts/bash/suggest.sh`.
Chay moi luot, doc `state.sh`, in mot goi y ngan **hoac khong in gi**. Khong bao
gio chan. Tat bang `enabled: false` trong
`.specify/extensions/masterplan/masterplan-config.yml`; nhip nhac lai dat bang
`repeat_after`.

Kiem tay, khong can Claude Code:

```bash
echo '{"prompt":"x","hook_event_name":"UserPromptSubmit"}' \
  | .specify/extensions/masterplan/scripts/bash/suggest.sh
```

## Cho de `gates` cam vao sau

`state.sh` in JSON trang thai va `check.sh` tra exit code. Extension `gates` sau
nay goi lai dung hai cai do va them lop phan quyet `GATE:PASS` / `GATE:BLOCK`.
Khong viet lai phan nhan dien.
