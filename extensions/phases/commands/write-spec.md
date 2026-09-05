---
description: "Soat va lam day spec.md cua lat hien tai: van de, muc tieu do duoc, non-goals kem ly do, user story, yeu cau xep theo Must/Should/Could/Won't, tieu chi nghiem thu, va cau hoi con treo. Dung khi spec vua sinh ra con so sai, khi khong biet lat da du chua de sang plan, hoac khi can chot pham vi truoc khi bung nhieu nguoi lam. Thuoc giai doan SPEC."
argument-hint: "<phan can lam ro, hoac de trong de soat toan bo spec>"
---

# Lam day spec

> Sao chep va sua doi tu skill `write-spec` cua
> [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins),
> Apache-2.0. **Da sua:** doi tu "viet PRD tu dau" sang "lam day spec.md da co",
> them lop ghi file, rang buoc giai doan, bo phan connector.

## Giai doan

**SPEC.** Can `spec.md` cua lat hien tai da ton tai — lenh nay **lam day**, khong
viet moi. Chua co thi bao nguoi dung chay `__SPECKIT_COMMAND_SPECIFY__` truoc.

Chay truoc `__SPECKIT_COMMAND_PLAN__`. Sang plan khi spec con lo la ban ve mot
thu chua ai chot hinh dang.

## User Input

$ARGUMENTS

De trong = soat toan bo spec.

## Steps

1. Doc `spec.md` cua lat hien tai, constitution, va `roadmap` neu co — de biet
   lat nay dang tra loi cau hoi gi trong buc tranh lon.

2. Doi chieu voi sau muc o duoi. Muc nao thieu hoac yeu thi **hoi truoc, dung
   tu dien**. Dat 5–10 cau hoi danh so, cho phep tra loi toc ky.

3. Voi phan da du thong tin: viet bo sung vao `spec.md`, giu nguyen phan da chot.
   Sua bang thay the tung doan, khong in lai ca file.

4. Cho nao khong du thong tin de viet: ghi `[CAN QUYET]` kem cau hoi cu the.

5. Bao lai: da bo sung muc nao, con bao nhieu `[CAN QUYET]`, va co du dieu kien
   sang plan chua.

## Sau muc phai co

### Van de
- 2–3 cau mo ta van de cua nguoi dung
- Ai gap, gap bao nhieu lan
- Khong giai thi mat gi
- Dua tren bang chung: nghien cuu, du lieu ho tro, so lieu — khong dua tren cam giac

### Muc tieu
- 3–5 ket qua **do duoc**
- Moi muc tieu tra loi duoc: "lam sao biet la thanh cong?"
- Tach muc tieu cua nguoi dung va muc tieu cua doanh nghiep
- Muc tieu la **ket qua, khong phai san pham**: "giam nua thoi gian tu luc mo den
  luc thay gia tri", khong phai "lam wizard onboarding"

### Non-goals
- 3–5 dieu lat nay **co y khong lam**
- Moi dong kem ly do ngan: tac dong nho, qua phuc tap, viec rieng, hoac chua toi luc
- Day la thu chan pham vi phinh ra giua chung, va la thu nguoi doc sau nay can nhat

### User story
Dang: "La [loai nguoi dung], toi muon [lam duoc gi] de [duoc loi gi]".

Nam loi hay gap:
- **Mo ho**: "toi muon no nhanh hon" — nhanh o cho nao?
- **Ke san giai phap**: "toi muon mot dropdown" — mo ta nhu cau, dung mo ta widget
- **Khong co loi ich**: "toi muon bam mot nut" — de lam gi?
- **Qua to**: "toi muon quan ly doi cua toi" — cat nho ra
- **Huong noi bo**: "doi ky thuat muon refactor DB" — do la task, khong phai story

### Yeu cau — MoSCoW
| Muc | Nghia | Phep thu |
|---|---|---|
| **Must** | khong co thi lat khong dung duoc | "cat cai nay di, lat con giai quyet van de goc khong?" |
| **Should** | quan trong nhung khong chan ra mat | lam ngay sau |
| **Could** | co thi tot | cat khong lam cham tien do |
| **Won't** | co y khong lam lan nay | co the xem lai sau |

Tan nhan voi Must. **Cai gi cung Must thi khong cai gi la Must.** Should phai la
thu chac chan se lam som, khong phai danh sach uoc.

### Tieu chi nghiem thu
Moi yeu cau Must co it nhat mot dong nghiem thu **kiem duoc bang tay**, viet
truoc khi co code. Viet khong noi tieu chi nghiem thu la dau hieu lat chua cat
xong: hoac no dang om hai quyet dinh, hoac chua ai biet minh muon gi.

## Rules

- **Hoi truoc, dung tu dien.** Cho nao spec khong noi thi hoi nguoi dung. Tu dien
  la dat mot quyet dinh vao mieng ho ma khong ai biet.
- **Khong ghi de phan da chot.** Bo sung, khong viet lai.
- **Khong ke ky thuat.** Spec noi CAI GI va VI SAO. Framework, thu vien, so bang
  la viec cua `__SPECKIT_COMMAND_PLAN__`.
- **Khong sinh code, khong tao file khac.** Chi sua `spec.md`.
- Muc tieu khong do duoc thi khong phai muc tieu — doi thanh do duoc, hoac bo.
