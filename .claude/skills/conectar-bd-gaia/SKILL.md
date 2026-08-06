---
name: conectar-bd-gaia
description: >-
  Conectarse a la BD compartida GAIA (Postgres `ebdb`, esquema `dbo`) en
  DEV/QA/UAT desde local vía túnel AWS SSM: puertos de túnel, credenciales
  `generico.<env>` y notas de permisos/pruebas. Úsalo cuando falte conectar un
  microservicio o un cliente (psycopg2) a la BD de un ambiente, cuando un
  bootRun necesite DB_URL/DB_USER/DB_PASSWORD, o cuando el usuario diga
  "conéctate a la BD de QA/DEV/UAT", "abre el túnel a la base", "/conectar-bd-gaia".
---

# Conectar a la BD GAIA (DEV/QA/UAT)

Base compartida GAIA: Postgres, base `ebdb`, esquema `dbo`. Todo local pasa por
**túnel AWS SSM** — el puerto lo abre el usuario, nunca lo abras tú sin pedirlo.

## 1. Verificar qué túnel está arriba

```bash
lsof -nP -iTCP -sTCP:LISTEN | grep 54
```

## 2. Mapeo de puertos → ambiente (histórico, verifica siempre con el paso 1)

| Puerto local | Ambiente | Usuario     | Contraseña          | Notas |
|---|---|---|---|---|
| `5437` | DEV | `generico.dev` | `<DB_PASSWORD_DEV>` | cluster DEV, IP 10.221.11.170 |
| `5438` | QA  | `generico.qa`  | `<DB_PASSWORD_QA>` | cluster QA, IP 10.222.11.24 |
| `5439` | UAT | `generico.uat` | `<DB_PASSWORD_UAT>` | **solo lectura** (SELECT); NO puede CREATE/REPLACE en `dbo` |

> ⚠️ Un comentario viejo en el repo rotula 5438 como "uat_new-core" — está
> desactualizado. Confía en qué usuario autentica en ese puerto, no en el
> comentario del código.
> ⚠️ El túnel de UAT puede salir en un puerto distinto a 5439 — siempre
> verifica con el `lsof` del paso 1 antes de asumir el mapeo de la tabla.

Cadena de conexión siempre con `sslmode=require`:
```
jdbc:postgresql://127.0.0.1:<puerto>/ebdb?currentSchema=dbo&sslmode=require
```

## 3. Consultar directo (sin `psql`, no está instalado)

Usar `psycopg2` en python3 (sí está instalado):
```python
import psycopg2
conn = psycopg2.connect(host="127.0.0.1", port=<puerto>, dbname="ebdb",
                         user="generico.<env>", password="<pass>", sslmode="require")
```

## 4. Datos de prueba conocidos

- Póliza `SA3510002861` → solo existe en **QA** (16 filas en `v_353_informes_siniestros`).
- Póliza `SA3510002778` → existe en **UAT**.

## 5. UAT es solo lectura

`generico.uat` no puede `CREATE`/`REPLACE` en `dbo` (permission denied for
schema dbo). Para validar una vista nueva sin crearla: embeber su `SELECT`
como subconsulta inline y comparar con `EXCEPT`/`COUNT` contra la vista
productiva.

## 6. Levantar un microservicio contra un ambiente (ejemplo QA)

```bash
SPRING_PROFILES_ACTIVE=local SERVER_PORT=8087 \
DB_URL='jdbc:postgresql://127.0.0.1:5438/ebdb?currentSchema=dbo&sslmode=require' \
DB_USER='generico.qa' DB_PASSWORD='<DB_PASSWORD_QA>' JWT_SECRET='<GAIA_JWT_SECRET>' \
./gradlew :app-service:bootRun
```

El perfil `local` lee `DB_URL/DB_USER/DB_PASSWORD`; el perfil `dev` usa
`RDS_HOSTNAME/RDS_PORT/RDS_USERNAME_APP/RDS_PASSWORD`. Para llamar endpoints
protegidos hace falta además el JWT — ver skill `token-qa`.

## Relacionado

- Para levantar el servicio completo (env vars, RabbitMQ, Redis) ver skill
  `levantar-servicio-local`.
- Para el JWT de pruebas ver skill `token-qa`.
