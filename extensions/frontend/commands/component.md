---
description: "Sinh component contract tu plan.md cua feature hien tai"
---

# Frontend Component Contract

Doc `plan.md` cua feature dang mo va sinh ra hop dong component truoc khi viet code.

## User Input

$ARGUMENTS

## Steps

1. Xac dinh feature dang lam trong `specs/`. Neu chua co `plan.md`, dung lai va
   yeu cau nguoi dung chay `__SPECKIT_COMMAND_PLAN__` truoc.
2. Doc cau hinh tai `.specify/extensions/frontend/frontend-config.yml`
   (`component_dir`, `token_source`, `wcag_level`).
3. Voi moi man hinh / thanh phan UI mo ta trong plan, sinh mot file contract
   trong `<component_dir>/` gom:
   - **Props**: ten, kieu, bat buoc hay khong, gia tri mac dinh
   - **State**: state cuc bo va state chia se
   - **Events**: cac callback ra ngoai
   - **A11y**: role, aria-label, thu tu focus, phim tat
   - **Tokens**: token mau/khoang cach lay tu `<token_source>`
4. Khong viet code implementation. Contract la mo ta, khong phai JSX.
5. Liet ke cac contract da tao va bao buoc tiep theo la
   `__SPECKIT_COMMAND_TASKS__`.

## Rules

- Moi prop phai truy nguyen ve mot requirement trong `spec.md`. Prop khong truy
  nguyen duoc thi ghi vao muc `Unmapped` de nguoi dung quyet dinh.
- Khong tu sang tao mau hoac khoang cach ngoai `<token_source>`.
