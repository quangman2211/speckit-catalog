---
description: "Cat du an thanh cac lat mong demo duoc: ghi docs/05-roadmap.md voi cot demo, phu thuoc, cong chan, va sinh mot file prompt dan-duoc cho tung lat trong docs/slices/. Moi lat la mot vong /speckit.specify den /speckit.implement. Dung sau khi da co blueprint, kien truc va hop dong. Day la buoc noi tang du an voi spec-kit. Thuoc TANG DU AN."
argument-hint: "[so lat toi moc dau tien, hoac de trong]"
---

# Cat lat

Day la buoc **noi tang du an voi spec-kit**. Truoc lenh nay, spec-kit chua co gi
de lam. Sau lenh nay, moi lat la mot vong `__SPECKIT_COMMAND_SPECIFY__` →
`__SPECKIT_COMMAND_IMPLEMENT__`.

## Tang

**TANG DU AN.** Can `docs/01-blueprint.md` va `docs/02-architecture.md`. Nen co
`contracts/` — khong co thi cac lat se tu dat ten bang va endpoint theo y no.

## User Input

$ARGUMENTS

Vd `8` = cat toi moc "ban chay duoc dau tien" trong khoang 8 lat. De trong = tu
quyet, va noi ro vi sao dung o con so do.

## Steps

1. Doc `masterplan-config.yml` lay `blueprint`, `architecture`, `roadmap`,
   `slice_dir`, `contracts_dir`, `prompt_min_lines`, `prompt_max_lines`.

2. Doc blueprint (nhat la muc 3 "mot chay duoc dau tien", muc 4/5 pham vi, muc 10
   cho treo) va kien truc (muc 2 thanh phan, muc 4 ranh gioi).

3. **Chot moc truoc khi cat.** Noi ro "ban chay duoc dau tien" nghia la gi, roi
   cat toi do — khong cat toan bo tuong lai. Thu sau moc: dat ten, khong cat chi tiet.

4. Cat theo **sau luat cat** o duoi.

5. Ghi `docs/05-roadmap.md` theo khuon bang — **dung du tam cot, dung thu tu**.
   Script `check.sh` doc bang nay bang vi tri cot; sai cot la khong doc duoc.

6. Voi tung lat, ghi `<slice_dir>/NNN-<slug>.md` theo khuon prompt.

7. Chay `.specify/extensions/masterplan/scripts/bash/check.sh` va sua nhung cho
   `[FAIL]` truoc khi bao xong.

8. Bao lai: bao nhieu lat, lat 001 la gi, bao nhieu cho treo, va cau lenh de bat dau:
   `/speckit-masterplan-next`.

## Sau luat cat

1. **Lat 001 la walking skeleton.** Moi thanh phan trong kien truc deu co mat, noi
   duoc voi nhau, khong co nghiep vu nao. Cac lat sau bat chuoc cau truc cua no.

2. **Moi lat tra loi duoc "merge xong demo duoc gi".** Khong tra loi duoc = do
   khong phai lat, do la mot cong viec. Gop no vao lat khac.

3. **Khong cat theo tang.** Khong co lat ten `database`, `backend`, `frontend`,
   `setup`. Cat theo tang thi khong lat nao demo duoc mot minh, va tat ca chi
   chay duoc o lat cuoi.

4. **Phu thuoc chi tro nguoc.** Lat 005 duoc phu thuoc 003; khong bao gio nguoc lai.

5. **Cong chan la cau hoi chua ai tra loi.** Lat nao dua tren mot quyet dinh chua
   chot thi ghi cong chan vao cot do. Cong chua mo → khong specify lat do.

6. **Moi tinh nang trong blueprint phai nam o mot trong hai cho:** mot lat, hoac
   muc "Ngoai pham vi" cua roadmap. Khong duoc bien mat.

## Khuon — docs/05-roadmap.md

Bang chinh phai **dung tam cot nay, dung thu tu nay**:

```markdown
# Roadmap: [Ten du an]

**Nguon:** docs/01-blueprint.md v[x] + docs/02-architecture.md · **Ngay:** [ngay]
**Moc "ban chay duoc dau tien":** lat 001-0NN

## Quy tac dung roadmap nay
- Cot **Cong chan** chua ✅ → khong `__SPECKIT_COMMAND_SPECIFY__` lat do.
- Cot **TT**: ⬜ chua · 🔄 dang · ✅ merge xong. Danh dau ngay trong bang.

| # | Lat | Demo duoc gi sau khi merge | Phu thuoc | Cong chan | Cham toi | Session | TT |
|---|---|---|---|---|---|---|---|
| 001 | `ten-lat` | [cau ta canh nguoi dung thay] | — | — | api, web | 1 | ⬜ |

## Sau moc — da dat ten, chua cat chi tiet
| # | Lat | Cong | Ghi chu |
|---|---|---|---|

## Ngoai pham vi
[Co trong blueprint nhung co y hoan/bo, moi dong kem ly do.]

## Cau hoi con treo
| # | Cau hoi | Chan lat | Ghi o dau |
|---|---|---|---|
| T1 | ... | 001 | constitution |
```

Cot `#` phai la **ba chu so**. Cot `Phu thuoc` chi chua so ba chu so hoac `—`.

## Khuon — docs/slices/NNN-slug.md

Moi file la mot prompt **dan thang duoc**, dai `prompt_min_lines`–`prompt_max_lines`
dong khong trong:

```markdown
<!-- Dan phan duoi vao: /speckit.specify -->

Muc tieu: [mot cau — lat nay lam duoc gi ma truoc do chua lam duoc]

Nguoi dung co the:
- [hanh dong quan sat duoc]
- [...]

Quy tac nghiep vu:
- [rang buoc phai dung, lay tu bat bien cua blueprint]

Hoan thanh khi:
- [dieu kien kiem duoc bang tay, khong can doc code]

Ngoai pham vi lat nay:
- [thu de nham la thuoc lat nay]

Tham chieu: contracts/[file].md ([phan nao]). Cau hoi treo T[n] trong roadmap.
```

## Rules

- **Khong nhac framework, thu vien, hay san pham CSDL trong prompt.** Prompt noi
  CAI GI. Cong cu la viec cua `__SPECKIT_COMMAND_PLAN__`. `check.sh` grep cho nay.
- **Prompt dai qua nghia la lat to qua.** Vuot `prompt_max_lines` thi can nhac cat
  doi, dung cat bot chu.
- **Cho blueprint khong noi → `[CAN QUYET]`**, va them mot dong vao bang "Cau hoi
  con treo". Tu dien la dat quyet dinh vao mieng nguoi khac.
- **Khong chay `__SPECKIT_COMMAND_SPECIFY__`.** Lenh nay sinh prompt, nguoi dung
  doc lai roi tu dan. Cho dung do la co y — mot prompt sai se de ra mot spec sai
  va mot nhanh sai.
- **Khong ghi de roadmap da co dau ✅.** Doc truoc, giu nguyen phan da merge, chi
  bo sung.
- Khong sinh code, khong tao `specs/`.
