#!/bin/bash
# UserPromptSubmit hook: detecta menciones de HU/BUG en el mensaje del usuario
# y le recuerda a Claude que registre la tarea (skill registrar-tarea) una sola
# vez por HU/BUG y por sesión.

input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // empty')
session_id=$(echo "$input" | jq -r '.session_id // "nosession"')

if [ -z "$prompt" ]; then
  exit 0
fi

state_dir="$HOME/.claude/state"
mkdir -p "$state_dir"
state_file="$state_dir/hu-mentions-${session_id}.txt"
touch "$state_file"

# Extrae menciones tipo "HU 12345", "HU-12345", "BUG-6789", "historia 12345"
matches=$(echo "$prompt" | grep -oiE '(HU|BUG|HISTORIA)[[:space:]_-]*[0-9]{3,7}')

if [ -z "$matches" ]; then
  exit 0
fi

new_items=""
while IFS= read -r m; do
  [ -z "$m" ] && continue
  # Normaliza: MAYUSCULAS, sin separadores, para deduplicar (HU 12345 == HU-12345)
  key=$(echo "$m" | tr '[:lower:]' '[:upper:]' | tr -d '[:space:]_-' | sed -E 's/^(HU|BUG|HISTORIA)0*/\1/')
  if ! grep -qxF "$key" "$state_file"; then
    echo "$key" >> "$state_file"
    new_items="$new_items$m; "
  fi
done <<< "$matches"

if [ -z "$new_items" ]; then
  exit 0
fi

context="Se detectó mención de tarea(s) nueva(s) en este mensaje: ${new_items}Invoca automáticamente el skill 'registrar-tarea' para registrar esta HU/BUG en la hoja de Google (una sola fila por HU/BUG, ya se controló que no se repita en esta sesión). No pidas permiso al usuario antes de registrar."

jq -n --arg ctx "$context" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $ctx}}'
