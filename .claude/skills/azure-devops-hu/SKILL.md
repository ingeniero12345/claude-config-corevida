---
name: azure-devops-hu
description: >-
  Consulta Historias de Usuario / work items de Azure DevOps (org "Linktic",
  proyecto "355- Positiva Core") vía la API REST (WIQL), usando el PAT del
  usuario guardado en la variable de entorno AZDO_PAT. Úsalo cuando el usuario
  pida "qué tengo asignado en Azure DevOps", "mis historias de usuario",
  "consulta la HU <id>", "qué está en desarrollo/QA", mencione la palabra
  "azure" en cualquier forma, o assignedtome/work items de Azure DevOps,
  "/azure-devops-hu".
---

# Azure DevOps — Historias de Usuario (Linktic / Positiva Core)

Consulta work items de Azure DevOps por API REST usando un Personal Access
Token (PAT) del usuario.

## Requisitos (ya configurados)

Variables de entorno en `~/.zshrc`:

- `AZDO_ORG` = `Linktic`
- `AZDO_PROJECT` = `355- Positiva Core`
- `AZDO_PAT` = PAT del usuario (permiso de lectura sobre Work Items)

Si faltan, pide al usuario que las agregue o corra `source ~/.zshrc`. **Nunca
imprimas el valor de `AZDO_PAT` en la salida ni lo escribas en memoria/archivos
nuevos** — ya vive solo en `~/.zshrc`.

## Cómo usarlo

Script: `~/.claude/skills/azure-devops-hu/query.sh`

```bash
# Mis work items activos (no Closed) — default
~/.claude/skills/azure-devops-hu/query.sh

# WIQL personalizado
~/.claude/skills/azure-devops-hu/query.sh "SELECT [System.Id], [System.Title] FROM WorkItems WHERE [System.AssignedTo] = @Me AND [System.WorkItemType] = 'User Story'"

# Detalle de IDs específicos
~/.claude/skills/azure-devops-hu/query.sh --ids 479332,427209
```

Salida: por cada work item, ID, tipo, estado, título, iteration path, area
path y fecha de último cambio.

## Notas

- **El PAT no está limitado a "asignado a mí"**: si tiene permiso de lectura
  sobre Work Items del proyecto, puede consultar items de cualquier persona
  (basta con no filtrar por `[System.AssignedTo] = @Me` en el WIQL). El
  default del script SÍ filtra por `@Me`; para ver de otros, pasa un WIQL
  custom sin ese filtro (ej. por `[System.AreaPath]`, `[System.IterationPath]`
  o `[System.AssignedTo] = 'nombre@linktic.com'`).
- El script pagina el detalle en lotes de 200 IDs (límite de la API) y avisa
  si una query devuelve más de 50 items, para acotar antes de listar todo.
- El PAT es de **solo lectura** de work items; si una consulta falla con 401/403,
  puede que el PAT haya vencido o le falte el scope — pide al usuario que genere
  uno nuevo en Azure DevOps (User Settings → Personal Access Tokens) y actualice
  `AZDO_PAT` en `~/.zshrc`.
- El proyecto tiene el nombre con espacio y guion (`355- Positiva Core`); el
  script se encarga de URL-encodearlo.
- Área típica del usuario: `355- Positiva Core\416  Positiva Core 2026\4 siniestros y resevas`.
- Estados de User Story observados en este proyecto: `6. Desarrollo`,
  `6.1 Esperando Despliegue DEV-QA`, entre otros (no asumir una lista fija sin
  confirmarla si se necesita filtrar por estado).
