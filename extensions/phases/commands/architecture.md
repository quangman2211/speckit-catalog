---
description: "Ghi mot quyet dinh kien truc thanh ADR co danh so trong docs/04-decisions/. Dung khi chon giua hai cong nghe (Kafka hay SQS), khi chot mot quyet dinh mot chieu (mo hinh tenant, dinh danh, ranh gioi du lieu, hop dong du lieu, noi cat bi mat), khi soat mot de xuat thiet ke, hoac khi thiet ke mot thanh phan moi tu yeu cau va rang buoc. Thuoc giai doan PLAN — chay sau khi da co plan.md."
argument-hint: "<quyet dinh can chot, hoac he thong can thiet ke>"
---

# ADR — ghi lai quyet dinh kien truc

> Sao chep va sua doi tu skill `architecture` cua
> [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins),
> Apache-2.0. **Da sua:** them lop ghi file, danh so ADR, rang buoc giai doan,
> va bo phan connector.

Sinh mot Architecture Decision Record, hoac danh gia mot thiet ke da co.

## Giai doan

**PLAN.** Can `plan.md` cua lat hien tai da ton tai. Chua co thi dung lai va
bao nguoi dung chay `__SPECKIT_COMMAND_PLAN__` truoc — ADR viet truoc khi biet
lam gi la ADR bia.

## User Input

$ARGUMENTS

## Steps

1. Doc cau hinh `.specify/extensions/phases/phases-config.yml` lay `adr_dir`
   (mac dinh `docs/04-decisions`).

2. Doc `plan.md` va `spec.md` cua lat hien tai de biet rang buoc that: quy mo,
   do tre, ngan sach, kich thuoc doi, han giao. Rang buoc quyet dinh cau tra loi
   nhieu hon so thich cong nghe.

3. Quet `<adr_dir>/ADR-*.md` de:
   - lay so lon nhat, ADR moi = so do + 1, dinh dang 3 chu so
   - **doc lai cac ADR da co**: quyet dinh moi mau thuan voi ADR cu thi noi ra,
     va danh dau ADR cu `Superseded` thay vi im lang ghi de

4. Xac dinh **cac phuong an**, it nhat hai. Ke ca khi da nghieng han ve mot
   ben — phuong an duoc goi ten thi phan tich moi can.

5. Viet ADR theo dung khuon o duoi, ghi vao
   `<adr_dir>/ADR-<NNN>-<slug>.md`.

6. Bao lai duong dan file va mot cau tom tat quyet dinh.

## Nam cua mot chieu

Nam quyet dinh nay sua rat dat sau khi da co du lieu that. Neu du an chua co
ADR cho chung, nhac nguoi dung — ke ca khi ho hoi viec khac:

| Cua | Slug |
|---|---|
| Mo hinh tenant | `tenant-model` |
| Dinh danh va phan quyen | `identity` |
| Ranh gioi du lieu, ke ca cache va log | `data-boundary` |
| Hop dong du lieu va cach danh version | `data-contract` |
| Noi cat bi mat cua khach | `secrets` |

Du an chua co khach thu hai van phai viet — duoc phep viet ngan
("chua ap dung, vi X"). Cai bi cam la bo trong.

## Khuon ADR

```markdown
# ADR-[NNN]: [Tieu de]

**Status:** Proposed | Accepted | Deprecated | Superseded
**Date:** [ngay]
**Lat:** [NNN-slug cua lat lam phat sinh quyet dinh nay]
**Deciders:** [ai phai dong y]

## Boi canh
[Tinh huong la gi? Nhung luc nao dang keo?]

## Quyet dinh
[Doi cai gi?]

## Cac phuong an da can nhac

### Phuong an A: [Ten]
| Chieu | Danh gia |
|-------|----------|
| Do phuc tap | [Thap/Vua/Cao] |
| Chi phi | [...] |
| Kha nang mo rong | [...] |
| Doi da quen chua | [...] |

**Duoc:** [...]
**Mat:** [...]

### Phuong an B: [Ten]
[Cung khuon]

## Danh doi
[Danh doi chinh giua cac phuong an, kem ly do ro rang]

## He qua
- [Cai gi de hon]
- [Cai gi kho hon]
- [Cai gi se phai xem lai]

## Viec phai lam
1. [ ] [Buoc trien khai]
2. [ ] [Theo doi tiep]
```

## Rules

- **Khong bao gio chi mot phuong an.** ADR mot phuong an la thong bao, khong
  phai quyet dinh.
- **Moi phuong an phai co muc "Mat".** Phuong an khong co nhuoc diem la phuong
  an chua duoc nghi ky.
- **Rang buoc that di truoc so thich.** "Ship trong 2 tuan" hoac "chiu 10K rps"
  dinh hinh cau tra loi manh hon "cong nghe nao hay hon".
- Yeu cau phi chuc nang — do tre, chi phi, do quen cua doi, gia bao tri — tinh
  ngang voi tinh nang.
- **Khong sua code trong lenh nay.** ADR mo ta quyet dinh; thuc thi la viec cua
  `__SPECKIT_COMMAND_IMPLEMENT__`.
- Khong ghi de ADR cu. Quyet dinh thay doi thi viet ADR moi va danh dau cai cu
  `Superseded`.
