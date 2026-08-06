---
name: sgdea-uat
description: >-
  Endpoints y credenciales del gestor documental SGDEA en UAT (TRD y
  radicación de documentos): login Keycloak client_credentials + API
  ms-integration en Cloud Run (radicar_documento, buscar_documento_radicado,
  listado_maestro_dependencias, consulta_instrumentos, obtenerHijosPorNodo).
  Úsalo cuando el usuario pida probar radicación de documentos en SGDEA,
  consultar el árbol de series/subseries (TRD), o depurar el radicado del PDF
  de SARLAFT ("Sarlaft digital"), "/sgdea-uat".
---

# SGDEA UAT (TRD y radicación)

Gestor documental / TRD y radicación de documentos. Verificado 2026-07-22:
login OK + `listado_maestro_dependencias` → 200.

## Auth — Keycloak UAT (`client_credentials`)

- Token URL: `https://keycloak-uat.proyectos-3t.tech/realms/positiva/protocol/openid-connect/token`
- `client_id=integracion_sgdea` · `client_secret=<SGDEA_CLIENT_SECRET>`
- `username=<SGDEA_USERNAME>` · `password=<SGDEA_PASSWORD>` · `grant_type=client_credentials`
- Usar el `access_token` de la respuesta como `Bearer`.

## Base API (Cloud Run UAT)

`https://ms-integration-positiva-uat-711792583187.us-east1.run.app`

(PROD equivalente visto en la colección Postman: `https://gcpintepositiva.positivasgdea.com`)

## Endpoints

- `GET /consulta_instrumentos?codigo_oficina_productora=<cod>` — tipologías/instrumentos (TRD).
- `GET /listado_maestro_dependencias/` — fondos/oficinas productoras (read-only, ideal para smoke test).
- `GET /radicar_documento/obtenerHijosPorNodo/<nodoId>` — árbol TRD (series/subseries).
- `POST /radicar_documento/` — **radica documento** (multipart):
  `file`, `tipoRadicado`, `oficinaProductora`, `serieRadicacion` (uuid),
  `subserieRadicacion` (uuid), `tipoDocumentalRadicacion`, `fondoRadicacion`,
  remitente*, `anexos` (file), `descripcionAnexo` (JSON).
  Ejemplo de valores conocidos: serie `2bb2c23c-3fb9-4449-ae11-ff2ff6ab07cb`,
  subserie `8ab2e5f2-d23b-4352-8a12-9c08f1660214`, tipoDocumental `2907`,
  fondo `80`, oficina `23007`.
- `GET /buscar_documento_radicado/<idRadicado>` — consulta por id (ej. `ENT20250000888821`).

## Relación con SARLAFT

Este es el SGDEA donde el monolito adjunta el PDF **"Sarlaft digital"**
(Esc.1, `almacenarPdfEnSgdea` → `radicarSiniestroV2Sincrono`) — ver skill
`sarlaft-integraciones`. El radicado se guarda en
`reclamacion_siniestrada_radicados_sgdea` con `tipoRadicado="SARLAFT"`.

En el monolito/integraciones las vars son `SGDEA_URL` (base Cloud Run),
`SGDEA_AUTH_URL` (token Keycloak) y `SGDEA_CLIENT_SECRET` — ver skill
`levantar-servicio-local` para levantar esos servicios en local.

Fuente: colección Postman "TRD y Radicación".
