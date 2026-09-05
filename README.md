# Claude Code config — CoreVida/Positiva (GAIA)

Skills, agentes, scripts de hooks y settings de Claude Code usados en el proyecto
CORE GAIA (Positiva). Pensado para versionar en GitHub y restaurar en cualquier
máquina — **sanitizado**: todo secreto real fue reemplazado por un placeholder
o una env var. Ver [`SECRETS_CHECKLIST.md`](SECRETS_CHECKLIST.md) para la lista
completa de qué falta rellenar y de dónde sacarlo.

## Contenido

- `.claude/settings.json` — hooks (SessionStart, UserPromptSubmit, PostToolUse) y permisos base.
- `.claude/CLAUDE.md` — instrucciones globales + enrutamiento de agentes por modelo.
- `.claude/agents/` — `planificador-gaia`, `documentador-corevida`,
  `registrador-actividades`, `validador-ambientes`, `explorador-microservicios`,
  `revisor-corevida`.
- `.claude/skills/` — azure-devops-hu, conectar-bd-gaia, conectar-gitea,
  documento-maestro, evidencia-paso-a-paso, git-corevida, levantar-servicio-local,
  manual-tecnico, radicar-sarlaft-qa, registrar-tarea, sarlaft-integraciones,
  sgdea-uat, token-qa.
- `.claude/scripts/` — scripts que disparan los hooks.

## Enrutamiento de agentes por modelo

Los **skills no soportan `model:`** en el frontmatter: corren en la sesión
principal y heredan su modelo. Para fijar el modelo por tipo de tarea se usan
**agentes**, que sí lo aceptan.

| Agente | Modelo | Para qué |
|---|---|---|
| `planificador-gaia` | `fable` | Analizar la HU/bug y devolver el plan de implementación. Solo planea. |
| `documentador-corevida` | `sonnet` | Manual Técnico .docx, anexos `.md`/`.sql`, Postman, pantallazos. |
| `registrador-actividades` | `sonnet` | Escribir la fila de la HU/BUG o del commit en la hoja de actividades. |
| `validador-ambientes` | `sonnet` | BD, arranque local, token y humo contra endpoints en DEV/QA/UAT. |
| `explorador-microservicios` | `sonnet` | Localizar código/endpoints/tablas entre los repos. |
| `revisor-corevida` | `inherit` | Revisar el diff antes de cerrar una HU (juicio de calidad → modelo de la sesión). |

El desarrollo de código se queda en la sesión principal. El modelo de la sesión
(`"model"` en `settings.json`) **no se versiona** porque es preferencia de cada
máquina; configúralo con `/model`.

## Instalar en una máquina

```bash
git clone <esta-url> ~/claude-config-corevida
cp -R ~/claude-config-corevida/.claude/agents  ~/.claude/
cp -R ~/claude-config-corevida/.claude/skills  ~/.claude/
cp -R ~/claude-config-corevida/.claude/scripts ~/.claude/
cp -n ~/claude-config-corevida/.claude/CLAUDE.md ~/.claude/CLAUDE.md      # revisa antes si ya tienes uno
cp -n ~/claude-config-corevida/.claude/settings.json ~/.claude/settings.json  # revisa antes si ya tienes uno
chmod +x ~/.claude/scripts/*.sh
```

Luego completa los placeholders — ver `SECRETS_CHECKLIST.md`.

## Qué se sanitizó

Los SKILL.md originales tenían passwords de BD, el secreto de firma JWT, el
`client_secret`/password de SGDEA, las credenciales de los dos pools de
Cognito de SARLAFT y el usuario/password de Gitea **en texto plano**. Todo eso se reemplazó por placeholders
tipo `<DB_PASSWORD_QA>` o por una env var (`GAIA_JWT_SECRET`). El script
`token-qa/mint-token.py` ahora **lee el secreto de una env var** en vez de
tenerlo hardcodeado — falla explícitamente si no está seteada.

También se excluyeron por completo (no sanitizados, directamente fuera del repo
y en `.gitignore`):
- `registrar-tarea/webapp-url.txt` — URL + secret reales de tu Web App de Sheets.
- `token-qa/token-cache*.txt` — JWTs ya acuñados (son credenciales vivas, no plantillas).

## Qué NO incluye este repo (a propósito)

- Tu memoria persistente (`~/.claude/projects/*/memory`) — es personal/de sesión,
  no plantilla para compartir.
- `~/.claude.json` — estado y caché de una máquina específica.
- Tokens OAuth de MCP servers (Google Drive, Gmail, etc.) — no exportables, se
  reautorizan con `/mcp` en cada máquina.
- El código de los repos del proyecto — se clonan aparte con git.

Si necesitas los valores reales para tu propio uso diario, tu backup privado
(`claude-config-backup-*.zip`, generado por fuera de este repo) los tiene sin
sanitizar — **ese zip nunca debe subirse a GitHub**.
