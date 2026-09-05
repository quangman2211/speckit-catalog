---
description: "Ghi mot quyet dinh mot chieu thanh ADR co danh so trong docs/04-decisions/: boi canh, quyet dinh, cac phuong an da loai kem ly do that, he qua phai chiu, va dieu kien de xem lai. Dung khi chon dinh dang luu tru, chon ranh gioi service, chon mo hinh du lieu — nhung cho sai roi thi khong lam lai duoc. Thuoc TANG DU AN, nhung chay duoc bat cu luc nao."
argument-hint: "<quyet dinh can ghi>"
---

# Ghi mot quyet dinh

Mot ADR ton tai de **ba thang sau co nguoi hoi \"vi sao lai lam kieu nay\"** va
co cau tra loi. Khong phai de co tai lieu.

## Tang

**TANG DU AN**, nhung khong phu thuoc thu tu — quyet dinh nay ra luc nao thi ghi
luc do. Thuong duoc goi tu bang danh doi cua `/speckit-masterplan-design`, hoac tu
mot cho `__SPECKIT_COMMAND_PLAN__` phai chon giua hai duong.

## User Input

$ARGUMENTS

De trong = doc `docs/02-architecture.md` muc 6, liet ke cac dong "mot chieu: khong"
chua co ADR, va hoi nguoi dung chon mot.

## Steps

1. Doc `.specify/extensions/masterplan/masterplan-config.yml` lay `adr_dir`
   (mac dinh `docs/04-decisions`).

2. Tim so ADR ke tiep: quet `<adr_dir>/ADR-*.md`, lay so lon nhat + 1, dinh dang
   ba chu so. Chua co thu muc thi tao, bat dau tu `001`.

3. **Kiem trung truoc khi viet.** Doc tieu de moi ADR da co. Neu quyet dinh nay
   sua mot ADR cu → khong tao moi ma ghi ADR moi voi trang thai `Thay the ADR-NNN`,
   va sua trang thai cua ADR cu thanh `Bi thay the boi ADR-MMM`.

4. Hoi cho du bon thu, dung tu suy: **boi canh** (cai gi ep phai chon bay gio),
   **cac phuong an that su da can nhac**, **vi sao loai tung cai**, va **cai gia
   phai tra** cho phuong an duoc chon.

5. Ghi `<adr_dir>/ADR-NNN-<slug>.md` theo khuon.

6. Bao lai duong dan file va so ADR.

## Khuon — ADR-NNN-slug.md

```markdown
# ADR-NNN: [Quyet dinh, viet o the khang dinh]

**Trang thai:** Da chot · **Ngay:** [ngay] · **Nguoi quyet:** [ai]

## Boi canh
[Cai gi dang ep phai chon bay gio. Neu khong co gi ep thi day chua phai luc ghi ADR.]

## Quyet dinh
[Mot doan. The chu dong: "Dung X de lam Y".]

## Cac phuong an da can nhac
| Phuong an | Duoc gi | Loai vi |
|---|---|---|
| **[da chon]** | | — |

Moi dong "loai vi" phai la mot ly do **rieng cho du an nay**. "Khong pho bien"
khong phai ly do.

## He qua
**Chap nhan:** [cai gia phai tra — cham hon, ton hon, phuc tap hon o dau]
**Doi lai:** [duoc gi]
**Keo theo:** [viec gi bay gio bat buoc phai lam theo cach nay]

## Dao nguoc duoc khong
[Sau bao lau thi doi lai ton bao nhieu. Neu re thi noi ro — de sau nay khong ai
so ma khong dam doi.]

## Xem lai khi nao
[Dieu kien cu the khien quyet dinh nay khong con dung. Vd: "khi qua 50 store",
"khi eBay doi API". Khong co dieu kien thi ghi 'khong co du dinh xem lai'.]
```

## Rules

- **It nhat hai phuong an that.** Mot ADR chi liet ke phuong an duoc chon la mot
  thong bao, khong phai quyet dinh. Phuong an "khong lam gi ca" gan nhu luon la
  mot phuong an that.
- **"Loai vi" phai rieng cho du an nay.** Ly do chung chung nghia la chua thuc su
  can nhac.
- **Muc He qua khong duoc de trong.** Moi quyet dinh deu co gia. Khong tim ra gia
  nghia la chua hieu quyet dinh.
- **Khong sua ADR da chot.** Thay the bang ADR moi. Lich su quyet dinh la thu co
  gia tri nhat trong thu muc nay.
- Chi ghi mot file. Khong sua kien truc, khong sinh code.
