---
description: "Chay chin tieu chi tu kiem tren roadmap va cac prompt lat: ten lat co phai ten tang ky thuat khong, moi lat co demo duoc gi khong, co phu thuoc nguoc khong, prompt dai bao nhieu dong, co nhac framework khong, con bao nhieu cho treo, lat dau co phai walking skeleton, va moi tinh nang trong blueprint da co cho chua. Dung sau /speckit-masterplan-slice va truoc khi specify lat dau tien."
argument-hint: ""
scripts:
  sh: scripts/bash/check.sh
---

# Tu kiem roadmap

Bay trong chin tieu chi kiem duoc bang script. Hai cai con lai phai doc moi biet —
do la phan viec cua lenh nay.

## Tang

**TANG DU AN.** Can `docs/05-roadmap.md` va `docs/slices/`.

## Steps

1. Chay `.specify/extensions/masterplan/scripts/bash/check.sh` va **in nguyen ket
   qua** cho nguoi dung. Khong tom tat lai — cac dong `[FAIL]` la thu ho can doc.

2. Voi moi dong `[FAIL]`, de xuat cach sua **cu the**: sua o file nao, dong nao,
   thanh gi. Khong tu sua roadmap tru khi nguoi dung bao sua.

3. Soat hai tieu chi con lai:

   **A · Lat 001 co phai walking skeleton khong.**
   Doc `docs/slices/001-*.md` va `docs/02-architecture.md` muc 2.
   - Moi thanh phan trong bang thanh phan co xuat hien trong lat 001 khong?
   - Lat 001 co bang nghiep vu nao khong? (co = khong phai skeleton)
   - Muc "Hoan thanh khi" co kiem duoc **khong can nghiep vu** khong?

   **B · Moi tinh nang trong blueprint da co cho chua.**
   Doc `docs/01-blueprint.md` muc 4 (trong pham vi) va 5 (ngoai pham vi).
   Lap bang doi chieu:

   | Tinh nang trong blueprint | O lat nao | Hoac o muc Ngoai pham vi | Bi bo quen |
   |---|---|---|---|

   Dong nao roi vao cot cuoi la mot loi that: mot thu da hua trong blueprint ma
   khong lat nao lam va cung khong ai tuyen bo la khong lam.

4. Ket luan bang mot cau: **du dieu kien specify lat dau tien chua**, va neu chua
   thi thieu chinh xac cai gi.

## Rules

- **In nguyen output cua script.** Don gian hoa lai la giau mat thong tin nguoi
  dung can.
- **Khong tu sua.** Bao cho nguoi dung sua, tru khi ho yeu cau. Roadmap la thu ho
  phai tin — sua sau lung ho la lam mat cho do.
- **Tieu chi B khong duoc bo qua.** Do la tieu chi duy nhat bat duoc thu bi
  **bien mat** giua blueprint va roadmap, va script khong bao gio bat duoc.
- **Con `[FAIL]` thi ket luan la chua du dieu kien.** Khong "gan du".
