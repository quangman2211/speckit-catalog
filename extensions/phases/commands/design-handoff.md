---
description: "Sinh hop dong giao dien contracts/ui.md tu plan.md — design token, component va props, trang thai, responsive, edge case, a11y, va ban do ma loi sang chu hien thi. Kem sinh design-tokens.json. Dung khi mot lat sap bung ra nhieu nguoi lam song song, khi chua co nguon su that ve mau va khoang cach, hoac khi cong a11y bao thieu file token. Thuoc giai doan PLAN — chay sau khi da co plan.md."
argument-hint: "<man hinh can lam hop dong, hoac de trong de lam het man trong plan>"
---

# Hop dong giao dien

> Sao chep va sua doi tu skill `design-handoff` cua
> [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins),
> Apache-2.0. **Da sua:** doi nguon vao tu Figma sang `plan.md`, them lop ghi
> file, them ban do ma loi va trang thai "du lieu cu", bo phan connector.

Sinh hop dong giao dien dung chung — thu ma ba vai `api` / `web` / `ext` deu
doc, thay vi moi nguoi tu bia.

## Giai doan

**PLAN.** Can `plan.md` cua lat hien tai. Chua co thi dung lai va bao nguoi
dung chay `__SPECKIT_COMMAND_PLAN__` truoc.

Vi sao o giai doan nay chu khong phai luc code: khi mot lat bung ra ba worktree,
`web` khong cho `api` chay xong — no code dua vao hop dong. Hop dong API da co;
hop dong giao dien phai co cung luc, neu khong `web` se tu quyet mau, chu tren
nut, va cach hien loi.

## User Input

$ARGUMENTS

De trong = lam het cac man hinh mo ta trong `plan.md`.

## Steps

1. Doc `.specify/extensions/phases/phases-config.yml` lay `ui_contract`
   (mac dinh `contracts/ui.md`) va `token_file` (mac dinh `design-tokens.json`).

2. Doc `plan.md` va `spec.md` cua lat hien tai. Liet ke moi man hinh / thanh
   phan giao dien duoc nhac toi.

3. Neu da co `<ui_contract>`: **doc truoc khi ghi**. Bo sung phan con thieu,
   giu nguyen phan da chot. Khong ghi de mot hop dong dang duoc dung.

4. Neu nguoi dung dua link Figma hoac anh chup, lay so do lam nguon. Khong co
   thi lam viec tu mo ta trong plan — dung hoi nguoi dung di ket noi cong cu.

5. Viet `<ui_contract>` theo khuon o duoi.

6. Sinh `<token_file>` tu bang token: JSON phang, khoa la ten token, gia tri la
   gia tri that. Day la file ma cong a11y va component contract tro vao.

7. Bao lai hai duong dan da ghi, va liet ke nhung o con `[CAN QUYET]`.

## Bon trang thai bat buoc

Moi man hinh phai mo ta du bon, khong duoc bo:

| Trang thai | Cau hoi phai tra loi |
|---|---|
| dang tai | hien skeleton hay spinner? |
| rong | chua co du lieu thi hien gi? |
| loi | loi hien o dau, chu gi, con duong thoat la gi? |
| **du lieu cu** | du lieu dong bo ve tu luc nao, va bao lau thi coi la cu? |

Trang thai thu tu la thu hay bi bo quen nhat, va la thu gay hieu nham dat nhat:
mot man hien so 0 khi thuc ra la "chua bao gio dong bo duoc" se dan toi quyet
dinh sai. Neu he thong khong co du lieu dong bo, ghi "khong ap dung" — dung bo
trong.

## Khuon hop dong

```markdown
# Hop dong giao dien

> Chi session `arch` duoc sua. Moi thay doi ghi mot dong vao contracts/CHANGELOG.md.

## Design token

| Token | Gia tri | Dung o dau |
|-------|---------|------------|
| `color-primary` | #[hex] | nut chinh, link |
| `space-md` | [X]px | giua cac khoi |
| `font-heading-lg` | [co/dam/font] | tieu de trang |

## Kiem ke man hinh

| Man hinh | Lat nao tao | Tra loi cau hoi gi |
|---|---|---|
| [Ten] | [NNN-slug] | [nguoi dung mo man nay de biet dieu gi] |

## Component

| Component | Bien the | Props | Ghi chu |
|-----------|----------|-------|---------|
| [Ten] | [bien the] | [props] | [hanh vi dac biet] |

## Trang thai va tuong tac

| Phan tu | Trang thai | Hanh vi |
|---------|------------|---------|
| [Nut chinh] | hover | [...] |
| [Nut chinh] | dang tai | [spinner, khoa nut] |
| [Bang] | rong | [...] |
| [Bang] | du lieu cu | [nhan "cap nhat luc X", to do khi qua nguong] |

## Ban do ma loi sang chu hien thi

Khoa theo `code` trong hop dong API. Client chuyen theo `code`, khong doc `detail`.

| code | Chu hien thi | Nguoi dung lam gi tiep |
|------|--------------|------------------------|
| [CODE] | [cau tieng Viet ngan] | [duong thoat] |

## Responsive

| Diem gay | Doi gi |
|----------|--------|
| >1024px | [bo cuc mac dinh] |
| 768–1024px | [...] |
| <768px | [...] |

## Edge case

- **Chu dai**: [cat o dau, cat kieu gi]
- **Nhieu muc**: [100 dong thi sao]
- **Ket noi cham**: [...]
- **Thieu du lieu**: [...]

## A11y

- Muc WCAG ap dung: [A | AA | AAA]
- Thu tu focus
- Nhan ARIA can co
- Thao tac ban phim
```

## Rules

- **Dung token, dung gia tri tho.** Viet `space-md`, khong viet `16px`. Gia tri
  that chi ton tai o mot cho: bang token va `<token_file>`.
- **Khong doan.** Cho nao plan khong noi thi ghi `[CAN QUYET]` va liet ke ra o
  cuoi, de nguoi dung chot. Doan la dat mot quyet dinh vao mieng ba vai ma
  khong ai biet.
- **Moi ma loi trong hop dong API phai co mot dong trong ban do.** Thieu dong
  nao thi liet ke ma do ra, dung bo qua — do la cho `api` tra ve mot ma ma
  `web` khong biet hien chu gi.
- **Khong viet code.** Hop dong la mo ta, khong phai JSX.
- Moi component truy nguyen ve mot requirement trong `spec.md`. Khong truy
  nguyen duoc thi ghi vao muc `Chua truy nguyen` de nguoi dung quyet.
