#!/usr/bin/env bash
# Actualiza (git pull --ff-only) todos los repos locales bajo TemasCorporativos.
# Salta cualquier repo que tenga cambios sin commitear (working tree sucio).
# Invocado por el hook SessionStart de Claude Code. Se ejecuta en async, no bloquea.

BASE="/Users/hernannieto/Documents/TemasCorporativos"
LOG="$HOME/.claude/logs/pull-temascorporativos.log"
mkdir -p "$(dirname "$LOG")"

{
  echo "===== $(date '+%Y-%m-%d %H:%M:%S') | pull TemasCorporativos ====="
  # Busca cada repo git (carpeta que contiene .git) bajo BASE.
  find "$BASE" -maxdepth 4 -name .git -type d -prune 2>/dev/null | while read -r gitdir; do
    repo="$(dirname "$gitdir")"
    name="${repo#$BASE/}"

    # ¿Hay cambios sin commitear? Si los hay, NO tocar el repo.
    if [ -n "$(git -C "$repo" status --porcelain 2>/dev/null)" ]; then
      echo "  [SKIP] $name -> tiene cambios locales, no se actualiza"
      continue
    fi

    # Árbol limpio: intentar fast-forward. Nunca crea merge commits.
    if out="$(git -C "$repo" pull --ff-only 2>&1)"; then
      echo "  [ OK ] $name -> $(echo "$out" | tail -n1)"
    else
      echo "  [FAIL] $name -> $(echo "$out" | tail -n1)"
    fi
  done
} >> "$LOG" 2>&1
