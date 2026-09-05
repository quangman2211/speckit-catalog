# Retail Frontend bundle

Cai mot lan toan bo bo cong cu SDD cho team frontend Retail-OPS.

| Component | Nguon | Viec |
|---|---|---|
| `git` | ship san trong specify-cli | Feature branch + auto-commit hooks |
| `agent-context` | ship san trong specify-cli | Dong bo CLAUDE.md theo plan |
| `frontend` | catalog `quangman` | Component contract + a11y gate |

## Yeu cau truoc khi cai

Extension `frontend` khong ship kem specify-cli, nen catalog phai duoc dang ky
truoc, neu khong install se bao `not found in any catalog`:

```bash
specify extension catalog add <catalog-url> --name quangman --priority 1 --install-allowed
specify bundle install retail-frontend
```

## Cai tu artifact da build

```bash
specify bundle install dist/retail-frontend-1.0.0.zip
```
