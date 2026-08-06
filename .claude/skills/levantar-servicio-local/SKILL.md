---
name: levantar-servicio-local
description: >-
  Levantar un microservicio de CORE GAIA en local desde CLI (bootRun/Gradle o
  Maven), con los fixes ya conocidos para errores típicos de arranque
  (context-path, RabbitMQ, Redis, vars faltantes/vacías, JDK/Maven). Cubre
  `dev-ms-core-emisiones` (Gradle) y `dev-ms-core-core` (monolito, Maven).
  Úsalo cuando el usuario pida "levanta emisiones/el monolito en local",
  "arranca el servicio contra QA", o cuando un bootRun falle con errores de
  placeholder/RabbitMQ/Redis, "/levantar-servicio-local".
---

# Levantar un microservicio GAIA en local

Regla general: **NO modificar el `.env` versionado ni el código**. Cargar el
`.env` + un archivo de overrides local en el mismo comando (el shell no
persiste env entre llamadas), y explicar cada comando antes de correrlo.

## Túneles previos (compartidos entre todos los servicios)

Todo pasa por AWS SSM al bastión `i-015128a55cf93dba4` (us-east-1, doc
`AWS-StartPortForwardingSessionToRemoteHost`). Requiere credenciales AWS
activas del usuario — **no abras túneles sin que el usuario lo pida**.

- Postgres DEV: `...cluster-c6jioq0ombbt.us-east-1.rds.amazonaws.com:5432` → local `5437` (ver skill `conectar-bd-gaia`).
- RabbitMQ DEV: `b-73380590-....mq.us-east-1.on.aws:5671` → local `5671`.
- Redis DEV: `dev-core-redis-2qaato.serverless.use1.cache.amazonaws.com:6379` → local `6379` (ElastiCache serverless, **exige TLS**).
  ```bash
  aws ssm start-session --target i-015128a55cf93dba4 \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters '{"host":["dev-core-redis-2qaato.serverless.use1.cache.amazonaws.com"],"portNumber":["6379"],"localPortNumber":["6379"]}' \
    --region us-east-1
  ```
  Verificar: `lsof -nP -iTCP:6379 -sTCP:LISTEN`.

Verificar túneles activos: `lsof -nP -iTCP -sTCP:LISTEN | grep -E '5437|5671|6379'`.

## A. `dev-ms-core-emisiones` (Spring Boot 3.5.4, Gradle, Java 25, perfil `local`)

Comando base: `./gradlew bootRun`. El `.env` versionado lo carga el IDE
(plugin EnvFile) — **desde CLI no se aplica** y además está desactualizado
respecto a `application.properties`. Cargar `.env` + overrides en el mismo
comando (export línea a línea, luego overrides, luego `exec ./gradlew
bootRun --console=plain`).

Errores en el orden en que aparecen y su fix (todo vía overrides, nunca en el `.env` versionado):

1. `ContextPath must start with '/'` → el `.env` no se cargó (`${APP_CONTEXT_EMISION}` sin resolver). Cargarlo.
2. `Could not resolve placeholder 'RABBIT_MQ_TAILL_COASEGUROS'` → faltan ~13 vars que exige `application.properties` y el `.env` no trae. Detectarlas con `comm -23` entre placeholders `${VAR}` sin default y las claves del `.env`. Suplir mínimo: `RABBIT_MQ_QUEUE_CRM/EXCHANGE_CRM/ROUTING_CRM`, `RABBIT_MQ_QUEUE_INTEGRATION`, `CRM_MAX_ATTEMPTS=3`, `CRM_BACKOFF_DELAY=1000`, `FILE_TEMPLATES`, `AGS_KEYCLOAK_CLIENT_SECRET/COOKIE`, `RABBIT_MQ_TAILL_COASEGUROS/FACTURACION/NOVEDADES/REASEGUROS`.
3. `redisConfig.remotePort ... For input string ""` → `REDIS_SECRET_PORT` vacío anula el default. Poner `REDIS_SECRET_PORT=6379`.
4. `redisConnectionFactory: Host must not be empty` → `REDIS_SECRET_HOST` vacío. Poner `REDIS_SECRET_HOST=127.0.0.1` (Lettuce es lazy; arranca aunque Redis no esté arriba).
5. **Fatal real:** `QueuesNotAvailableException` (reply-code 404). Causa: `${spring.rabbitmq.tail.emision}` = `RABBIT_MQ_TAILL_EMISION` vacío → cola anónima que no existe. Fix: `RABBIT_MQ_TAILL_EMISION=dev-mq-core-emision` (patrón `dev-mq-core-*`). `spring.rabbitmq.listener.simple.auto-startup=false` NO sirve — el factory se crea a mano en `config/RabbitConfig.java` sin el configurer de Boot.

Redis en overrides: `REDIS_SECRET_HOST=127.0.0.1`, `REDIS_SECRET_PORT=6379`,
**`REDIS_REMOTE_USE_SSL=true`** (ElastiCache exige TLS; `RedisConfig.java`
desactiva la verificación de peer, así que el TLS al túnel local funciona
pese al mismatch de hostname/cert).

`actuator/health` no está expuesto (handler custom devuelve "No static resource").

**Verificación de arranque OK:** log `Started EmisionesApplication`, puerto
8080 LISTEN, `curl` 200 a `http://localhost:8080/api/emisiones/swagger-ui/index.html`
y a `.../v3/api-docs`.

## B. `dev-ms-core-core` (monolito, Spring Boot 2.7, Java 11, Maven)

**Requisitos (probablemente no instalados):**
- JDK 11: `brew install openjdk@11` (la **fórmula**, no el cask — el cask pide sudo). `JAVA_HOME=/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home`.
- Maven: `brew install maven` (`./mvnw` del repo está roto, faltan `.mvn/wrapper/*`). Correr con `mvn spring-boot:run`.
- RabbitMQ local (5672, vía brew) + túnel a la BD del ambiente objetivo (ver skill `conectar-bd-gaia`).

**Config:** no hay `application-local.properties` versionado. El
`application.properties` exige ~138 `${VAR}`; 59 salen de los `.env` hermanos
(integraciones/emisiones/siniestros), el resto son dummies on-demand. Reglas:
- Los `${VAR:default}` **no** setearlos (dejar el default).
- Respetar tipos: `PRESICION_DECIMAL=2` (int), `APP_CACHE_LOG_LEVEL=INFO` /
  `APP_CACHE_SPRING_LOG_LEVEL=WARN` (enum LogLevel), `APP_CACHE_TYPE=caffeine`,
  `RABBIT_MQ_SSL_ENABLED=false`, puertos numéricos.
- `SARLAFF_URL_FCC` para el mono lleva placeholders `/{documentType}/{documentNumber}`
  (el mono los expande con `UriComponentsBuilder`); para integraciones va la
  base sin placeholders. Ver skill `sarlaft-integraciones`.

Overrides típicos contra QA:
```
RDS_PORT=5438 RDS_USERNAME_APP=generico.qa RDS_PASSWORD_APP=<DB_PASSWORD_QA>
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5438/ebdb?sslmode=require&currentSchema=dbo
APP_PORT=8086 APP_CONTEXT_MONOLITO=/dev/mono
```

Cargar el env sin que el shell interprete `&`/`:` del JDBC URL:
```bash
while IFS='=' read -r k v; do export "$k=$v"; done < mono.env
```

**No fatales al boot:** ruido INFO "Could not safely identify store assignment"
(LDAP/Redis repos); errores TLS de RabbitMQ contra 5672 plano (el publisher
usa `TrustEverythingTrustManager`). LDAP dummy no bloquea (lazy).

**Auth:** JWT HS256 con `jwt.secret=<GAIA_JWT_SECRET>` (base64decode como llave);
claims `subject`=usuario existente en `dbo.usuario`, `user`=usuario_id,
`validate=true`, `exp`. Ver skill `token-qa`.

**Verificación:** `GET /sarlaf/validarFcc` responde 200 (verificado 2026-07-22).

## Notas generales

- Mismo patrón probablemente aplica a `siniestros`/`integraciones`: cargar
  `.env` desde CLI + suplir vars ausentes/vacías.
- Al terminar, **apaga el proceso** (Ctrl+C / matar el bootRun) — no lo dejes
  corriendo de fondo sin avisar al usuario.
