---
description: "Hoi dap tung vong de dung docs/01-blueprint.md tu con so khong — khong can tai lieu san. Nam vong: ai dung va dau o dau, canh nao chay duoc thi goi la co he thong, ranh gioi voi ben ngoai, quy mo that, va cai gi co y khong lam. Ghi ra docs/01-blueprint.md. Dung khi bat dau mot du an moi, khi co y tuong nhung chua co tai lieu, hoac khi nhieu nguoi dang hieu khac nhau ve pham vi. Thuoc TANG DU AN, chay truoc moi thu khac."
argument-hint: "<mot cau ve thu dinh xay, hoac de trong>"
scripts:
  sh: scripts/bash/state.sh
---

# Dung blueprint bang hoi dap

Lenh nay **khong doc tai lieu roi tom tat**. No hoi, va tu cau tra loi cua nguoi
dung ma dung ra blueprint. Neu trong repo da co tai lieu (`docs/00-*.md`, ghi chu,
export) thi doc truoc de **khoi hoi lai nhung gi da biet** — nhung con lai van la
hoi.

## Tang

**TANG DU AN.** Chay mot lan, truoc `__SPECKIT_COMMAND_SPECIFY__` va truoc
`__SPECKIT_COMMAND_CONSTITUTION__`. Ket qua cua no la dau vao cho
`/speckit-masterplan-design` va `/speckit-masterplan-slice`.

## User Input

$ARGUMENTS

De trong cung duoc — vong 1 se hoi tu dau.

## Steps

1. Doc `.specify/extensions/masterplan/masterplan-config.yml` lay duong dan
   `blueprint`. Neu file do **da ton tai**, doc no va chuyen sang che do bo sung:
   chi hoi nhung muc con trong hoac con `[CAN QUYET]`, khong hoi lai tu dau.

2. Quet `docs/` va `README.md` tim thu da viet san. Moi thu tim duoc, ghi lai
   thanh mot dong "da biet" va **khong hoi lai** — nhung phai **doc len cho nguoi
   dung xac nhan** truoc khi coi la that.

3. Chay nam vong hoi o duoi. **Moi luot mot vong.** Hoi 3-6 cau danh so, cho
   phep tra loi toc ky ("1. hai nguoi 2. khong biet 3. bo qua"). Doi tra loi
   xong moi sang vong sau.

4. Sau vong 5, viet `docs/01-blueprint.md` theo khuon o duoi.

5. Bao lai: da ghi file nao, con bao nhieu `[CAN QUYET]`, va lenh tiep theo la
   `/speckit-masterplan-design`.

## Nam vong hoi

### Vong 1 — Ai, va dau o dau
- Ai se ngoi truoc man hinh nay? (vai tro, khong phai ten)
- Hom nay ho lam viec do bang cach nao? (Excel, tay, khong lam gi)
- Cho nao dau nhat — cho mat thoi gian, hay cho hay sai?
- Khong lam gi ca thi ba thang nua mat cai gi?

Muc dich: co mot cau "he thong nay ton tai de ___" ma **do duoc**.

### Vong 2 — Mot chay duoc dau tien
- Ke mot canh dau-cuoi ma khi no chay duoc thi anh goi la "da co he thong".
  Ai bam gi, roi thay gi?
- Trong canh do, du lieu di tu dau toi dau?
- Thu gi trong canh do neu bo di thi canh van con y nghia?

Muc dich: biet duoc **lat 001 (walking skeleton)** se cham vao nhung phan nao.

### Vong 3 — Ranh gioi
- Du lieu tu dau ma co? (nguoi go tay, keo tu he khac, sinh ra trong he)
- Phai noi chuyen voi he thong ngoai nao? Ai so huu he do — minh hay ho?
- Cho nao minh **khong duoc quyen** thay doi? (API cua nguoi ta, dinh dang co san,
  quy trinh phong ban khac)
- Cai gi la mot chieu — sai roi thi khong lam lai duoc? (chon dinh dang luu tru,
  chon mo hinh tinh phi, xoa du lieu goc)

Muc dich: biet cho nao can ADR, cho nao can hop dong.

### Vong 4 — Quy mo that
- Bao nhieu nguoi dung cung luc, thang dau? Nam dau?
- Bao nhieu ban ghi? Moi ngay them bao nhieu?
- Bao lau mot lan thi du lieu phai tuoi lai? (thoi gian thuc, moi gio, moi ngay)
- Cai gi hong thi coi la su co? Chiu duoc bao lau?

Muc dich: chan phong doan qua tay. Con so that quyet dinh kien truc, cam giac thi khong.

### Vong 5 — Co y khong lam
- Cai gi nghe rat hop ly nhung **lan nay khong lam**? Vi sao?
- Cai gi de dan sau, khong phai lam lai tu dau?
- Cai gi neu ai do de nghi thi cau tra loi la khong, mai mai?

Muc dich: muc "Ngoai pham vi" — thu chan pham vi phinh ra, va la thu nguoi doc
sau nay can nhat.

## Khuon — docs/01-blueprint.md

```markdown
# Blueprint: [Ten du an]

**Phien ban:** 0.1 · **Ngay:** [ngay] · **Dung bang:** hoi dap qua /speckit-masterplan-architect

## 1. He thong nay ton tai de lam gi
[Mot doan. Ket bang mot cau do duoc.]

## 2. Nguoi dung
| Vai tro | Hom nay ho lam the nao | Cai gi dau nhat |
|---|---|---|

## 3. Mot chay duoc dau tien
[Canh dau-cuoi, ke theo thu tu nguoi dung thay. Day chinh la lat 001.]

## 4. Trong pham vi
- [...]

## 5. Ngoai pham vi — co y khong lam
| Khong lam | Vi sao |
|---|---|

## 6. Ranh gioi he thong
| He thong ngoai | Ai so huu | Minh doc hay ghi | Doi duoc khong |
|---|---|---|---|

## 7. Quy mo
| Chi so | Thang dau | Nam dau | Nguong hong |
|---|---|---|---|

## 8. Bat bien
[Nhung dieu dung o moi lat. Vd: "moi bang co tenant_id", "khong bao gio tu ghi
len he thong cua nguoi ta ma khong co nguoi bam".]

## 9. Quyet dinh mot chieu can ADR
| # | Quyet dinh | Chan viec gi |
|---|---|---|

## 10. Cho con treo
| # | Cau hoi | Chan lat nao |
|---|---|---|
```

## Rules

- **Hoi truoc, dung tu dien.** Cho nao nguoi dung khong noi thi ghi
  `[CAN QUYET]` kem cau hoi cu the. Tu dien la dat mot quyet dinh vao mieng ho
  ma khong ai biet.
- **Moi luot mot vong.** Ban 25 cau mot lan thi nhan lai 25 cau tra loi qua loa.
- **Khong ke ky thuat.** Blueprint noi CAI GI va VI SAO. Framework, so bang, ten
  service la viec cua `/speckit-masterplan-design`.
- **Con so phai la con so.** "Nhieu nguoi dung" khong phai cau tra loi cho vong 4 —
  hoi lai cho toi khi co mot con so, hoac ghi `[CAN QUYET]`.
- **Muc 5 khong duoc de trong.** Mot blueprint khong noi minh khong lam gi la mot
  blueprint chua chot pham vi.
- Chi ghi mot file: `docs/01-blueprint.md`. Khong sinh code, khong tao spec.
