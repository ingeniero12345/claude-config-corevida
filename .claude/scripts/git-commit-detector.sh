#!/bin/bash
# PostToolUse hook (matcher: Bash): detecta un `git commit` exitoso y le pide
# a Claude que registre una fila en el Excel con el comentario del commit
# (skill registrar-tarea). Una fila por commit, independiente del hook de
# menciones de HU/BUG (hu-mention-detector.sh).

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')
stdout=$(echo "$input" | jq -r '.tool_response.stdout // empty')

[ -z "$command" ] && exit 0
echo "$command" | grep -qE '(^|[;&|]|&&)[[:space:]]*git([[:space:]]+-C[[:space:]]+[^ ]+)?[[:space:]]+commit([[:space:]]|$)' || exit 0

# Línea estándar de éxito de `git commit`: "[rama hash] asunto del commit"
subject=$(echo "$stdout" | grep -m1 -E '^\[[^ ]+ [0-9a-f]+\] ' | sed -E 's/^\[[^ ]+ [0-9a-f]+\] //')
[ -z "$subject" ] && exit 0   # no hubo commit real (nothing to commit, hook falló, etc.)

repo=$(echo "$command" | grep -oE '\-C[[:space:]]+[^ ]+' | awk '{print $2}')
if [ -z "$repo" ]; then
  repo=$(echo "$input" | jq -r '.cwd // empty')
fi

context="Se detectó un commit exitoso${repo:+ en $repo}: \"$subject\". Invoca el skill 'registrar-tarea' para agregar una fila en la hoja de Google con este comentario de commit (una fila por commit, además de cualquier registro por HU/BUG ya hecho). Si el mensaje trae un número de HU/BUG (ej. fix(741): ...), úsalo en 'numero' y busca su título completo por WIQL como indica el skill; si no, deja 'numero' vacío y usa el asunto del commit como 'actividad'. No pidas permiso."

jq -n --arg ctx "$context" '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $ctx}}'
