#!/usr/bin/env bash
# Red de seguridad para el sync diario de 'dev'.
# Se invoca en el hook SessionStart de Claude Code. Si el job launchd de las 8am
# NO corrió hoy (p. ej. el equipo estaba apagado), ejecuta el sync ahora.
# Si ya corrió hoy, no hace nada -> no se repite en cada sesión.

STAMP="$HOME/.claude/logs/sync-dev-last-run.date"
TODAY="$(date '+%Y-%m-%d')"

if [ -f "$STAMP" ] && [ "$(cat "$STAMP" 2>/dev/null)" = "$TODAY" ]; then
  exit 0   # ya se sincronizó hoy
fi

exec "$HOME/.claude/scripts/sync-dev-temascorporativos.sh"
