---
description: "Bao lat ke tiep trong roadmap, kiem cong chan cua no da mo chua, doi chieu voi hop dong lien quan, roi in nguyen prompt de dan vao /speckit.specify. Dung moi lan bat dau mot lat moi, va truoc khi specify de biet co dang bi chan boi mot quyet dinh chua chot khong."
argument-hint: "[so lat, vd 003 — de trong = lat ke tiep chua merge]"
scripts:
  sh: scripts/bash/state.sh
---

# Lat ke tiep

## Tang

**Ban le giua hai tang.** Doc o tang du an (roadmap), giao viec xuong tang lat
(spec-kit).

## User Input

$ARGUMENTS

De trong = lat dau tien trong roadmap chua danh ✅.

## Steps

1. Chay `.specify/extensions/masterplan/scripts/bash/state.sh` lay `next_id`,
   `next_name`, `next_gate`, `next_prompt`, va so lat da merge.

2. Doc dong tuong ung trong `docs/05-roadmap.md`.

3. **Kiem cong chan** (cot `Cong chan`):
   - `—` → khong co cong, di tiep.
   - Co ma chua ✅ → **dung lai**. Noi ro cong do la cau hoi gi, tim no trong muc
     "Cau hoi con treo" cua roadmap hoac trong `docs/04-decisions/`, va noi ai
     phai tra loi. **Khong in prompt.**

4. **Kiem phu thuoc** (cot `Phu thuoc`): moi lat duoc nhac phai da ✅. Chua thi
   dung lai va noi ro thieu lat nao.

5. Qua het thi:
   - In nguyen noi dung `<slice_dir>/NNN-*.md` trong mot khoi code de nguoi dung
     copy.
   - Liet ke cac file trong `contracts/` ma prompt co tham chieu, va nhac chung
     phai duoc doc trong `__SPECKIT_COMMAND_PLAN__`.
   - Liet ke cac `[CAN QUYET]` con trong prompt — do la nhung cho
     `__SPECKIT_COMMAND_CLARIFY__` se hoi.

6. In lai vong chay cho lat nay:

   ```
   __SPECKIT_COMMAND_SPECIFY__   ← dan prompt o tren
   __SPECKIT_COMMAND_CLARIFY__   ← tra loi het, khong bo cau nao
   doc lai specs/NNN-*/spec.md, sua tay cho hieu lech
   __SPECKIT_COMMAND_PLAN__      ← nhac: tuan theo constitution va contracts/
   __SPECKIT_COMMAND_TASKS__     ← doc het; doc khong noi trong 5 phut = lat to qua
   __SPECKIT_COMMAND_IMPLEMENT__
   __SPECKIT_COMMAND_ANALYZE__   ← soi lech spec / plan / code
   test + review → merge → danh dau ✅ trong roadmap
   ```

7. Neu lat nay them bang hoac endpoint: nhac cap nhat `contracts/` va
   `contracts/CHANGELOG.md` **truoc khi** sang lat sau.

## Rules

- **Cong chan chua mo thi khong in prompt.** In ra la moi nguoi dan luon. Ca
  buoc kiem cong ton tai chinh vi cho nay.
- **Khong tu chay `__SPECKIT_COMMAND_SPECIFY__`.** Nguoi dung doc prompt roi tu dan.
- **Khong sua prompt luc in.** Thay prompt co van de thi noi ra va bao sua file
  goc bang `/speckit-masterplan-slice`, dung sua ngam luc in.
- Het lat → noi ro da het, va goi y cat tiep phan "Sau moc" cua roadmap.
