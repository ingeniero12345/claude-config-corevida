# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

# Enrutamiento de agentes (modelo por tipo de tarea)
Delega en el agente correspondiente en vez de hacer el trabajo en la sesión principal:
- **Planear** una HU/bug (análisis + plan de implementación) → `planificador-gaia` (Fable 5).
- **Documentar** (Manual Técnico .docx, anexos .md/.sql, Postman, pantallazos) → `documentador-corevida` (Sonnet 5).
- **Registrar actividades** en la hoja (HU/BUG, commits) → `registrador-actividades` (Sonnet 5).
- **Validar ambientes** (BD, arranque local, token, humo a endpoints) → `validador-ambientes` (Sonnet 5).
- **Localizar código** entre repos → `explorador-microservicios` (Sonnet 5).
- **Revisar el diff** antes de cerrar una HU → `revisor-corevida` (hereda el modelo de la sesión).
El desarrollo/implementación de código se queda en la sesión principal (Opus).
