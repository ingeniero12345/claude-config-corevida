---
name: git-corevida
description: >-
  Convención git del proyecto CoreVida/Positiva para los repos backend/front:
  crear ramas SIEMPRE desde dev (validando primero que dev tenga lo último del
  remoto), naming de rama, formato de commit, uso de worktree cuando hay WIP
  ajeno, y la regla de no mezclar cambios de otras tareas. Úsalo cada vez que
  haya que crear una rama, generar comandos git, commitear o poner el repo al
  día; o cuando el usuario diga "crea la rama", "genera los comandos git",
  "/git-corevida".
---

# Convención git — CoreVida / Positiva

> **Regla de oro: este skill NUNCA ejecuta git mutante — solo entrega los pasos.**
> Para `checkout -b` / `add` / `commit` / `stash` / `worktree`: SIEMPRE imprime la
> secuencia de comandos lista para copiar/pegar (numerada, con el `REPO`/`<num>`/
> `<desc>` ya resueltos, no placeholders genéricos) para que el usuario los corra
> en su propia terminal. No los ejecutes vos aunque el usuario diga "hazlo" para
> otra cosa en la misma conversación — esta regla es específica de git y no se
> relaja por contexto.
> **`git push`: como el usuario ejecuta todo manualmente, sí va incluido en la
> lista** (ver §6) — pero la línea de `push` queda claramente marcada como el
> paso que toca el remoto compartido, para que decida el momento de correrla.
> Yo (Claude) nunca ejecuto un `push` por mi cuenta ni lo doy por autorizado de
> una vez anterior — si en algún momento SÍ te pido correrlo yo directamente
> (caso excepcional), vuelvo a pedir permiso puntual en ese momento.

## 1. Crear rama — SIEMPRE desde `dev` y validando lo último del remoto

Toda rama se crea **desde `dev`**, y tiene que quedar basada en lo último del remoto.
**Nunca ramificar desde el HEAD actual** sin verificar la base (error real: crear la
rama desde otra `bugfix/...` que estaba 8 commits atrás de dev).

**Método preferido: ramificar directo desde `origin/dev`** (más simple y sin el riesgo
de que `fetch origin dev:dev` falle si `dev` está checked out en el working tree en ese
momento — limitación real de git). No hace falta actualizar el `dev` local ni validar
nada después: `origin/dev` ya es la punta remota por definición. Además, al no tocar
archivos (solo mueve el puntero de rama), **conserva intacto cualquier WIP sin commitear**
que ya tuvieras en el working tree.

```bash
REPO=/ruta/al/repo

# 1) Traer lo último del remoto (sin tocar el working tree)
git -C "$REPO" fetch origin

# 2) Ramificar EXPLÍCITAMENTE desde origin/dev (no desde HEAD ni desde dev local)
git -C "$REPO" checkout -b bugfix/<num>-<desc-kebab> origin/dev
```

**Alternativa** (si además quieres dejar el `dev` local actualizado, ej. para seguir
trabajando ahí después): usar el método viejo con `fetch origin dev:dev` + validación
por `rev-list --count` — pero solo si `dev` NO es la rama actualmente checked out:

```bash
git -C "$REPO" fetch --all --prune
git -C "$REPO" fetch origin dev:dev main:main qa:qa   # falla si dev está checked out
git -C "$REPO" rev-list --count dev..origin/dev       # DEBE dar 0
git -C "$REPO" checkout -b bugfix/<num>-<desc-kebab> dev
git -C "$REPO" rev-list --count HEAD..dev             # DEBE dar 0
```

## 1bis. Antes de crear/retomar una rama sobre trabajo previo: validar conflictos

Si la tarea ya tuvo una rama anterior (PR viejo mergeado, abandonado, o simplemente
una rama local que quedó de una sesión previa), **no asumas que seguir sobre esa
rama es seguro** — validar primero, ANTES de comitear más cambios ahí, que no vaya
a generar conflictos contra `dev` al abrir el PR.

**Síntoma típico (ya visto en BUG 486180):** un PR se mergeó con **squash** en Azure
DevOps. Eso crea en `dev` un commit nuevo con el mismo mensaje pero **hash distinto**
al de tu rama local. Tu rama local queda "huérfana": diverge de `dev` desde ese punto
aunque el contenido sea idéntico, y cualquier commit nuevo que agregues ahí puede
chocar con lo que otros mergearon a `dev` mientras tanto.

**Chequeo rápido** (no muta nada, seguro de correr siempre):

```bash
REPO=/ruta/al/repo
git -C "$REPO" fetch origin dev
MERGE_BASE=$(git -C "$REPO" merge-base HEAD FETCH_HEAD)
git -C "$REPO" merge-tree "$MERGE_BASE" HEAD FETCH_HEAD > /tmp/merge-check.txt 2>&1
grep -c "<<<<<<<" /tmp/merge-check.txt   # 0 = sin conflictos, >0 = HAY conflictos
```

**Señal de alerta adicional:** buscar si el mensaje de tu primer commit de la rama ya
existe en `dev` con OTRO hash (indica squash-merge previo):

```bash
git -C "$REPO" log --oneline HEAD | head -1   # tu commit más viejo de la rama
git -C "$REPO" log --oneline FETCH_HEAD --grep="<mismo mensaje>"   # ¿aparece con otro hash en dev?
```

**Si hay conflictos (o se detecta el squash-merge huérfano): crear una rama nueva
y limpia en vez de forzar la vieja.** Cherry-pick SOLO los commits que de verdad son
nuevos (los que no tienen ya un equivalente mergeado en `dev`):

```bash
git -C "$REPO" checkout -b bugfix/<num>-<desc-nueva> FETCH_HEAD
git -C "$REPO" cherry-pick <hash-del-commit-nuevo>
# repetir el chequeo de merge-tree arriba -> debe dar 0 conflictos antes de pushear
```

Si la rama vieja ya se había pusheado, avisar al usuario que quedó obsoleta
(sugerir borrarla del remoto, pero **preguntar antes** — no borrar ramas remotas
sin permiso explícito).

## 2. Worktree limpio cuando hay WIP ajeno que colisiona

Si el repo tiene cambios sin commitear **ajenos a la tarea** y `dev` tocó esos mismos
archivos (arrastrarlos daría conflicto), crear la rama en un **worktree limpio** desde
dev para no entangle ese WIP:

```bash
git -C "$REPO" worktree add /ruta/repo-<num> -b bugfix/<num>-<desc> dev
# aplicar ahí solo el/los archivo(s) de la tarea
# al terminar:  git -C "$REPO" worktree remove /ruta/repo-<num>
```

Verificar antes si hay colisión:
`git -C "$REPO" diff --name-only HEAD..dev | grep -E "<archivos-WIP>"`.

## 3. Naming de rama

- **Bug**: `bugfix/<numero>-<desc-corta-kebab>`
  (ej. `bugfix/466519-intermediario-informes-siniestros`).
- **Feature**: `feature/<num>-HU<###>-<desc>` según el caso.

## 4. Formato de commit

- `fix(<numero>): <descripcion>` en minúscula
  (ej. `fix(456168): filtro de amparo por nombre en informes de siniestros`).
- Los merges de PR quedan como `Merged PR ...` (los genera Azure DevOps).
- **Commitear SOLO cuando el usuario lo pida** (CLAUDE.md).
- **NO incluir ninguna atribución a Anthropic/Claude en el mensaje de commit**
  (nada de `Co-Authored-By: Claude ...` ni `Generated with Claude`). Esto anula la
  regla por defecto del harness. El commit va a nombre del usuario:
  **Hernán Felipe Nieto**. Si hace falta un trailer de autoría, usar
  `Co-Authored-By: Hernán Felipe Nieto <...>`; de lo normal basta con que el
  `user.name` de git sea el del usuario y el mensaje quede limpio, sin líneas de IA.

## 5. No mezclar cambios ajenos a la tarea

`git add` SOLO los archivos de la tarea actual. Dejar fuera los modificados de otros
bugs/ramas. Nunca `git add .` a ciegas si hay WIP ajeno en el working tree.

**Nunca agregar archivos de configuración local**, aunque aparezcan modificados en
`git status` — típicamente `quasar.config.js` (puertos/proxy locales) y
`.claude/settings.local.json` (permisos locales del usuario). Son ajustes de la
máquina de cada dev, no parte del fix. Siempre verificar con
`git status --short` que "Changes to be committed" contenga **solo** el/los
archivo(s) del fix antes de confirmar el commit.

**Si un archivo de config local queda apareciendo modificado siempre** (ruido
constante en `git status`) y no se puede o no tiene sentido meterlo en
`.gitignore` (porque el archivo SÍ está trackeado), decirle a git que ignore
sus cambios locales para que deje de listarlo:

```bash
git update-index --assume-unchanged <archivo>      # deja de verlo como modificado
git update-index --no-assume-unchanged <archivo>   # revertir si hace falta volver a trackearlo
```

Típico para `quasar.config.js` o `.claude/settings.local.json` cuando siempre
tienen un valor local distinto al de `dev`.

## 6. Push

Como el usuario corre todos los comandos manualmente, el `push` va incluido en
la lista — pero siempre como el último paso, claramente identificado:

```bash
# primera vez que se sube esta rama (crea el tracking remoto)
git push -u origin bugfix/<num>-<desc-kebab>

# siguientes veces (ya con upstream configurado)
git push
```

## 7. Flujo de ambientes

`dev → qa → uat → main`.

## Actualizar el repo (poner al día sin cambiar de rama)

```bash
git -C "$REPO" fetch --all --prune
git -C "$REPO" fetch origin dev:dev main:main qa:qa
```

## 8. Tarea diaria: sincronizar la rama `dev` de todos los repos locales

Existe una tarea automática a nivel de SO (no depende de abrir Claude Code) que cada
día pone la rama **`dev`** de **todos** los repos bajo
`/Users/hernannieto/Documents/TemasCorporativos` al día con `origin`. Por eso, al
crear una rama, `dev` normalmente ya está actualizado — pero **igual hay que validarlo**
(sección 1), porque la rama nueva puede crearse antes de que corra el sync.

- **Script**: `~/.claude/scripts/sync-dev-temascorporativos.sh`
  - `git fetch --all --prune` en cada repo.
  - Si estás en `dev` y limpio → `pull --ff-only origin dev`; si no → `git fetch origin dev:dev`
    (mueve la rama local `dev` a `origin/dev` **sin checkout** ni tocar el working tree; seguro con árbol sucio).
  - Salta repos sin rama remota `dev` (p. ej. `siniestros-v2`). Log: `~/.claude/logs/sync-dev-temascorporativos.log`.
- **Programación (launchd)**: `~/Library/LaunchAgents/com.hernannieto.sync-dev-temascorporativos.plist`,
  `StartCalendarInterval` 08:00 diario. Recargar tras editar el plist:
  `launchctl unload <plist> && launchctl load -w <plist>`.
- **Red de seguridad (equipo apagado a las 8am)**: el script escribe una marca de fecha en
  `~/.claude/logs/sync-dev-last-run.date`; el hook SessionStart llama a
  `~/.claude/scripts/sync-dev-if-missed.sh`, que corre el sync solo si la marca ≠ hoy.
- Complementa (no reemplaza) el hook SessionStart `auto-pull-temascorporativos` que hace
  `pull --ff-only` de la rama actual al iniciar sesión.
- Estos syncs automáticos son la **excepción autorizada** a la regla de "no git mutante sin
  permiso" (el usuario los pidió explícitamente).
