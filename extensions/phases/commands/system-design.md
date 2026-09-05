---
description: "Thiet ke he thong va ghi ra docs/02-architecture.md — yeu cau chuc nang va phi chuc nang, so do thanh phan, luong du lieu, mo hinh du lieu, ranh gioi service, chien luoc cache va hang doi, va phan tich danh doi. Dung khi hoi 'nen thiet ke the nao', 'kien truc nao dung', khi can thiet ke API hoac mo hinh du lieu, hoac khi ranh gioi giua cac phan con mo ho. Thuoc giai doan PLAN."
argument-hint: "<he thong hoac thanh phan can thiet ke>"
---

# Thiet ke he thong

> Sao chep va sua doi tu skill `system-design` cua
> [anthropics/knowledge-work-plugins](https://github.com/anthropics/knowledge-work-plugins),
> Apache-2.0. **Da sua:** them lop ghi file, rang buoc giai doan, khuon output,
> va luat "quyet dinh mot chieu thi tach ra thanh ADR".

## Giai doan

**PLAN.** Can `plan.md` cua lat hien tai. Chua co thi dung lai va bao nguoi dung
chay `__SPECKIT_COMMAND_PLAN__` truoc.

Quan he voi `/speckit-phases-architecture`: lenh nay mo ta **he thong**; lenh kia
ghi lai **mot quyet dinh** kem cac phuong an da bo. Thiet ke xong ma co cho phai
chon giua hai duong sua rat dat sau nay, tach cho do ra thanh ADR rieng.

## User Input

$ARGUMENTS

## Steps

1. Doc `plan.md`, `spec.md` cua lat hien tai, va constitution
   (`.specify/memory/constitution.md`) de biet rang buoc bat bien.

2. Doc `docs/02-architecture.md` neu da co — bo sung, khong ghi de. Kien truc la
   thu tich luy qua nhieu lat.

3. Di het nam buoc duoi day. Buoc nao khong ap dung thi ghi "khong ap dung, vi X"
   — dung bo trong.

4. Ghi `docs/02-architecture.md`.

5. Liet ke cac cho phai chon giua hai duong, va de xuat mo ADR cho tung cho bang
   `/speckit-phases-architecture`.

## Nam buoc

### 1. Thu thap yeu cau
- Yeu cau chuc nang: he thong lam duoc gi
- Yeu cau phi chuc nang: quy mo, do tre, do san sang, chi phi
- Rang buoc: kich thuoc doi, han giao, stack dang co

### 2. Thiet ke tong the
- So do thanh phan
- Luong du lieu
- Hop dong API
- Chon cho luu tru

### 3. Di sau
- Mo hinh du lieu
- Thiet ke endpoint (REST, GraphQL, gRPC)
- Chien luoc cache
- Hang doi va su kien
- Xu ly loi va retry

### 4. Quy mo va do tin cay
- Uoc luong tai
- Mo rong ngang hay doc
- Du phong va chuyen doi khi hong
- Giam sat va canh bao

### 5. Phan tich danh doi
Moi quyet dinh deu co danh doi — **noi ra**. Can nhac: do phuc tap, chi phi, do
quen cua doi, thoi gian ra thi truong, gia bao tri.

## Khuon output

```markdown
# Kien truc he thong

> Chi session `arch` duoc sua. Moi thay doi ghi mot dong vao contracts/CHANGELOG.md.

## Yeu cau
### Chuc nang
### Phi chuc nang
| Chieu | Muc tieu | Do bang gi |
|---|---|---|
| Do tre | [...] | [...] |
| Quy mo | [...] | [...] |
| Do san sang | [...] | [...] |

### Rang buoc
[Doi, han, stack — nhung thu khong doi duoc]

## Thiet ke tong the
[So do thanh phan bang ASCII, luong du lieu, ranh gioi]

## Cho luu tru
| Du lieu | O dau | Vi sao |
|---|---|---|

## Hang doi va su kien
| Su kien | Ai phat | Ai nhan | Payload |
|---|---|---|---|

## Xu ly loi
[Cai gi retry, cai gi khong, va vi sao]

## Danh doi da chap nhan
| Quyet dinh | Duoc | Mat | Xem lai khi nao |
|---|---|---|---|

## Gia dinh
[Nhung dieu dang cho la dung — de sau nay biet cho nao kiem lai]

## Se phai xem lai khi he thong lon len
[Cai gi vo truoc]
```

## Rules

- **Moi gia dinh phai duoc viet ra.** Gia dinh khong viet ra la gia dinh khong ai
  kiem duoc.
- **Khong thiet ke cho quy mo chua ton tai.** Uoc luong tai theo so that trong
  `spec.md`, khong theo so mo uoc.
- **Khong viet code.** Day la mo ta kien truc.
- Quyet dinh mot chieu (mo hinh tenant, dinh danh, ranh gioi du lieu, hop dong du
  lieu, noi cat bi mat) **phai** tach ra thanh ADR rieng, khong chon vao day.
