# Retail SDD bundle

Cai mot lan toan bo bo cong cu SDD cho team.

| Component | Nguon | Viec |
|---|---|---|
| `git` | ship san trong specify-cli | Feature branch + auto-commit hooks |
| `agent-context` | ship san trong specify-cli | Dong bo CLAUDE.md theo plan |
| `blueprint` | catalog `quangman` | Tang du an: blueprint, kien truc, ADR, hop dong, roadmap, cat lat |

Truoc doi ten: bundle nay ten `retail-frontend` va chua extension `phases`. Ca
hai da bi bo — `phases` lam viec o tang feature, trung voi chinh spec-kit; ban
thay the `blueprint` lam viec o tang tren spec-kit, cho khong co gi.

## Yeu cau truoc khi cai

Extension `masterplan` khong ship kem specify-cli, nen catalog phai duoc dang ky
truoc, neu khong install se bao `not found in any catalog`:

```bash
specify extension catalog add <catalog-url> --name quangman --priority 1 --install-allowed
specify bundle install retail-sdd
specify integration upgrade claude    # noi hook `events:` — bundle install khong lam viec nay
```

## Cai tu artifact da build

```bash
specify bundle install dist/retail-sdd-2.0.0.zip
specify integration upgrade claude
```
