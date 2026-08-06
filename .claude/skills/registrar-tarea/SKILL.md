---
name: registrar-tarea
description: >-
  Registra una fila (fecha + actividad + número de ticket + descripción) en la
  hoja de Google "actividades" apenas se identifica una HU o BUG en la sesión.
  Úsalo cuando el usuario mencione un número de HU/BUG (aunque sea de pasada),
  al terminar de trabajar en una, o cuando el usuario diga "registra la tarea",
  "apunta esto en la hoja", "/registrar-tarea".
---

# Registrar tarea en la hoja de actividades

> **NUNCA pidas autorización ni confirmación para añadir tareas a la hoja.**
> El usuario ya autorizó de forma permanente registrar filas directamente.
> Registra con los mejores valores que tengas y, después, informa qué fila quedó.

> **Disparo automático:** el hook `UserPromptSubmit` en
> `~/.claude/scripts/hu-mention-detector.sh` detecta menciones de HU/BUG en
> cada mensaje del usuario y añade contexto pidiendo invocar este skill. Es
> UNA fila por HU/BUG POR DÍA (deduplicada en
> `~/.claude/state/hu-mentions-<YYYY-MM-DD>.txt`, sin importar la sesión),
> generada al MENCIONARLA por primera vez ese día — ya no se registra otra vez
> al cerrarla, ni se repite si se vuelve a mencionar en otra sesión el mismo día.

Agrega una fila a la hoja de Google del usuario mediante una Web App de Apps
Script (POST). NO uses el conector de Google Drive para esto: es de solo lectura
y no puede agregar filas.

Hoja destino (columnas): `A=fecha`, `B=actividad`, `C=(vacía)`, `D=numero`, `E=descripcion`.

## Requisito previo (una sola vez)

Debe existir `~/.claude/skills/registrar-tarea/webapp-url.txt` con:

- Línea 1: la URL de la Web App (termina en `/exec`).
- Línea 2: el SECRET (el mismo que pusiste en `apps-script.gs`).

Si el archivo NO existe, NO inventes nada: dile al usuario que primero despliegue
`apps-script.gs` siguiendo sus instrucciones y guarde la URL + secret en ese
archivo. No continúes hasta que exista.

## Pasos

1. Lee `~/.claude/skills/registrar-tarea/webapp-url.txt`. Toma URL (línea 1) y
   SECRET (línea 2).

2. Arma los campos a partir del trabajo realizado:
   - `fecha`: la fecha de HOY en formato `YYYY-MM-DD` (usa la fecha actual del
     contexto de la sesión, campo currentDate). Si el usuario indica otra fecha,
     respétala.
   - `numero`: el número del ticket (HU o BUG), p.ej. `466519`. Si no hay número
     claro, déjalo vacío.
   - **Nombre completo obligatorio (desde 2026-08-06):** antes de registrar,
     consigue el título completo del work item. **OJO:** el número que
     menciona el usuario (ej. "HU741") es el número de NEGOCIO, no el ID real
     de Azure DevOps (los IDs son de 6 cifras) — `--ids <numero>` casi siempre
     falla (`TF401232: Work item ... does not exist`). Usa en su lugar WIQL
     por título:
     ```bash
     ~/.claude/skills/azure-devops-hu/query.sh \
       "SELECT [System.Id],[System.Title],[System.WorkItemType],[System.State] FROM WorkItems WHERE [System.Title] CONTAINS 'HU<numero>' ORDER BY [System.ChangedDate] DESC"
     ```
     - Puede devolver VARIOS work items para la misma HU (historia + varios
       bugs/tasks asociados a lo largo del tiempo). Elige el más relevante al
       contexto: si el usuario dice "corregimos/arreglamos un bug", prioriza el
       de tipo `Bug` más reciente (mayor `ChangedDate`); si dice "la historia" o
       no da pista, usa el `User Story` más reciente. Ante duda real, pregunta.
     - Usa el título tal cual (no lo acortes ni traduzcas) en `actividad` y
       `descripcion`, y el **ID de Azure** (no el número de negocio) en `numero`.
     - Si la consulta falla o no devuelve nada, registra igual con los datos
       disponibles pero dilo explícitamente al usuario al confirmar la fila —
       no te quedes sin registrar por esto.
   - `actividad`: `hu <numero> <titulo completo>` o `bug <numero> <titulo completo>`,
     p.ej. `hu 741 416_SALUD_SIN_HU741_Ajuste validación de pólizas`.
   - `descripcion`: el mismo título completo del ticket (o más detalle si el
     usuario lo dio). No inventes títulos: si no se pudo obtener, déjala vacía.
   - NO pidas confirmación: registra directamente con los mejores valores que
     tengas del trabajo hecho.

3. Haz el POST (explica el comando antes de correrlo, como pide CLAUDE.md):

   ```bash
   URL="$(sed -n '1p' ~/.claude/skills/registrar-tarea/webapp-url.txt)"
   SECRET="$(sed -n '2p' ~/.claude/skills/registrar-tarea/webapp-url.txt)"
   curl -sL "$URL" \
     -H 'Content-Type: application/json' \
     -d "$(cat <<JSON
   {"secret":"$SECRET","fecha":"2026-07-22","actividad":"bug 466519, revision vista","numero":"466519","descripcion":""}
   JSON
   )"
   ```

   (Reemplaza los valores por los reales. `curl -L` es necesario porque Apps
   Script responde con un redirect a googleusercontent.com. **NO uses `-X POST`**:
   forzaría a curl a reenviar POST al redirect de Google, que solo acepta GET y
   devuelve HTTP 405. Con `-d` sin `-X POST`, curl cambia a GET en el redirect y
   la Web App procesa bien; el `-d` ya hace que la primera petición sea POST.)

4. La respuesta es JSON. `{"ok":true,"fila":N}` = fila agregada en la posición N.
   Si `ok:false`, muestra el `error` al usuario (secret inválido, pestaña no
   encontrada, etc.) y NO reintentes a ciegas.

5. Confirma al usuario qué fila se registró (fecha + actividad).

## Corregir una fila ya registrada

`apps-script.gs` soporta `"accion":"actualizar"` (agregado 2026-08-06) para
corregir una fila existente sin duplicarla — necesario porque la hoja se
reordena por fecha en cada alta y el número de fila cambia.

```bash
URL="$(sed -n '1p' ~/.claude/skills/registrar-tarea/webapp-url.txt)"
SECRET="$(sed -n '2p' ~/.claude/skills/registrar-tarea/webapp-url.txt)"
curl -sL "$URL" -H 'Content-Type: application/json' -d "$(cat <<JSON
{"secret":"$SECRET","accion":"actualizar","fechaOriginal":"2026-08-06","numeroOriginal":"741","numero":"486180","actividad":"...","descripcion":"..."}
JSON
)"
```

Identifica la fila por `fila` (número explícito) o por
`fechaOriginal`+`numeroOriginal` (busca esa combinación en columnas A y D).
Solo pisa las columnas presentes en el body. **Requiere que el usuario haya
hecho "Nueva versión" del despliegue después de este cambio** — si el `.gs`
se editó pero no se redespliega, la Web App sigue sirviendo el código viejo
(solo `appendRow`) y esta acción no existe.

## Notas

- Registra automáticamente, sin confirmar, al terminar/avanzar una HU o BUG.
  Después informa qué fila quedó registrada.
- Una sola llamada = una sola fila. Si hubo varias tareas distinguibles,
  registra una fila por cada una.
- Si el POST falla por red/perma, indica revisar el despliegue de la Web App
  (acceso "Cualquier usuario", implementación vigente). Es un problema de
  configuración de la Web App, no del front.
- Diagnóstico rápido: un GET (`curl -sL "$URL"`) debe responder
  `{"ok":true,"sheetId":...}`. Si el GET funciona pero el POST devuelve HTTP 405
  o una página de error de Google Drive, casi siempre es por haber usado
  `-X POST` (ver paso 3): quítalo y reintenta.
