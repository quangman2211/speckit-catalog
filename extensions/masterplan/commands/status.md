---
description: "Bao du an dang o tang blueprint hay tang lat, artifact nao da co (blueprint, kien truc, ADR, hop dong, roadmap, prompt), bao nhieu lat da merge, va lenh nen chay tiep. Lenh nay cung la hook tu dong goi y trong luc lam viec."
argument-hint: ""
scripts:
  sh: scripts/bash/suggest.sh
---

# Trang thai tang du an

Goi tay thi bao cao day du. Chay tu dong (hook `user_prompt_submit`) thi chi bom
mot goi y ngan, va im lang khi khong co gi de noi.

## Steps

1. Chay `.specify/extensions/masterplan/scripts/bash/state.sh`.

2. Bao cao thanh bang:

   | Artifact | Duong dan | Co chua |
   |---|---|---|
   | Blueprint | docs/01-blueprint.md | |
   | Kien truc | docs/02-architecture.md | |
   | ADR | docs/04-decisions/ | n file |
   | Hop dong | contracts/ | n file |
   | Roadmap | docs/05-roadmap.md | |
   | Prompt lat | docs/slices/ | n file |
   | Constitution | .specify/memory/constitution.md | |

3. Neu dang o **tang lat**: bao `done/total` lat, va lat ke tiep kem cong chan.

4. Noi mot lenh nen chay tiep — lay tu phan tu dau tien cua mang `missing`:

   | Thieu | Lenh |
   |---|---|
   | blueprint | `/speckit-masterplan-architect` |
   | architecture | `/speckit-masterplan-design` |
   | adr | `/speckit-masterplan-decide` |
   | contracts | `/speckit-masterplan-contracts` |
   | roadmap, prompts | `/speckit-masterplan-slice` |
   | constitution | `__SPECKIT_COMMAND_CONSTITUTION__` |
   | next | `/speckit-masterplan-next` |

## Rules

- **Chi doc, khong ghi.** Lenh nay khong sua file nao.
- **Noi mot lenh tiep theo, khong noi ba.** Danh sach viec phai lam khong giup ai
  bat dau.
- Ngoai spec-kit project (`altitude: none`) thi noi ro day khong phai spec-kit
  project, dung bao cao bang rong.
