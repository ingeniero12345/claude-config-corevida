# Checklist de secretos a rellenar

Este repo NO contiene valores reales. Después de clonarlo, rellena esto (en tu
máquina, nunca en el repo) usando tu backup privado, tu gestor de contraseñas,
AWS Secrets Manager, o pidiéndoselos a tu equipo.

| Placeholder / mecanismo | Dónde aparece | Qué es |
|---|---|---|
| `<DB_PASSWORD_DEV>` | `skills/conectar-bd-gaia/SKILL.md` | Password de `generico.dev` (BD GAIA, túnel 5437) |
| `<DB_PASSWORD_QA>` | `skills/conectar-bd-gaia/SKILL.md`, `skills/levantar-servicio-local/SKILL.md`, `skills/radicar-sarlaft-qa/SKILL.md` | Password de `generico.qa` (BD GAIA, túnel 5438) |
| `<DB_PASSWORD_UAT>` | `skills/conectar-bd-gaia/SKILL.md` | Password de `generico.uat` (BD GAIA, túnel 5439, solo lectura) |
| env var `GAIA_JWT_SECRET` | `skills/token-qa/mint-token.py`, `skills/token-qa/SKILL.md`, `skills/levantar-servicio-local/SKILL.md` | Secreto de firma HS256 (mismo en integraciones/emisiones/monolito). Setéala con `export GAIA_JWT_SECRET='...'` antes de correr `mint-token.py`. |
| `<SGDEA_CLIENT_SECRET>` | `skills/sgdea-uat/SKILL.md` | `client_secret` de Keycloak UAT para SGDEA |
| `<SGDEA_USERNAME>` / `<SGDEA_PASSWORD>` | `skills/sgdea-uat/SKILL.md` | Usuario/password `client_credentials` de SGDEA UAT |
| `<SARLAFT_CRM_USER>` / `<SARLAFT_CRM_PASSWORD>` | `skills/sarlaft-integraciones/SKILL.md` | Login del pool Cognito CRM (Red5G) |
| `<SARLAFT_CUSTOMER_USER>` / `<SARLAFT_CUSTOMER_PASSWORD>` | `skills/sarlaft-integraciones/SKILL.md` | Login del pool Cognito Correo/Customer (Red5G) |
| `<TU_SHEET_ID>` | `skills/registrar-tarea/apps-script.gs` | ID de tu Google Sheet de "actividades" |
| `<UN_SECRETO_TUYO>` | `skills/registrar-tarea/apps-script.gs` | Secreto propio para autenticar tu Web App (invéntalo tú, no es un valor a recuperar) |
| — (archivo excluido) | `skills/registrar-tarea/webapp-url.txt` | Recréalo tras desplegar tu Web App: línea 1 = URL `/exec`, línea 2 = tu secreto. No va en git. |
| — (archivos excluidos) | `skills/token-qa/token-cache*.txt` | Se regeneran solos la primera vez que corras `mint-token.py` (necesitas `GAIA_JWT_SECRET` seteada). |

## Nota sobre `settings.json`

Las líneas de la allow-list que tenían passwords embebidas (comandos exactos de
`export DB_PASSWORD=...`) se eliminaron directamente — no tiene sentido
mantenerlas como plantilla porque Claude Code las compara literal. Si necesitas
autorizar esos comandos otra vez en tu máquina, Claude te pedirá permiso la
primera vez y puedes aprobarlos ahí (con tus valores reales, quedan en
`~/.claude/settings.json` local, que no se versiona).
