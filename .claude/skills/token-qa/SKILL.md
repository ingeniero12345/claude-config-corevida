---
name: token-qa
description: >-
  Acuña o reutiliza un JWT HS256 GAIA para tres entornos: corevida-qa-v2
  (gateway/integraciones/siniestros-v2, default), dev-ms-core-emisiones local,
  y dev-ms-core-core (monolito) local. Los tokens SIEMPRE se crean con 3
  meses de vigencia y se REUTILIZAN desde un cache por entorno mientras sigan
  válidos (solo se regeneran al vencer). Úsalo cuando necesites un
  Authorization Bearer para probar un endpoint, cuando un curl dé 401
  "Se requiere iniciar sesión", o cuando el usuario diga "dame un token",
  "acuña un token", "token para pruebas", "token de emisiones/monolito",
  "/token-qa".
---

# Token JWT GAIA (qa-v2 / emisiones / monolito local)

Genera/reutiliza el `Authorization: Bearer <JWT>` para probar endpoints en
tres entornos distintos. Los tres firman con la **misma clave** HS256, pero
exigen claims diferentes — el script `mint-token.py` sabe cuál usar según
`--target`.

## Reglas (confirmadas por el usuario)

1. **Vigencia: 3 meses (90 días) SIEMPRE**, en los tres entornos. No generar
   tokens de corta duración.
2. **Reutilizar, no regenerar.** Antes de acuñar uno nuevo, reusar el token
   cacheado (uno por `--target`) si le quedan más de 7 días de vigencia. Solo
   regenerar al vencer (o con `--force`).

## Targets

| `--target` | Entorno | Claims | Sujeto/usuario por defecto |
|---|---|---|---|
| `qa-v2` (default) | corevida-qa-v2: gateway, integraciones, siniestros-v2 | `sub`+`subject`+`type:access`+`user`+`validate:true`+`exp` | `usuario` / `1` |
| `emisiones` | `dev-ms-core-emisiones` en local | `sub`+`user`+`exp` (sin roles/validate) | `admin` / `1` |
| `monolito` | `dev-ms-core-core` en local (contra QA) | `subject`+`user`+`validate:true`+`exp` | `andresf.mendezv` / `100` (usuario real en `dbo.usuario`, QA) |

## Cómo obtener el token

Un solo comando por entorno (reusa el cache si es válido; si no, acuña uno de
3 meses y lo guarda):

```bash
# qa-v2 (default, compatible con el uso histórico sin --target)
TOK="$(python3 ~/.claude/skills/token-qa/mint-token.py)"

# emisiones local
TOK="$(python3 ~/.claude/skills/token-qa/mint-token.py --target emisiones)"

# monolito local (usuario/id reales de dbo.usuario si el default no aplica)
TOK="$(python3 ~/.claude/skills/token-qa/mint-token.py --target monolito --subject <usuario> --user <id>)"
```

- Ver token + fecha de vencimiento: agregar `--info`.
- Forzar uno nuevo de 3 meses: agregar `--force`.
- Override de sujeto/usuario para cualquier target: `--subject <x> --user <n>`.
- Cache por entorno en `~/.claude/skills/token-qa/token-cache*.txt`
  (`token-cache.txt` = qa-v2, histórico; `token-cache-emisiones.txt`,
  `token-cache-monolito.txt`).

## Usarlo en una prueba

```bash
TOK="$(python3 ~/.claude/skills/token-qa/mint-token.py)"
curl -s -w "\nHTTP %{http_code}\n" -X POST \
  "https://corevida-qa-v2.linktic.com/api/integraciones/api/v1/isarl/radicacion" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOK" \
  --data @payload.json
```

## Detalles técnicos

- **Firma:** HS256 con clave = `base64decode($GAIA_JWT_SECRET)` — el mismo `JWT_SECRET`
  se repite en los `.env` de integraciones, emisiones y el monolito (verificado
  contra tokens reales de cada uno). El script lee el valor real desde la env
  var `GAIA_JWT_SECRET` (nunca lo hardcodees en `mint-token.py`).
- **qa-v2** (`GaiaJwtValidator`): requiere `sub`/`subject` + `type` + `user` +
  `iat` + `exp` vigente + **`validate: true`** (sin este último = 401 aunque la
  firma sea válida). Rutas libres (sin token): swagger / api-docs / actuator.
- **emisiones** (`JwtSecurityFilter`/`JwtUtil`, jjwt 0.9.1): solo exige `sub`
  (username) + `user` (id numérico) + `exp` no vencido — NO exige roles ni
  `validate`. Rutas libres: `/swagger-ui/**`, `/v3/api-docs/**`, `/webjars/**`,
  `/actuator/health`, `/api/v1/test/**`.
- **monolito** (`SecurityFilter`+`JwtService`): exige `subject` = usuario
  **existente** en `dbo.usuario` + `user` = su id + `validate:true` + `exp`.
  El default `andresf.mendezv`/`100` es un usuario real en QA — si no aplica
  a tu caso, pasa `--subject`/`--user` con uno válido.

## Notas

- Si aun con token válido da 401, el secreto pudo cambiar: verifica el
  `JWT_SECRET` en el `.env` del repo correspondiente y actualiza la env var
  `GAIA_JWT_SECRET` (aplica a los tres targets, comparten secreto).
- Memorias relacionadas: `jwt-token-qa-v2-integraciones`, `emisiones-jwt-token-401`,
  `run-monolito-local`, `reclamaciones-consulta-qa-v2`.

## Endpoint de ejemplo: consulta de reclamaciones (HU862, siniestros-v2)

`ConsultaReclamacionesController` (repo `backend/dev-ms-core-siniestros-v2`).

- **URL QA:** `POST https://corevida-qa-v2.linktic.com/api/siniestrosv2/api/v1/reclamaciones/consulta`
  (el ingress helm reescribe `/api/siniestrosv2(/|$)(.*)` → `/$2`; no hay context-path interno).
- **Claims requeridos además de los de arriba:** `exp` vigente + **`validate: true`**
  (booleano) + `sub`/`subject` + `user`. Sin `validate:true` = 401 aunque la
  firma sea válida.
- **Body** (`ConsultaReclamacionesData`): enviar UNA sola llave según `tipoLlaveConsulta`:
  - `POLIZA` → `numeroPoliza`
  - `TOMADOR` → `tomador:{tipoDocumento,numeroDocumento}`
  - `ASEGURADO` → `asegurado:{tipoDocumento,numeroDocumento}`
  - Comunes: `canalOrigen` (default WEB), `traceId`, `paginacion:{pagina,tamanoPagina}`.
- **Respuestas:** 200 EXITOSO/SIN_RECLAMACIONES · 400 LLAVE_INVALIDA · 401 sin token · 5xx ERROR.
- Probado OK: póliza `SA3510002861` → 200 EXITOSO, 1 reclamación estado 11031 LIQUIDADO, ramo SALUD (solo existe en QA, ver skill `conectar-bd-gaia`).
