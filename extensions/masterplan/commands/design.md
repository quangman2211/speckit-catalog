---
description: "Tu blueprint viet docs/02-architecture.md: cac thanh phan va viec cua tung cai, luong du lieu di dau, ranh gioi nao khong duoc vuot, mo hinh du lieu o muc khai niem, va bang danh doi cho moi cho co hai duong. Dung sau /speckit-masterplan-architect va truoc /speckit-masterplan-slice — vi khong biet ranh gioi thi khong cat lat duoc. Thuoc TANG DU AN."
argument-hint: "[phan can thiet ke ky, hoac de trong de thiet ke toan he]"
---

# Thiet ke he thong

Bien blueprint (CAI GI) thanh mot ban thiet ke (HINH GI). Day la ban ve ma moi
lat sau nay se cat ra tu no.

## Tang

**TANG DU AN.** Can `docs/01-blueprint.md` da ton tai. Chua co thi chay
`/speckit-masterplan-architect` truoc — thiet ke ma khong co blueprint la ve mot
thu chua ai chot hinh dang.

Khac voi `__SPECKIT_COMMAND_PLAN__`: `plan` thiet ke **mot feature** trong pham vi
mot lat da chot; lenh nay thiet ke **ca he thong** de biet cat lat o dau.

## User Input

$ARGUMENTS

De trong = thiet ke toan he.

## Steps

1. Doc `.specify/extensions/masterplan/masterplan-config.yml` lay `blueprint`,
   `architecture`, `adr_dir`.

2. Doc blueprint. Chu y ba muc: **6. Ranh gioi he thong**, **7. Quy mo**,
   **8. Bat bien** — ba muc do la thu quyet dinh hinh dang, khong phai muc 1.

3. Voi moi cho blueprint ghi `[CAN QUYET]` ma anh huong toi hinh dang: **hoi**,
   dung tu chon. Dat cau hoi danh so, cho tra loi toc ky.

4. Viet `docs/02-architecture.md` theo khuon o duoi.

5. Moi dong trong bang danh doi ma la **quyet dinh mot chieu** → noi nguoi dung
   chay `/speckit-masterplan-decide "<quyet dinh>"` de ghi thanh ADR. Khong tu ghi
   ADR trong lenh nay.

6. Bao lai: da ghi file nao, bao nhieu cho can ADR, con bao nhieu `[CAN QUYET]`.

## Khuon — docs/02-architecture.md

```markdown
# Kien truc: [Ten du an]

**Nguon:** docs/01-blueprint.md v[x] · **Ngay:** [ngay]

## 1. So do thanh phan

[So do ASCII hoac mermaid. Moi hop la mot thu **trien khai rieng duoc**;
neu hai hop luon deploy cung nhau thi chung la mot hop.]

## 2. Tung thanh phan
| Thanh phan | Viec cua no | Cai gi KHONG phai viec cua no | Noi chuyen voi |
|---|---|---|---|

Cot thu ba la cot quan trong nhat. Khong ghi ro cai gi khong phai viec cua no
thi ba thang nua no se lam ca.

## 3. Luong du lieu
[Voi moi canh chinh trong blueprint muc 3: du lieu di tu dau, qua dau, doi hinh
o cho nao, dung lai o dau.]

## 4. Ranh gioi khong duoc vuot
| Ranh gioi | Nghia la | Kiem duoc bang |
|---|---|---|
| vd: extension khong goi thang CSDL | moi ghi deu qua API | grep chuoi ket noi trong apps/ext |

Ranh gioi khong kiem duoc bang cai gi thi khong phai ranh gioi, chi la mong muon.

## 5. Mo hinh du lieu — muc khai niem
[Thuc the va quan he, KHONG phai schema. Ten bang, cot, kieu la viec cua
contracts/data-model.md.]

## 6. Danh doi
| Cho | Duong A | Duong B | Chon | Vi sao | Mot chieu? |
|---|---|---|---|---|---|

Cot cuoi = co dao nguoc duoc khong. `co` → cu lam roi doi sau. `khong` → phai co ADR.

## 7. Quy mo va cho no gay
| Chi so (tu blueprint muc 7) | Thiet ke nay chiu duoc | Gay o dau truoc |
|---|---|---|

## 8. Cho con treo
| # | Cau hoi | Chan viec gi |
|---|---|---|
```

## Rules

- **Khong chon framework.** Lenh nay chon **hinh dang**, khong chon cong cu. "Mot
  dich vu API va mot hang doi" la thiet ke; "FastAPI va Redis" la
  `__SPECKIT_COMMAND_PLAN__`.
- **Moi hop phai trien khai rieng duoc.** Hai hop luon di cung nhau la mot hop ve
  thanh hai — no lam nguoi ta tuong co ranh gioi o do.
- **Bang danh doi khong duoc de trong.** Mot thiet ke khong co danh doi nao la
  mot thiet ke chua ai nghi ky, hoac mot thiet ke da bo qua nhung cho kho.
- **Doi chieu voi muc 7 cua blueprint.** Thiet ke chiu duoc quy mo nam dau nhung
  khong noi gay o dau truoc thi chua kiem duoc.
- Chi ghi mot file: `docs/02-architecture.md`. ADR la viec cua lenh khac.
