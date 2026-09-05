---
name: conectar-gitea
description: >-
  Conectarse al Gitea auto-hospedado del proyecto CORE GAIA/Positiva
  (https://gitea.nyx-gaia.com) por HTTPS con usuario/contraseña: clonar
  repos, hacer git ls-remote/fetch/push, y usar la API REST (crear PRs,
  listar ramas, leer archivos). Incluye las reglas OBLIGATORIAS de poner el
  clon local al día con el remoto antes de ramificar y de validar conflictos
  contra la rama base antes de cada push. Úsalo cuando el usuario pida
  clonar/pushear a Gitea, crear una rama o un Pull Request en Gitea,
  actualizar un clon de Gitea, consultar su API, o diga "conéctate a Gitea",
  "/conectar-gitea".
---

# Conectar a Gitea (nyx-gaia)

Host: `https://gitea.nyx-gaia.com` — organización `CorePositiva` (repos
espejo/paralelos de los de Azure DevOps, ver [[git-corevida]] para la
convención de ramas de Azure).

## REGLA: los endpoints de un cambio en un repo de Gitea van a infraestructura de Gitea

**Cualquier código nuevo/modificado dentro de un repo `CorePositiva/*` (front o
backend) debe llamar a servicios desplegados en la infraestructura de Gitea
(`*.nyx-gaia.com`), NUNCA al gateway legacy de Azure DevOps
(`corevida-{dev,qa}-v2.linktic.com`) — aunque el gateway legacy responda y
hasta cierto punto "funcione" para rutas antiguas, cruzar de un dominio a otro
para una ruta nueva rompe en CORS (ver caso real HU475 abajo).

- **Front**: si el repo ya tiene una variable de entorno tipo `API_V2` /
  `APIURL_V2` apuntando a `https://dev.nyx-gaia.com/api/` (patrón ya usado
  por `clientReasegurosV2` en `dev-web-core-front-v2`), usar ESA base para
  cualquier cliente HTTP nuevo — nunca `Endpoints.APIURL` (el gateway
  legacy). Si el repo no tiene aún esa variable, crearla siguiendo el mismo
  patrón antes de apuntar a un servicio nuevo.
- **Backend**: el servicio desplegado vía el pipeline de Gitea Actions
  (`.github/workflows/build-and-push.yml`) queda expuesto bajo
  `https://{dev,qa}.nyx-gaia.com/api/v1/{servicio}/{version}/...` (confirmar
  el prefijo real por servicio con quien administra el ingress — no asumirlo
  por analogía; ver ejemplo real abajo).
- **Caso real (HU475, 2026-09-01)**: en `dev-ms-core-siniestros-v2` se
  desplegó el maestro de semaforización; el front (`dev-web-core-front-v2`,
  servido desde `dev.nyx-gaia.com`) inicialmente apuntó el cliente HTTP a
  `Endpoints.APIURL` (`corevida-dev-v2.linktic.com`, gateway legacy). El
  `GET` directo servidor-a-servidor daba `401` (parecía funcionar), pero el
  navegador fallaba con CORS porque el **preflight `OPTIONS` daba 500** en
  ese gateway para la ruta nueva. Fix: cambiar a `Endpoints.APIURL_V2`
  (`https://dev.nyx-gaia.com/api/`) + el prefijo real confirmado
  `v1/siniestros/v3/api/v1` (dado por el usuario, verificado con
  `curl https://dev.nyx-gaia.com/api/v1/siniestros/v3/swagger-ui/index.html`)
  → mismo origen que el front, sin CORS. **Lección: un `401`/`403` en un
  `GET` directo NO confirma que la ruta esté bien enrutada para uso desde
  navegador — probar también el `OPTIONS` con `Origin`/`Access-Control-Request-*`
  antes de dar por buena una URL cross-origin.**
- Antes de dar por buena una URL de servicio en Gitea, **pedir/confirmar el
  dominio y prefijo real** (no inventarlo por analogía con otro servicio) —
  ver sección "1bis" más abajo para dónde ya se confirmaron algunos.

## Credenciales

| Usuario | Contraseña |
|---|---|
| `<GITEA_USER>` | `<GITEA_PASSWORD>` |

> ⚠️ No dejes estas credenciales embebidas en `.git/config` de ningún clon
> (`git remote set-url origin` sin usuario/contraseña después de clonar o
> pushear). Úsalas solo en el comando puntual (`-u`, URL con credenciales,
> o header `Authorization`) y no las imprimas en logs que se compartan.

## 1. Clonar / fetch / push por HTTPS

```bash
git clone "https://<GITEA_USER>:<GITEA_PASSWORD>@gitea.nyx-gaia.com/CorePositiva/<repo>" <destino>
# tras clonar, quita la credencial del remote guardado en disco:
cd <destino> && git remote set-url origin "https://gitea.nyx-gaia.com/CorePositiva/<repo>"
```

Para push puntual sin credencial persistida:
```bash
git push "https://<GITEA_USER>:<GITEA_PASSWORD>@gitea.nyx-gaia.com/CorePositiva/<repo>" <rama>
```

## 1bis. Clones locales — convención de carpeta y qué rama usar

Los repos de Gitea que se clonan localmente para trabajar (no solo consultar)
van en una carpeta **separada** de los clones de Azure DevOps, para no
confundir cuál `origin` apunta a cuál plataforma:

```
$HOME/Documents/TemasCorporativos/gitea/
  backend/<repo>/
  frontend/<repo>/
```

Ya clonados ahí (HU475, 2026-08-31): `gitea/backend/dev-ms-core-siniestros-v2`,
`gitea/frontend/dev-web-core-front-v2`.

**`main` NO es necesariamente la rama de trabajo real** — en
`dev-ms-core-siniestros-v2` el `main` de Gitea es solo el scaffold inicial
vacío ("complemento de la primera carga"); el código real (controllers,
casos de uso, etc.) vive en `dev`. En `dev-web-core-front-v2` sí hay contenido
real en ambas, pero `dev` está adelante y `main` es ancestro de `dev` (dev
tiene todo lo de main + más) — usar `dev` como base para ramificar en los
dos casos. Verificar siempre con `git log -1 --oneline <rama>` y
`git merge-base --is-ancestor` antes de asumir cuál es la base correcta,
puede variar por repo.

**Divergencia confirmada** (no solo teórica) entre Azure DevOps y Gitea en
`dev-ms-core-siniestros-v2`: el `dev` de Gitea tiene un
`IdentificadorInvalidoException` handler en `ManejadorErrores.java` que el
`dev` de Azure NO tiene; el `dev` de Azure tiene un handler de
`TechnicalFailureException` (gestión documental) que Gitea NO tiene. Al traer
cambios de un clon de Azure hacia el clon de Gitea (o viceversa), para
archivos que YA EXISTEN en ambos lados: probar primero con
`git diff` (en el origen) + `git apply --check` (contra el destino) — si
aplica limpio, el archivo no había divergido y es seguro aplicar el patch. Si
falla, hay que fusionar a mano (nunca sobrescribir el archivo completo, se
pierde funcionalidad real del lado que no se está copiando). Para archivos
100% nuevos (sin equivalente previo en el destino) sí es seguro copiar
directo.

## REGLA: poner el clon al día con el remoto antes de ramificar

**Nunca ramificar ni empezar a codificar sobre el estado que tenga el clon.**
Un clon local puede llevar semanas sin tocarse (caso real: `dev` de
`dev-web-core-front-v2` estaba **41 commits detrás** de `origin/dev` al
arrancar la HU476) y una rama nacida ahí arrastra el desfase hasta el PR.

Antes de crear la rama, siempre:

```bash
cd <clon de gitea>
git fetch --all --prune
git status --porcelain          # ¿hay WIP sin commitear?
git rev-list --left-right --count dev...origin/dev   # 0 <n> = local atrasado n commits
```

- **Actualizar la rama base sin checkout** (no pisa el WIP de otra tarea):
  `git fetch origin dev:dev` (y `qa:qa`, `main:main` si se van a usar).
  Si ya estás parado en la rama base y limpio, vale `git pull --ff-only`;
  si el `pull` no avanza en fast-forward, **parar y revisar** — hay commits
  locales que nadie esperaba, no forzar.
- **Confirmar cuál es la base real** con `git merge-base --is-ancestor`
  (ver §1bis: `main` no siempre es la rama de trabajo).
- **Si hay cambios sin commitear de OTRA tarea**, no cambiar de rama en el
  mismo directorio: usar un worktree dedicado.
  ```bash
  git worktree add ../<repo>-<hu> -b feature/<idAzure>-HU<num>-<desc> dev
  ```
- Ramificar SIEMPRE desde la rama base ya actualizada, nunca desde la rama de
  la tarea anterior.

## REGLA: validar conflictos contra la rama base ANTES del push

Nunca pushear sin comprobar que la rama integra limpio contra su rama base
actualizada. El objetivo es enterarse del conflicto en local, no en el PR de
Gitea ni en el runner.

```bash
git fetch origin dev                     # traer lo último de la base
git rev-list --left-right --count HEAD...origin/dev   # <adelante> <detrás>

# simulación del merge: exit 0 = limpio, 1 = hay conflictos (git >= 2.38)
git merge-tree --write-tree --name-only HEAD origin/dev >/dev/null; echo "conflictos: $?"

# fallback en git viejo (sin --write-tree): buscar marcadores en la salida
git merge-tree $(git merge-base HEAD origin/dev) HEAD origin/dev | grep -i "<<<<<<<\|CONFLICT"
```

- `merge-tree` es **una simulación**: no toca el árbol de trabajo ni crea
  commits. Exit 0 (o sin salida en la forma vieja) = integra limpio → se
  puede pushear. Verificado con git 2.50.1.
- **Si reporta conflicto:** resolverlo en local ANTES del push —
  `git merge origin/dev` (o `git rebase origin/dev` si la rama aún no se ha
  compartido), arreglar los archivos, correr build/tests otra vez, y
  recién ahí pushear. Nunca `push --force` sobre una rama que ya vio otra
  persona.
- Revisar también qué se está subiendo: `git status --porcelain` y
  `git diff --stat origin/dev...HEAD` — que no se cuelen archivos de otra
  tarea (ver la regla de `git add` selectivo en [[git-corevida]]).
- Tras el push, verificar que el PR de Gitea salga **mergeable**
  (`GET /api/v1/repos/CorePositiva/<repo>/pulls/<n>` → `"mergeable": true`).
  Si sale `false`, el conflicto se resuelve en la rama de la tarea, nunca
  mergeando `dev` "hacia atrás" desde la UI sin revisar.

## 1ter. `dev-web-core-front-v2`: paquete privado npm requiere token

`.npmrc` de este repo fija `@formbuilder:registry` al registro npm de Gitea y
exige `NPM_GITEA_TOKEN` en el entorno (`npm install` falla con 401 sin él).
Generar uno de un solo uso con la API (scope `write:package`/`read:package`)
y revocarlo después de instalar:

```bash
curl -s -u '<GITEA_USER>:<GITEA_PASSWORD>' -X POST \
  "https://gitea.nyx-gaia.com/api/v1/users/<GITEA_USER>/tokens" \
  -H "Content-Type: application/json" \
  -d '{"name":"npm-<contexto>","scopes":["write:package","read:package"]}'
# usar el "sha1" devuelto:
NPM_GITEA_TOKEN=<sha1> npm install --no-audit --no-fund
# luego revocar (usar el "id" devuelto en la creación):
curl -s -u '<GITEA_USER>:<GITEA_PASSWORD>' -X DELETE \
  "https://gitea.nyx-gaia.com/api/v1/users/<GITEA_USER>/tokens/<id>"
```

## 1quater. Repos existentes en la org `CorePositiva` (confirmado 2026-08-31)

`dev-web-front-core`, `dev-web-core-front-v2`, `dev-ms-core-siniestros-v2`,
`dev-ms-core-reservas-v2`, `dev-ms-core-reaseguros-v2`, `dev-ms-core-producto-v2`,
`dev-ms-core-politicas-v2`, `dev-ms-core-novedades-v2`, `dev-ms-core-login-v2`,
`dev-ms-core-integraciones-v2`, `dev-ms-core-facturacion-v2`,
`dev-ms-core-emisiones-v2`, `dev-ms-core-cotizaciones-v2`,
`dev-ms-core-coaseguros-v2`, `dev-ms-core-cartera-v2`, `dev-ms-core-reporteria-v2`,
`CORE` (proyecto aparte: "Servicio de agentes IA", NO es el monolito),
`Form_builder`, `Orchestrator`. **`dev-ms-core-core` (el monolito legacy) NO
existe en esta org** — si una tarea lo requiere ahí, hay que crearlo primero
(`POST /api/v1/orgs/CorePositiva/repos`) y decidir con el usuario si se
migra el historial completo de `dev` (Azure) o se arranca liviano.

## 1quinquies. Prefijos de endpoint confirmados por servicio (DEV)

Solo agregar filas cuando el prefijo se haya CONFIRMADO de verdad (curl real
o dato dado por el usuario) — no completar por analogía.

| Servicio | Host (DEV) | Prefijo tras el host | Notas |
|---|---|---|---|
| `dev-ms-core-siniestros-v2` | `dev.nyx-gaia.com` | `/api/v1/siniestros/v3` | Swagger: `/api/v1/siniestros/v3/swagger-ui/index.html`. Controllers internos en `/api/v1/...`, o sea URL final = host + prefijo + `/api/v1/{recurso}`. |
| `reaseguros-v2` | `dev.nyx-gaia.com` | (via `APIURL_V2` + `BASE_REASEGUROS_V2`) | Ya conectado en el front, patron de referencia (`clientReasegurosV2`). |

## 2. API REST

Base: `https://gitea.nyx-gaia.com/api/v1`

```bash
# Listar ramas
curl -s -u '<GITEA_USER>:<GITEA_PASSWORD>' \
  "https://gitea.nyx-gaia.com/api/v1/repos/CorePositiva/<repo>/branches"

# Info de una rama (último commit)
curl -s -u '<GITEA_USER>:<GITEA_PASSWORD>' \
  "https://gitea.nyx-gaia.com/api/v1/repos/CorePositiva/<repo>/branches/<rama>"

# Crear un Pull Request
curl -s -u '<GITEA_USER>:<GITEA_PASSWORD>' -X POST \
  "https://gitea.nyx-gaia.com/api/v1/repos/CorePositiva/<repo>/pulls" \
  -H "Content-Type: application/json" \
  -d '{"title":"<titulo>","head":"<rama-origen>","base":"<rama-destino>","body":"<descripcion>"}'
```

## Relacionado

- Repos ya verificados: `CorePositiva/dev-ms-core-siniestros-v2` (contiene
  además `.github/workflows/*` de CI/CD propio de Gitea Actions y
  `k8s/siniestros-api.yaml` — ver notas de despliegue abajo antes de asumir
  que el código de Azure DevOps despliega tal cual).
- El repo de Azure DevOps (`origin` en el clon habitual de
  `backend/dev-ms-core-siniestros-v2`) y el de Gitea pueden tener **historias
  de git completamente independientes** (sin ancestro común) — antes de
  mergear/pushear, comparar con `git merge-base --is-ancestor` en vez de
  asumir que son el mismo árbol.

### Deploy en Gitea Actions: puerto de management/actuator

El manifest `k8s/siniestros-api.yaml` de `dev-ms-core-siniestros-v2` define
los `readinessProbe`/`livenessProbe` contra un puerto `management` = **8081**
separado del puerto de la app (**8080**). El código real (rama `dev` de
Azure DevOps) **no** configura `management.server.port` — todo, incluido
`/actuator/health`, corre en el mismo puerto 8080 (confirmado corriendo el
servicio en local). Si se despliega ese código tal cual, los health checks
en 8081 fallan (connection refused) y el rollout de Kubernetes nunca queda
`Ready` → el job `deploy` de `build-and-push.yml` hace timeout y revierte
(`kubectl rollout undo`). Hace falta agregar
`management.server.port: 8081` (o bajar el manifest a apuntar al puerto
8080) antes de que un merge a `dev` de Gitea despliegue con éxito.
