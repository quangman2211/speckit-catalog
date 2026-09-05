---
description: "Sinh hop dong cap du an trong contracts/ — mo hinh du lieu (bang, cot, lat nao tao), API (endpoint, xac thuc, bang ma loi), giao dien (token, component, trang thai), su kien (thong diep, may trang thai) — kem CHANGELOG. Day la thu moi lat deu doc va khong lat nao duoc tu sua. Dung sau /speckit-masterplan-design va truoc khi cat lat. Thuoc TANG DU AN."
argument-hint: "[data-model | api | ui | events | all]"
---

# Hop dong cap du an

`__SPECKIT_COMMAND_PLAN__` sinh `contracts/` **cho tung lat**, trong
`specs/NNN-*/`. Lenh nay sinh `contracts/` **cho ca du an**, o goc repo. Hai cho
khac nhau va khong giam nhau: cai o goc la thu ma lat nao cung phai tuan; cai
trong `specs/` la chi tiet rieng cua lat do.

## Tang

**TANG DU AN.** Can `docs/02-architecture.md`. Chua co thi chay
`/speckit-masterplan-design` truoc.

## User Input

$ARGUMENTS

De trong hoac `all` = sinh ca bon. Nguoi dung goi ten mot cai thi chi lam cai do.

## Steps

1. Doc `masterplan-config.yml` lay `contracts_dir` (mac dinh `contracts`),
   `architecture`, `roadmap`.

2. Doc `docs/02-architecture.md` muc 5 (mo hinh khai niem) va muc 4 (ranh gioi).

3. Neu `<contracts_dir>/` **da co file**: doc truoc, roi **bo sung**, khong ghi de.
   Moi thay doi phai co mot dong trong `CHANGELOG.md`.

4. Sinh cac file duoc yeu cau theo khuon o duoi.

5. Cho nao kien truc khong noi du: ghi `[CAN QUYET]` kem cau hoi. Khong tu dat ten
   bang hay ma loi ma kien truc chua he nhac toi.

6. Bao lai: file nao da ghi, bao nhieu `[CAN QUYET]`.

## Bon hop dong

### contracts/data-model.md
```markdown
# Mo hinh du lieu

Moi bang o day co cot "Lat tao" — lat do la lat duy nhat duoc phep tao bang do.

## [Nhom]
### `ten_bang`
| Cot | Kieu | Bat buoc | Y nghia |
|---|---|---|---|

**Lat tao:** NNN · **Lat doc:** NNN, MMM
**Bat bien:** [vd: moi ban ghi co tenant_id]
```

### contracts/api.md
```markdown
# Hop dong API

## Chung
Duong dan goc, dinh dang ngay, phan trang, thu tu sap xep mac dinh.

## Xac thuc
| Loai token | Ai cam | Lam duoc gi | Het han |
|---|---|---|---|

## Dinh dang loi — dung cho MOI endpoint
[Mot khuon duy nhat. Moi noi hien loi deu doc khuon nay.]

| Ma | HTTP | Khi nao | Nguoi dung thay gi |
|---|---|---|---|

## Endpoint
### `METHOD /duong/dan`
**Lat tao:** NNN · **Ai goi duoc:** [loai token]
Vao / Ra / Loi co the gap.
```

### contracts/ui.md
```markdown
# Hop dong giao dien

## Token
| Nhom | Ten | Gia tri | Dung khi |
|---|---|---|---|
(mau, chu, khoang cach, vien, do do, chuyen dong)

## Component
| Component | Bien the | Trang thai | Lat tao |
|---|---|---|---|

Trang thai bat buoc xet du: mac dinh, hover, focus, disabled, dang tai, loi, rong.
Man hinh khong ve trang thai "rong" va "loi" la man hinh chua ve xong.

## Mau bo cuc
## A11y toi thieu
[Muc tuong phan, thao tac ban phim, vung cham, thu tu focus.]
```

### contracts/events.md
```markdown
# Su kien va trang thai
(chi sinh khi kien truc co hang doi, job, hoac trang thai bat dong bo)

## May trang thai
[Trang thai, chuyen tiep hop le, cho nao la cuoi.]

## Thong diep
| Ten | Ai phat | Ai nghe | Noi dung | Lat tao |
|---|---|---|---|---|

## Cach tinh do tuoi
```

### contracts/CHANGELOG.md
```markdown
# Thay doi hop dong
## [ngay] — lat NNN
- them bang `x` (data-model)
- doi ma loi `E_Y` (api) — **pha vo tuong thich**, lat MMM phai sua theo
```

## Rules

- **Moi bang, endpoint, component phai co "Lat tao".** Khong biet lat nao tao ra
  no nghia la no chua thuoc ve ai, va se co hai lat cung tao.
- **Doi hop dong thi phai vao CHANGELOG truoc khi sang lat sau.** Day la ky luat
  duy nhat giu cho nhieu nguoi lam song song khong ghi de nhau.
- **Khong bia.** Kien truc khong noi thi ghi `[CAN QUYET]`.
- **Khong ghi de phan da chot.** Bo sung, roi ghi vao CHANGELOG.
- Khong sinh code, khong tao migration, khong tao spec.
