---
description: "Bao dang o giai doan nao (spec hay plan), thieu artifact gi, va nen chay lenh gi tiep theo. Dung khi khong ro buoc ke tiep, khi quay lai project sau mot thoi gian, hoac khi muon kiem tra truoc khi ban giao cho nguoi khac."
scripts:
  sh: scripts/bash/phase.sh
---

# Trang thai giai doan

Bao nguoi dung dang dung o dau trong vong doi SDD, dua tren file co that trong
repo — khong doan theo tri nho hoi thoai.

## Steps

1. Chay `{SCRIPT}` de lay trang thai duoi dang JSON.

2. Doc ket qua va dich sang tieng nguoi. Hai giai doan:

   - **spec** — dang lam ro CAI GI can lam. Chua co `plan.md`.
   - **plan** — dang quyet dinh LAM THE NAO. Da co `plan.md`.

   `phase: "none"` nghia la khong phai spec-kit project, hoac chua co gi ca.

3. Bao cao theo dung ba muc nay, khong dai hon:

   | Muc | Noi gi |
   |---|---|
   | Dang o dau | giai doan + ten lat hien tai |
   | Da co gi | liet ke artifact `have` dang true |
   | Thieu gi, lam gi tiep | phan tu DAU TIEN trong `missing`, kem lenh nen chay |

4. Chi de xuat **mot** buoc ke tiep — phan tu dau tien trong `missing`. Thu tu
   trong mang do da la thu tu uu tien. Liet ke ca danh sach dai lam nguoi doc
   khong biet bat dau tu dau.

## Rules

- Khong tu tao file nao. Lenh nay chi doc va bao cao.
- Khong suy dien giai doan tu cuoc hoi thoai. Chi tin `{SCRIPT}`.
- `missing` rong = khong con gi chan. Noi thang la xong, dung bia them viec.
