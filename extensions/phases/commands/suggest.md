---
description: "Noi bo cua extension phases. Hook user_prompt_submit tu goi lenh nay moi luot; nguoi dung va model KHONG can goi tay. Muon xem trang thai giai doan thi dung speckit.phases.status."
scripts:
  sh: scripts/bash/suggest.sh
---

# Hook goi y giai doan (noi bo)

Lenh nay ton tai vi khoi `events:` trong `extension.yml` can mot **ten command**
de tro toi — dispatcher `.specify/events.py` phan giai ten do ra file nay, roi
doc `scripts.sh` trong frontmatter de biet chay script nao.

Khong goi tay. Dung `/speckit-phases-status` neu muon xem trang thai.

## Steps

1. Chay `{SCRIPT}`.

Het. Script tu quyet dinh in goi y hay im lang, va luon thoat 0.

## Ghi chu ve hanh vi

- Script khong doc noi dung prompt. Giai doan duoc suy tu file trong repo, nen
  ket qua tat dinh.
- Khong co gi de noi thi khong in gi.
- Cung mot goi y khong lap lai moi luot — chi nhac lai khi doi noi dung, hoac
  sau `repeat_after` luot (mac dinh 10).
- Tat hoan toan bang `enabled: false` trong
  `.specify/extensions/phases/phases-config.yml`.
