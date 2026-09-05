# QM SDD bundle

Cai mot lan toan bo bo cong cu Spec-Driven Development cho team.

| Component | Nguon | Viec |
|---|---|---|
| `git` | ship san trong specify-cli | Feature branch + auto-commit hooks |
| `agent-context` | ship san trong specify-cli | Dong bo CLAUDE.md theo plan |
| `masterplan` | catalog `quangman` | Tang du an: blueprint, kien truc, ADR, hop dong, roadmap, cat lat |

Bundle nay **khong chua payload** cua extension nao — artifact chi co `bundle.yml`
va README nay. Tac dung duy nhat: ghim dung bo version da test cung nhau, va cai
ca ba bang mot lenh.

## Cai

`specify` co hai stack catalog tach roi, dang ky rieng, va **cu phap co khac nhau**:

```bash
specify extension catalog add \
  https://raw.githubusercontent.com/quangman2211/speckit-catalog/main/catalog.json \
  --name quangman --priority 1 --install-allowed

specify bundle catalog add \
  https://raw.githubusercontent.com/quangman2211/speckit-catalog/main/bundle-catalog.json \
  --id quangman --priority 1 --policy install-allowed

specify bundle install qm-sdd
specify integration upgrade claude    # noi hook `events:` — bundle install khong tu lam
```

Thieu dong dau: `Extension 'masterplan' not found in any catalog`.
Thieu dong hai: `Bundle 'qm-sdd' was not found in any configured catalog`.

Cai tu artifact da build san, khong can catalog bundle:

```bash
specify bundle install dist/qm-sdd-2.0.0.zip
specify integration upgrade claude
```

## Lich su ten

`retail-frontend` → `retail-sdd` → `qm-sdd`.

**Lan mot** bo extension `phases` — no lam viec o tang feature nen trung voi chinh
spec-kit — thay bang `masterplan` lam viec o tang tren spec-kit, cho khong co gi.
Luc do trong bundle khong con thu gi thuoc frontend nen bo chu do.

**Lan hai** bo not chu `retail`. `masterplan` khong dinh gi toi ban le, chay duoc
cho moi project; dat ten bundle theo mot project cu the lam dev o project khac
tuong no khong danh cho minh.

Ai da cai ban cu phai go tay — `bundle install` kiem idempotent theo **id**, doi
ten thanh id moi nen ban cu khong tu bien mat:

```bash
specify extension remove phases --force
specify bundle remove retail-sdd        # hoac retail-frontend
```
