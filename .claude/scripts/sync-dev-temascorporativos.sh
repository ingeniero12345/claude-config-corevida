#!/usr/bin/env bash
# Sincroniza la rama 'dev' de TODOS los repos locales bajo TemasCorporativos con origin.
# Diseñado para correr a diario via launchd (entorno mínimo -> PATH explícito).
#
# Estrategia segura (respeta las convenciones de trabajo, NO toca tu trabajo en curso):
#   1. git fetch --all --prune            (trae refs remotas)
#   2. Actualizar la rama local 'dev':
#        - si estás en 'dev' y el árbol está limpio -> git pull --ff-only origin dev
#        - en cualquier otro caso                    -> git fetch origin dev:dev
#          (mueve la rama local 'dev' al origin/dev SIN cambiar de rama ni tocar
#           el working tree; falla sin efecto si 'dev' divergió)
# Nunca hace checkout, merge ni toca ramas distintas de 'dev'.

export PATH="/usr/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

BASE="/Users/hernannieto/Documents/TemasCorporativos"
LOG="$HOME/.claude/logs/sync-dev-temascorporativos.log"
mkdir -p "$(dirname "$LOG")"

{
  echo "===== $(date '+%Y-%m-%d %H:%M:%S') | sync dev TemasCorporativos ====="
  find "$BASE" -maxdepth 4 -name .git -type d -prune 2>/dev/null | while read -r gitdir; do
    repo="$(dirname "$gitdir")"
    name="${repo#$BASE/}"

    # ¿Existe la rama remota origin/dev? Si no, saltar.
    if ! git -C "$repo" ls-remote --exit-code --heads origin dev >/dev/null 2>&1; then
      echo "  [SKIP] $name -> no tiene rama remota 'dev'"
      continue
    fi

    git -C "$repo" fetch --all --prune >/dev/null 2>&1

    cur="$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)"
    dirty="$(git -C "$repo" status --porcelain 2>/dev/null)"

    if [ "$cur" = "dev" ]; then
      if [ -n "$dirty" ]; then
        echo "  [SKIP] $name -> en 'dev' con cambios locales, no se actualiza"
        continue
      fi
      if out="$(git -C "$repo" pull --ff-only origin dev 2>&1)"; then
        echo "  [ OK ] $name (dev) -> $(echo "$out" | tail -n1)"
      else
        echo "  [FAIL] $name (dev) -> $(echo "$out" | tail -n1)"
      fi
    else
      # No estamos en dev: actualizar el ref local dev sin tocar el working tree.
      if out="$(git -C "$repo" fetch origin dev:dev 2>&1)"; then
        echo "  [ OK ] $name (dev ref, en '$cur') -> actualizado a origin/dev"
      else
        echo "  [FAIL] $name (dev ref, en '$cur') -> $(echo "$out" | tail -n1)"
      fi
    fi
  done
  # Marca de "corrió hoy" para el guard del hook SessionStart (red de seguridad).
  date '+%Y-%m-%d' > "$HOME/.claude/logs/sync-dev-last-run.date"
} >> "$LOG" 2>&1
