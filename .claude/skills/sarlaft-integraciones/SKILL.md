---
name: sarlaft-integraciones
description: >-
  Conexión e integración con SARLAFT (Red5G/AGS) para validación de riesgos
  LA/FT: property keys `sarlaff.*` (typo con doble f), los DOS user pools de
  Cognito distintos (CRM vs Correo/Customer) y cuándo usar cada uno, endpoints
  UAT del API Gateway, flujo token→FCC→callback, y el flujo de diligenciamiento
  externo (GES-SIN, HU 405969) con sus reintentos. Úsalo cuando el usuario pida
  probar/depurar SARLAFT/FCC, dé 401 en validate-document o external_customer,
  o pregunte por el paso 6 del wizard (InformacionSarlaft.vue),
  "/sarlaft-integraciones".
---

# SARLAFT / FCC (Red5G) — conexión e integración

⚠️ Las property keys usan **`sarlaff`** (con doble f, typo real en el código),
NO `sarlaft`.

**Implementación de referencia:** `dev-ms-core-core` →
`co.com.spn.cun3.db.service.sarlaft.SarlaftServiceImpl` y el orquestador
`SarlaftIntegrationServiceImpl`. Las mismas 5 props están replicadas en
emisiones, siniestros y reportería.

## ⚠️ Regla clave: DOS pools de Cognito, no confundir

Cada endpoint valida contra un **User Pool distinto** — usar el token
equivocado da **401 Unauthorized**, aunque el token sea válido.

| Login | Pool Cognito | URL | Credenciales |
|---|---|---|---|
| **CRM** | `us-east-1_4ST1DDrOD` | `POST https://ro43pbi9ca.execute-api.us-east-1.amazonaws.com/login/oauth/authenticate/v1` | `<SARLAFT_CRM_USER>` / `<SARLAFT_CRM_PASSWORD>` |
| **Correo/Customer** | `us-east-1_Qm7vpkeJa` | `POST https://r1v3k5bn1m.execute-api.us-east-1.amazonaws.com/customer_login` | `<SARLAFT_CUSTOMER_USER>` / `<SARLAFT_CUSTOMER_PASSWORD>` |

Ambos devuelven `data.{AccessToken, Idtoken, RefreshToken, ExpiresIn:3600}`.

## Property keys → env var (application.properties)

- `sarlaff.red5g.url.token`    = `${SARLAFF_URL_TOKEN}`
- `sarlaff.red5g.user.token`   = `${SARLAFF_USER_TOKEN}`
- `sarlaff.red5g.passwd.token` = `${SARLAFF_PASSWD_TOKEN}`
- `sarlaff.red5g.op.callback`  = `${SARLAFF_URL_CALLBACK}`
- `sarlaff.red5g.op.fcc`       = `${SARLAFF_URL_FCC}`

En `.env` local (`dev-ms-core-integraciones/.env`) el USER/PASSWD quedan
vacíos — las credenciales reales vienen de AWS Secrets Manager.

## Endpoints (API Gateway `7ifsjev272`, mismo host, authorizers distintos)

- **validate-document** (consulta SARLAFT/FCC) → requiere **token CRM**
  `GET https://7ifsjev272.execute-api.us-east-1.amazonaws.com/fcc/validate-document/{tipoDoc}/{numeroDoc}?form_type=FCC-STA`
  - `form_type`: `FCC-STA` (curl de prueba) o `FCC-SIM` (lo que manda el backend real, `validarFcc(...,"FCC-SIM")`).
  - respuesta: `{"vigency":false,"gestion_forms":[],"gestion":true}`
- **external_customer** (crear gestión) → requiere **token Correo**
  `POST https://7ifsjev272.execute-api.us-east-1.amazonaws.com/management/gestions/external_customer`
  - body: `gestion_type:"GES-SIN"`, `product`, `policy_number`, `claim_incident_number`, `apply_simplified`, `continue_flow`, `beneficiaries[]`.
  - respuesta `201`: `{"gestion_id":836,"gestion_form_ids":[...]}`.
  - ⚠️ **Crea una gestión real en cada llamada** (efecto secundario), NO es idempotente — no la llames repetidamente en pruebas.
- **callback**: `POST https://7ifsjev272.execute-api.us-east-1.amazonaws.com/sarlaft/callback/v1` con Bearer token.

## Flujo `validarFcc` (backend)

1. `POST url.token` con `{username, password}` → token en `$.data['Idtoken']`.
2. `GET url.fcc` con `Authorization: Bearer <token>`, path vars
   `documentType`+`documentNumber`, query `form_type`.
3. Respuesta (`ResponseSarlaftDTO`): `data.status_code`/`data.status`,
   `data.vigency`/`data.vigente` (bool), `data.file` (PDF base64).
4. `sendCallback`: `POST url.callback` con Bearer token (`RootCallbackSarlaft`).

`SarlaftIntegrationServiceImpl` mapea el resultado a `EstadoSarlaftEnum` y, si
vigente + estado que almacena PDF, radica el PDF en SGDEA vía
`GestorDocumentalService.radicarSiniestroV2Sincrono(..., "/sarlaft")` — ver
skill `sgdea-uat`. Persiste en `sarlaft_consulta` (clave: reclamacion_id +
numero_documento + tipo_documento).

## Diligenciamiento externo (GES-SIN, HU 405969)

Integración separada para disparar el correo de diligenciamiento cuando el
reclamante NO tiene FCC. Vive en `dev-ms-core-integraciones`
(`EnvioDiligenciamientoSarlaftServiceImpl` + `SarlaftController POST
/api/sarlaft/enviar-diligenciamiento`). Usa el login **Correo**, luego
`POST management/gestions/external_customer` (ver arriba). Env vars:
`SARLAFF_CUSTOMER_LOGIN_URL/_USER/_PASSWD`, `SARLAFF_GESTION_EXTERNAL_URL`.
PROD usa otros paths (`0fyl9sz8k3` login, `b1mhaxbr51` gestión).

**Front:** paso 6 del wizard `ReclamacionStepperV3` (`InformacionSarlaft.vue`)
— botón manual "Enviar diligenciamiento SARLAFT", habilitado solo si NO
existe FCC. Ver skill `radicar-sarlaft-qa` para llegar ahí en el navegador.

**Reintento (`DiligenciamientoRetryService`, piloto):** registro EN MEMORIA
(no sobrevive reinicios), `@Scheduled` cada `sarlaff.diligenciamiento.retry.interval`
(default **P7D**). Solo reenvía mientras el trámite esté en estado
**RESERVADO = 11009** (`dbo.tipos_constantes`); si anulado(11019)/declinado(11011)
se detiene. Si Red5G está caído al enviar, responde 200 "encolada" y un 2º
scheduled (`.retry.error-interval`, default PT5M) reintenta hasta que el
servicio vuelva.

## Ambiente

Solo **UAT** tiene URLs reales configuradas en el repo (`helm/values/uat.yaml`)
— son las mismas URLs de la tabla de arriba. Para levantar el monolito/
integraciones en local contra estos endpoints, ver skill `levantar-servicio-local`.
