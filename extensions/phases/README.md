# Phase Skills (`phases`)

Skill theo giai doan, cong mot hook tu nhan dien dang o giai doan nao roi goi y
skill dung luc.

## Hai giai doan

Ranh gioi la `plan.md`:

| Giai doan | Dang lam gi | Dau hieu |
|---|---|---|
| **spec** | lam ro CAI GI can lam | chua co `plan.md` |
| **plan** | quyet dinh LAM THE NAO | da co `plan.md` |

## Lenh

| Lenh | Giai doan | Ghi ra |
|---|---|---|
| `/speckit-phases-status` | ca hai | — (chi bao cao) |
| `/speckit-phases-write-spec` | **spec** | bo sung `specs/NNN/spec.md` |
| `/speckit-phases-system-design` | plan | `docs/02-architecture.md` |
| `/speckit-phases-architecture` | plan | `docs/04-decisions/ADR-NNN-*.md` |
| `/speckit-phases-design-handoff` | plan | `contracts/ui.md` + `design-tokens.json` |
| `/speckit-phases-design-system` | plan | `contracts/ui-audit.md` |
| `/speckit-phases-a11y` | plan | `specs/NNN/a11y-review.md` |

`/speckit-phases-suggest` la lenh noi bo — hook tu goi, khong can go tay.

## Hook goi y

Extension khai bao `events.user_prompt_submit`, nen luc cai no ghi thang mot
hook vao `.claude/settings.json`. Khong phai cai tay o tung may.

Hook doc trang thai file trong repo (khong doc cau nguoi dung go, khong goi
LLM), roi bom mot goi y ngan vao context:

```
<phase-hint>
Giai doan: plan · lat 001-khung-xuong
Thieu: Chua co contracts/ui.md. Ba vai lam song song se tu bia giao dien.
Nen chay: /speckit-phases-design-handoff
</phase-hint>
```

> **Cai bang bundle thi phai noi hook bang tay.** `specify bundle install` khong goi
> buoc refresh events, nen hook khong duoc ghi ra `.claude/settings.json`. Chay
> `specify integration upgrade claude` sau khi cai bundle. Cai bang
> `specify extension add phases` thi khong can — no tu noi.

Ba luat cua hook:

1. Khong co gi de noi thi khong in gi.
2. Khong lap lai cung mot goi y moi luot — chi nhac lai khi doi noi dung, hoac
   sau `repeat_after` luot (mac dinh 10).
3. Chi goi y, **khong bao gio chan**. Luon thoat 0.

Tat hoan toan: dat `enabled: false` trong
`.specify/extensions/phases/phases-config.yml`.

## Cau hinh

| Khoa | Mac dinh | Y nghia |
|---|---|---|
| `enabled` | `true` | bat/tat hook goi y |
| `repeat_after` | `10` | so luot cho truoc khi nhac lai cung mot goi y |
| `adr_dir` | `docs/04-decisions` | noi dat ADR |
| `ui_contract` | `contracts/ui.md` | hop dong giao dien |
| `token_file` | `design-tokens.json` | file token, cong a11y tro vao day |
| `wcag_level` | `AA` | muc WCAG cho cong a11y |

## Nhan dien giai doan dung chung

`scripts/bash/phase.sh` in ra JSON trang thai va la **nguon su that duy nhat**
ve giai doan. Goi truc tiep duoc:

```bash
.specify/extensions/phases/scripts/bash/phase.sh
```

Extension khac (vi du mot extension `gates` sau nay) doc lai chinh script do
thay vi tu nhan dien lai.

## Nguon

Hai command `architecture` va `design-handoff` sao chep va sua doi tu
[anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins)
(Apache-2.0). Chi tiet sua doi trong `NOTICE`.
