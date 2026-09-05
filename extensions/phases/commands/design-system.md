---
description: "Soat, ghi tai lieu, hoac mo rong he thiet ke. Che do audit tim ten dat khong nhat quan va gia tri hard-code lot ra ngoai token; che do document viet tai lieu cho mot component (bien the, trang thai, a11y); che do extend thiet ke component moi cho khop he da co. Ghi ra contracts/ui-audit.md. Dung khi moi man mot kieu nut, khi mau va khoang cach roi rac trong code, hoac truoc khi them component moi. Thuoc giai doan PLAN."
argument-hint: "[audit | document | extend] <component hoac he thong>"
---

# He thiet ke

> Sao chep va sua doi tu skill `design-system` cua
> [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins),
> Apache-2.0. **Da sua:** them lop ghi file, doi nguon doi chieu sang
> `contracts/ui.md` + `design-tokens.json`, them rang buoc giai doan, bo phan
> connector.

## Giai doan

**PLAN.** Can `contracts/ui.md` da ton tai — khong co hop dong giao dien thi
khong co gi de soat. Chua co thi chay `/speckit-phases-design-handoff` truoc.

## User Input

$ARGUMENTS

Bat dau bang mot trong ba tu: `audit`, `document`, `extend`. Khong ghi thi mac
dinh `audit`.

## Steps

1. Doc `.specify/extensions/phases/phases-config.yml` lay `ui_contract` va
   `token_file`.

2. Doc `<ui_contract>` va `<token_file>`.

3. Voi che do `audit`: quet them code giao dien trong `apps/web/` (hoac thu muc
   tuong duong trong `plan.md`) tim gia tri mau, khoang cach, co chu **viet cung
   trong code** thay vi tham chieu token.

4. Chay dung che do duoc yeu cau, theo khuon o duoi.

5. `audit` ghi ra `contracts/ui-audit.md`. `document` va `extend` bo sung vao
   `<ui_contract>`, khong tao file rieng — de hop dong giao dien van la mot cho
   duy nhat de doc.

## Ba thanh phan cua mot he thiet ke

- **Token** — mau, chu, khoang cach, vien, do do, chuyen dong
- **Component** — bien the, trang thai, kich co, hanh vi, a11y
- **Mau (pattern)** — form, dieu huong, hien du lieu, phan hoi

## Khuon — che do audit

```markdown
# Soat he thiet ke

**Ngay:** [ngay] · **Nguon:** contracts/ui.md, design-tokens.json

## Tom tat
Component da soat: [X] · Van de: [X]

## Ten dat khong nhat quan
| Hien tai | Van de | De xuat |
|---|---|---|

## Do phu cua token
| Gia tri | Xuat hien o dau | Co token chua | De xuat |
|---|---|---|---|
| `#0F6E62` | Button.tsx:12, Card.tsx:44 | chua | them `color-primary` |

Gia tri hard-code la cho he thiet ke ro ri. Moi dong o bang nay la mot cho ma
lan doi mau sau se bo sot.

## Do day du cua component
| Component | Bien the | Trang thai | A11y | Danh gia |
|---|---|---|---|---|
| Button | 3/3 | 4/6 | co | thieu trang thai loading va disabled |

## Ba viec nen lam truoc
1. [...]
2. [...]
3. [...]
```

## Khuon — che do document

```markdown
## Component: [Ten]

### Mo ta
[Dung khi nao, va khi nao KHONG dung]

### Bien the
| Bien the | Dung khi |
|---|---|

### Props
| Prop | Kieu | Bat buoc | Mac dinh | Y nghia |
|---|---|---|---|---|

### Trang thai
| Trang thai | Bieu hien |
|---|---|
| mac dinh | |
| hover | |
| active | |
| disabled | |
| dang tai | |
| loi | |

### A11y
- Role
- Thao tac ban phim
- Screen reader doc ra gi

### Nen va khong nen
| Nen | Khong nen |
|---|---|
```

## Khuon — che do extend

```markdown
## Component moi: [Ten]

### Van de
[Nhu cau nao ma component hien co khong dap ung]

### Mau da co gan giong
| Component | Vi sao khong dung duoc |
|---|---|

### Thiet ke de xuat
[Props, bien the, trang thai, token dung toi]

### A11y

### Cau hoi con treo
```

## Rules

- **Khong tu doi token dang duoc dung.** Doi mot token la doi moi cho no xuat
  hien. De xuat, roi de nguoi dung quyet.
- **Moi gia tri hard-code tim thay phai vao bang**, ke ca khi chi xuat hien mot
  lan. Mot lan hom nay la ba lan thang sau.
- **Che do extend phai chung minh component hien co khong dung duoc**, khong
  duoc de trong muc do. Them component vi luoi doc component cu la cach he
  thiet ke phinh ra.
- Khong viet code implementation. Muc "Code Example" trong tai lieu chi la
  minh hoa cach goi, khong phai ban cai dat.
