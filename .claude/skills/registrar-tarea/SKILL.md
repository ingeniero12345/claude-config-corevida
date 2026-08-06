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
> UNA fila por HU/BUG (deduplicada por sesión en
> `~/.claude/state/hu-mentions-<session_id>.txt`), generada al MENCIONARLA por
> primera vez — ya no se registra otra vez al cerrarla.

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
   - `actividad`: resumen corto en el estilo de la hoja, p.ej.
     `bug 466519, revision vista` o `hu 295592`.
   - `descripcion`: descripción larga si se conoce el título completo del ticket
     (p.ej. `bug 466519 416_SALUD_SIN_HU353_Informes De Siniestros - ...`). Si no,
     déjala vacía.
   - NO pidas confirmación: registra directamente con los mejores valores que
     tengas del trabajo hecho. No inventes títulos de tickets: si no conoces la
     descripción larga, deja `descripcion` vacía en vez de suponerla.

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
