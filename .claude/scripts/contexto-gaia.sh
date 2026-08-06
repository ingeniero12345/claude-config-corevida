#!/bin/bash
# SessionStart hook: inyecta un puntero ligero al contexto del proyecto GAIA.
# El documento completo vive en el skill `documento-maestro`; aquí solo damos
# el resumen mínimo + la instrucción de consultarlo cuando haga falta.

read -r -d '' CTX <<'EOF'
[Proyecto CORE GAIA — Positiva / CoreVida] Core asegurador multi-ramo (LinkTIC para Positiva) sobre AWS: ciclo de vida de pólizas (cotización→suscripción→emisión→administración→recaudo/cartera→siniestros→reaseguro/coaseguro→reservas→analítica). Microservicios Spring Boot (Java 17+) + front Quasar/Vue3+TS, RabbitMQ, PostgreSQL, Redis. Integra con CRM (Wimbu/Odoo), SAP (SOAP/RFC), SARLAFT (Red5G), SGDEA, Registraduría, RUES.

Repos clonados localmente en /Users/hernannieto/Documents/TemasCorporativos:
- backend/: dev-ms-core-core, dev-ms-core-emisiones, dev-ms-core-integraciones, dev-ms-core-reporteria, dev-ms-core-siniestros, dev-ms-core-siniestros-v2
- frontend/: dev-web-front-core, dev-web-front-core-siniestros

Para el detalle completo (negocio, módulos, arquitectura, integraciones, gobierno, soporte) INVOCA el skill `documento-maestro` — no lo cargues entero salvo que la tarea lo requiera.
EOF

# Escapar para JSON de forma segura con python3.
python3 - "$CTX" <<'PY'
import json, sys
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": sys.argv[1]
    }
}))
PY
