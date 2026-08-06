---
name: manual-tecnico
description: >-
  Genera o actualiza el Manual Tecnico (.docx) de una HU/bug dentro de
  TemasCorporativos/anexos/{BUG|FEATURE}_{idAzure}_HU{###}_{descripcion}/ cada
  vez que se va a hacer un commit: si es frontend, captura pantallazos por paso
  con Playwright hasta la
  pantalla modificada; si es un servicio backend, arma ejemplos cURL con el
  token de token-qa y genera una coleccion Postman; siempre agrega explicacion
  y resultados de pruebas unitarias. Todo archivo de la tarea (docx, Postman,
  imagenes, .sql) sigue el mismo patron de nombre con el prefijo
  {proyecto}_{modulo}_{hu}_{titulo}. Un solo .docx por HU/bug, se actualiza en
  cada commit de esa tarea (no se crea uno nuevo por commit). Uso cuando el
  usuario pida hacer un commit de una HU/bug resuelta, o diga "genera el
  manual tecnico", "actualiza el manual", "/manual-tecnico".
---

# Manual Tecnico por HU/bug

Un `.docx` por HU/bug en `TemasCorporativos/anexos/`, que se **actualiza** (no se
recrea) en cada commit de esa misma tarea. Se dispara como parte del flujo de
commit (junto con [[git-corevida]]), no como acción separada que haya que pedir
aparte — cuando el usuario diga "haz el commit", genera/actualiza el manual
antes o junto con el commit y pregúntale si lo incluye en el mismo `git add`.

## 1. Identificadores (desde la rama, convención [[git-corevida]])

Rama `bugfix/<num>-<desc>` o `feature/<num>-HU<###>-<desc>` →
- `hu` = `HU<###>` o `BUG<num>` (el número de la rama).
- `proyecto` = `416` (fijo, proyecto interno Positiva Core, salvo que el usuario diga otro).
- `modulo` = 3 letras según el repo tocado (si toca varios, el que sea el foco principal
  de la HU/bug; pregunta si no es obvio):

| Repo | Módulo |
|---|---|
| `dev-ms-core-siniestros*` | `SIN` |
| `dev-ms-core-emisiones` | `EMI` |
| `dev-ms-core-integraciones` | `INT` |
| `dev-ms-core-reporteria` | `REP` |
| `dev-ms-core-core` | `COR` |
| `dev-web-front-core*` | `FRT` |

## 2. Carpeta por tarea (TODO el artefacto de la tarea vive ahí)

**Desde 2026-08-05**, cada HU/bug tiene su propia carpeta dentro de `anexos/`, nombrada
con este formato fijo (ya NO se deriva del nombre de la rama):

```
{BUG|FEATURE}_{idAzure}_HU{###}_{descripcion}
```

- `BUG` o `FEATURE`: literal, mayúsculas, según el tipo de tarea (mismo criterio que el
  prefijo de rama en [[git-corevida]]: `bugfix/` → `BUG`, `feature/` → `FEATURE`).
- `idAzure`: el ID numérico de Azure DevOps del work item que se está trabajando (el del
  bug si es un bug, el de la HU si es una HU).
- `HU{###}`: el número de la **Historia de Usuario a la que pertenece** la tarea — para
  una HU es su propio número; para un BUG es el número de la HU padre (trazabilidad,
  igual que ya aparece en los títulos reales de Azure DevOps, ej.
  `416_TRAN_SIN_HU860_...`). Si un bug no tiene HU padre clara, pregunta antes de omitir
  este segmento.
- `descripcion`: **máximo 3 palabras**, separadas por guion (`-`), **todo en MAYÚSCULAS**
  (igual que el resto del nombre de la carpeta), sin tildes ni caracteres especiales —
  resume la tarea, no repite el número.

```
anexos/
  {BUG|FEATURE}_{idAzure}_HU{###}_{descripcion}/
    Manual Tecnico - {proyecto}_{modulo}_{hu}_{titulo-corto}.docx
    {proyecto}_{modulo}_{hu}_{titulo-corto} - paso1.png
    {proyecto}_{modulo}_{hu}_{titulo-corto} - paso2.png
    {proyecto}_{modulo}_{hu}_{titulo-corto} - consulta-poliza.sql
    postman/
      {proyecto}_{modulo}_{hu}_{titulo-corto} - Coleccion.postman_collection.json
      {proyecto}_{modulo}_{hu}_{titulo-corto} - Environment DEV.postman_environment.json
      {proyecto}_{modulo}_{hu}_{titulo-corto} - Environment QA.postman_environment.json
      {proyecto}_{modulo}_{hu}_{titulo-corto} - Environment UAT.postman_environment.json
    ...
```

**Desde 2026-08-04, todo backend lleva su Postman dentro de una subcarpeta `postman/`**
propia de la carpeta de la tarea (ver §5.4) — no un `.postman_collection.json` suelto
junto al `.docx`.

Ejemplos:
- HU865 (Azure #427216, rama `feature/427216-cargue-pruebas-reconsideracion-reclamacion`)
  → carpeta `anexos/FEATURE_427216_HU865_CARGUE-PRUEBAS-RECONSIDERACION/`.
- Bug 466519 sobre informes de siniestros, hijo de HU860 (rama
  `bugfix/466519-intermediario-informes-siniestros`) → carpeta
  `anexos/BUG_466519_HU860_INTERMEDIARIO-INFORMES/`.

**Migración**: las carpetas ya creadas con el formato viejo (nombre de rama, ej.
`bugfix-466519-...` o `HU864/`) NO se renombran retroactivamente — el formato nuevo
aplica a toda carpeta que se cree de aquí en adelante.

**Patrón único de nombres**: todo archivo de la tarea (docx, colección Postman, imagen,
script `.sql`, o cualquier otro anexo) usa el mismo prefijo base
`{proyecto}_{modulo}_{hu}_{titulo-corto}` seguido de ` - <descriptor>.<ext>`. Así todos
los archivos de una misma HU/bug quedan agrupados alfabéticamente y es obvio a qué tarea
pertenece cada uno con solo mirar el nombre — no uses nombres genéricos como
`captura1.png` o `query.sql`.

```bash
mkdir -p "/Users/hernannieto/Documents/TemasCorporativos/anexos/<carpeta-de-la-tarea>"
```

## 3. ¿Existe ya el .docx de esta HU/bug?

```bash
ls "/Users/hernannieto/Documents/TemasCorporativos/anexos/<carpeta-de-la-tarea>/" 2>/dev/null
```

- **No existe** → crearlo con el scaffold (ver §4).
- **Existe** → abrirlo con `python-docx` y **actualizar** las secciones (no lo regeneres
  desde cero, no borres lo que ya haya llenado otra persona en Revisó/Aprobó).

## 3.1 Formato de las secciones (desde 2026-08-03, plantilla oficial HU635 fijada 2026-08-05)

Ver `plantilla-HU635-referencia.md` en esta misma carpeta para el detalle
exacto (tabla del header, columnas de cada tabla, numeración de subsecciones).

**Backend**: las secciones de un servicio backend siguen el formato de
**especificación de API tipo contrato**, igual al usado en el manual oficial
**HU635 "Enviar soporte de pago ISARL - GAIA"** (formato de referencia
obligatorio, `template-base.docx` y `scaffold_manual.py` ya lo generan así):

- **Encabezado de página** (tabla, 2 filas x 3 columnas, sin merge vertical):
  - Fila 1: `[logo POSITIVA]` | `PROCESO: {título}` | `Versión: 1 / Clasificación: Pública / Fecha: {fecha} / FORMATO`
  - Fila 2: `Aprobó:` | `Revisó:` | `Elaboró: {nombre}`
  - Esta info **vive solo en el header** — no se repite como tabla en el cuerpo del documento.
- **1. Información General del Servicio** — Nombre del Servicio, Proveedor, Consumidor, Método HTTP, URL Base {ENV}, Endpoint, Content-Type, Encoding.
- **2. Descripción del Servicio** — párrafo de prosa explicando qué hace y por qué.
- **3. Especificación del Request**:
  - 3.1 Headers Requeridos
  - 3.2 Estructura del Request Body (ejemplo JSON real)
  - 3.3 Validaciones de Entrada — **tabla** con columnas exactas `Campo | Tipo | Longitud | Obligatorio | Validaciones`
- **4. Especificación del Response** — numerado como subsecciones independientes, no como un solo bloque:
  - 4.1 Response Exitoso (HTTP 200)
  - 4.2 Response con Error de Negocio (HTTP 404, o el código real que aplique)
  - 4.3 Response con Error de Validación (HTTP 400)
  - (agregar 4.4, 4.5... si el servicio tiene más casos de error relevantes, ej. autenticación)
- **5. Códigos de Respuesta HTTP** — **tabla** con columnas exactas `Código | Descripción | Escenario`.
- **6. Catálogo de Mensajes Funcionales** (opcional, solo si el servicio maneja códigos propios tipo MB-xx; omitir si no aplica).
- **7. Arquitectura y Flujo** — decisiones de implementación (capas, clases, gateways, etc.), como contexto adicional después de la spec de API, no antes.

`scaffold_manual.py` ya crea el header (2x3 sin merge) y las tablas de 3.3/5
automáticamente — no reconstruir esto a mano en manuales nuevos.

**Frontend**: NO tiene contrato REST propio que documentar, así que
mantiene el formato anterior (evidencia paso a paso con Playwright, ver
[[evidencia-paso-a-paso]]). Si una HU/bug es mixta (`--tipo
frontend,backend`), la parte backend usa el formato spec de API y la parte
frontend usa evidencia paso a paso, ambas dentro del mismo `.docx`.

**Migración de manuales existentes**: los manuales ya generados con el
formato viejo (bitácora de desarrollo: I. Información General, II.
Arquitectura y flujo, III. Endpoints, IV. Ejemplos cURL, V. Postman, VI.
DTOs...) se reestructuran al formato nuevo la próxima vez que se retome esa
HU/bug (no hace falta migrarlos todos de una vez). Al migrar: conserva el
contenido real ya redactado (ejemplos cURL, DTOs, resultados de pruebas,
notas/discrepancias, ramas de git) reubicándolo bajo las secciones nuevas
que correspondan (el contrato Request/Response sale de los DTOs y ejemplos
cURL ya documentados; lo que no encaje en la spec de API — ramas de git,
bugs encontrados en pruebas, gaps pendientes — va en "Arquitectura y Flujo"
o en "Notas y discrepancias" al cierre). No borres información real para
migrar el formato.

## 4. Crear el esqueleto (solo si no existe)

```bash
BRANCH_DIR="/Users/hernannieto/Documents/TemasCorporativos/anexos/bugfix-466519-intermediario-informes-siniestros"
mkdir -p "$BRANCH_DIR"
python3 ~/.claude/skills/manual-tecnico/scaffold_manual.py \
  --proyecto 416 --modulo SIN --hu HU762 \
  --titulo "Integracion con SARLAFT" \
  --tipo "frontend,backend" \
  --repos "dev-ms-core-integraciones, dev-web-front-core" \
  --out "$BRANCH_DIR/Manual Tecnico - 416_SIN_HU762_Integracion SARLAFT.docx"
```

`--tipo` acepta `frontend`, `backend`, o `frontend,backend`; determina qué secciones
opcionales incluye (Endpoints/cURL/Postman/DTOs para backend, Evidencia de pantallas
para frontend). El script rehúsa sobrescribir si el archivo ya existe (usa §5 en ese caso).
Guarda también ahí, con el mismo prefijo base, la colección Postman, las capturas y
cualquier script `.sql` de evidencia (ver §5).

## 5. Llenar / actualizar secciones (python-docx)

Cada sección queda como un párrafo de título seguido de un párrafo `(pendiente)`.
Para reemplazar el placeholder de una sección:

```python
import docx
path = "/Users/hernannieto/Documents/TemasCorporativos/anexos/<carpeta-de-la-tarea>/Manual Tecnico - ....docx"
d = docx.Document(path)
paras = d.paragraphs
for i, p in enumerate(paras):
    if p.text.strip() == "3.2 Estructura del Request Body":
        # el siguiente parrafo es el placeholder "(pendiente)"
        target = paras[i + 1]
        target.text = ""
        # agrega contenido real (texto, o usa d.add_paragraph + move, o inserta
        # parrafos nuevos con target._p.addnext(...) si necesitas varios bloques)
        break
d.save(path)
```

Si una sección ya tiene contenido real (de un commit anterior de la misma HU), **no lo
borres** — agrega debajo un subtítulo tipo `Actualización {fecha} (commit {hash corto})`
con lo nuevo.

### Backend: cURL + evidencia + Postman

1. Token: `TOK="$(python3 ~/.claude/skills/token-qa/mint-token.py)"` (ver [[token-qa]],
   3 meses, se reutiliza — el usuario ya confirmó no acuñar uno aparte de 1 mes). Si el
   endpoint no es qa-v2 sino emisiones o el monolito local, agrega
   `--target emisiones` / `--target monolito` (mismo script, mismo secreto, distintos claims).
2. Ejecuta el/los curl reales (solo lectura o lo que sea seguro repetir) y captura el
   `HTTP %{http_code}` + body real como evidencia — igual que se hizo en el manual SARLAFT
   (no inventes response bodies, corre el curl).
3. Pega en la sección "Ejemplos cURL": el comando (con `$TOK` visible como placeholder,
   NO el JWT real en texto plano) + la evidencia de respuesta real.
4. Genera la colección Postman (JSON schema v2.1.0) con las mismas requests probadas,
   usando `{{token}}` como variable de colección (no el JWT literal). Ver §5.4 para la
   convención de ubicación y de ambientes (DEV/QA/UAT).

### 5.4 Convención Postman: subcarpeta `postman/` + un environment por ambiente

**Regla fija desde 2026-08-04, aplica a todo backend nuevo o modificado:** la colección
Postman de cada HU/bug vive en su propia subcarpeta `postman/` dentro de la carpeta de
la rama, y el ambiente (DEV/QA/UAT) se resuelve con **Postman Environments** — nunca con
URLs o datos hardcodeados dentro de la colección.

```
anexos/<carpeta-de-la-tarea>/postman/
  {proyecto}_{modulo}_{hu}_{titulo} - Coleccion.postman_collection.json
  {proyecto}_{modulo}_{hu}_{titulo} - Environment DEV.postman_environment.json
  {proyecto}_{modulo}_{hu}_{titulo} - Environment QA.postman_environment.json
  {proyecto}_{modulo}_{hu}_{titulo} - Environment UAT.postman_environment.json
```

**Colección**: todas las requests usan variables de ambiente, nunca literales:
- `{{baseUrl}}{{apiPrefix}}/<path>` para la URL (concatenados tal cual en el campo `raw`;
  Postman resuelve cada uno por separado). `apiPrefix` existe porque QA/UAT suelen tener
  un gateway con reescritura (`/api/<servicio>` → interno) que un microservicio local
  (`http://localhost:<puerto>`) no tiene — así la misma request sirve para ambos sin
  editar el path a mano.
- `{{token}}` vía `auth: bearer` a nivel de colección (nunca el JWT literal).
- Cualquier dato de prueba real (documento de tomador/asegurado, número de póliza, etc.)
  va como variable (`{{tomadorNumeroDocumento}}`, `{{numeroPoliza}}`, ...), NUNCA
  hardcodeado en el body — el valor real vive en el environment de cada ambiente, porque
  un documento que tiene datos en QA puede no tener nada en DEV/UAT (ya paso con el bug
  485590: hubo que buscar un tomador distinto por ambiente).

**Un `.postman_environment.json` por ambiente**, con al menos:
- `baseUrl`, `apiPrefix`, `token` (vacío o `secret`, nunca committeado con un JWT real).
- Los datos de prueba reales verificados para ESE ambiente (documento, póliza, etc.).
- Una variable `datoVerificadoEn` en texto libre: fecha + cómo se verificó (query SQL
  directa, curl real, etc.) + qué dio. Si un ambiente no se pudo verificar (ej. UAT sin
  acceso, o sin tiempo), pon `"PENDIENTE"` en los valores y explica el motivo en
  `datoVerificadoEn` — nunca inventes un dato de prueba ni un dominio de `baseUrl` que no
  hayas confirmado.
- Si un ambiente no tiene gateway propio desplegado (ej. DEV corriendo solo local por
  bootRun), `baseUrl` apunta al microservicio local (`http://localhost:<puerto>`) y
  `apiPrefix` queda vacío — documenta esa decisión en `datoVerificadoEn`.

Este patrón (colección + environments, sin datos ni URLs hardcodeadas) es la convención
a seguir en **todo desarrollo futuro** de la plataforma, no solo en este bug — así la
misma colección sirve sin editar para probar en cualquier ambiente con solo cambiar el
environment activo en Postman.

### Frontend: pantallazos paso a paso (Playwright)

Aplica el patrón de [[evidencia-paso-a-paso]] (mismo usado en [[radicar-sarlaft-qa]]):
recorre el flujo/wizard en QA con Playwright MCP hasta llegar a la pantalla donde está
el cambio de la HU/bug — no solo la pantalla final. Diferencia aquí: guarda las capturas
directamente en la carpeta de la rama con el prefijo base
(`{proyecto}_{modulo}_{hu}_{titulo} - pasoN.png`), no en el scratchpad (ya no hace falta
moverlas después). Insértalas con `document.add_picture(ruta, width=Inches(6))` en la
sección de Evidencia, una por paso con su leyenda ("Figura N. Paso X — ...").

### Pruebas unitarias

Corre el test suite relevante al cambio (no todo el repo si es evitable):
- Backend Maven: `./mvnw test -Dtest=<ClaseTest>` (o el módulo tocado).
- Backend Gradle: `./gradlew test --tests <ClaseTest>`.
- Front: `npm run test:unit` o el comando definido en el `package.json` del repo.

Pega el resumen real (passed/failed/skipped, no inventado) en "Resultados de pruebas
unitarias", con fecha y comando ejecutado. Si no hay tests para ese cambio, dilo
explícitamente en vez de omitir la sección.

### Scripts SQL u otros anexos

Si la evidencia incluye una consulta contra la BD GAIA (ver [[conectar-bd-gaia]]) u otro
artefacto (payload de ejemplo, log, etc.), guárdalo también en la carpeta de la rama con
el mismo prefijo base, ej. `{proyecto}_{modulo}_{hu}_{titulo} - consulta-poliza.sql` o
`{proyecto}_{modulo}_{hu}_{titulo} - payload-radicacion.json`, y referencia el archivo
desde la sección del docx que corresponda (no pegues el SQL completo dentro del docx si
ya queda como archivo aparte — cita el nombre del archivo).

## 6. Reglas

- **Una carpeta por rama** en `anexos/`, y dentro **un .docx por HU/bug** que vive todo
  el ciclo de la tarea; se actualiza, no se duplica.
- **Patrón de nombre único** para todo archivo de la carpeta (docx, Postman, imágenes,
  `.sql`, cualquier otro anexo): mismo prefijo base `{proyecto}_{modulo}_{hu}_{titulo}` +
  ` - <descriptor>.<ext>`. Nada de nombres genéricos sueltos.
- **Postman en subcarpeta `postman/` + un environment por ambiente** (DEV/QA/UAT), sin
  URLs ni datos de prueba hardcodeados en la colección — ver §5.4. Convención fija para
  todo backend desde 2026-08-04.
- **Nunca sobrescribas** contenido ya puesto por otra persona (tabla Revisó/Aprobó,
  observaciones manuales) — solo agrega o completa lo pendiente.
- El manual **no reemplaza** el commit — es un artefacto adicional. Sigue [[git-corevida]]
  para todo lo referente a git (commitear solo cuando se pida, sin atribución IA, etc.).
  Pregunta si la carpeta completa de la rama se agrega al mismo commit de la tarea.
- Evidencia = real. No redactes response bodies ni resultados de test que no ejecutaste.
