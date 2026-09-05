# Frontend Workflow (spec-kit extension)

Them hai cong kiem soat vao vong doi Spec-Driven Development cho phan frontend.

| Command | Hook | Viec |
|---|---|---|
| `speckit.frontend.component` | `after_plan` (optional) | Sinh component contract tu `plan.md` |
| `speckit.frontend.a11y` | `before_implement` (optional) | Cong WCAG 2.2 AA tren spec/plan |

## Cai dat

```bash
specify extension add frontend
```

## Cau hinh

```bash
cp .specify/extensions/frontend/config-template.yml \
   .specify/extensions/frontend/frontend-config.yml
```

| Key | Mac dinh | Y nghia |
|---|---|---|
| `wcag_level` | `AA` | Muc WCAG cho a11y gate |
| `token_source` | `design-tokens.json` | Nguon design token duy nhat |
| `component_dir` | `contracts/components` | Noi dat component contract |
