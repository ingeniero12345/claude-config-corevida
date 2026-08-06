# Claude Code config — CoreVida/Positiva (GAIA)

Skills, agentes, scripts de hooks y settings de Claude Code usados en el proyecto
CORE GAIA (Positiva). Pensado para versionar en GitHub y restaurar en cualquier
máquina — **sanitizado**: todo secreto real fue reemplazado por un placeholder
o una env var. Ver [`SECRETS_CHECKLIST.md`](SECRETS_CHECKLIST.md) para la lista
completa de qué falta rellenar y de dónde sacarlo.

## Contenido

- `.claude/settings.json` — hooks (SessionStart, UserPromptSubmit) y permisos base.
- `.claude/agents/` — `explorador-microservicios`, `revisor-corevida`.
- `.claude/skills/` — azure-devops-hu, conectar-bd-gaia, documento-maestro,
  evidencia-paso-a-paso, git-corevida, levantar-servicio-local, manual-tecnico,
  radicar-sarlaft-qa, registrar-tarea, sarlaft-integraciones, sgdea-uat, token-qa.
- `.claude/scripts/` — scripts que disparan los hooks.

## Instalar en una máquina

```bash
git clone <esta-url> ~/claude-config-corevida
cp -R ~/claude-config-corevida/.claude/agents  ~/.claude/
cp -R ~/claude-config-corevida/.claude/skills  ~/.claude/
cp -R ~/claude-config-corevida/.claude/scripts ~/.claude/
cp -n ~/claude-config-corevida/.claude/settings.json ~/.claude/settings.json  # revisa antes si ya tienes uno
chmod +x ~/.claude/scripts/*.sh
```

Luego completa los placeholders — ver `SECRETS_CHECKLIST.md`.

## Qué se sanitizó

Los SKILL.md originales tenían passwords de BD, el secreto de firma JWT, el
`client_secret`/password de SGDEA y las credenciales de los dos pools de
Cognito de SARLAFT **en texto plano**. Todo eso se reemplazó por placeholders
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
