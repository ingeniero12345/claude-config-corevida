---
name: documento-maestro
description: >-
  Contexto integral del proyecto CORE GAIA (Positiva / CoreVida): negocio,
  módulos funcionales, arquitectura de solución, microservicios, integraciones,
  gobierno y soporte. Úsalo SIEMPRE al arrancar una sesión para orientarte, y
  cada vez que necesites entender qué es GAIA, qué ramos/productos hay, qué
  módulo hace qué, cómo se llama un microservicio, dónde está clonado un repo,
  con qué sistemas externos integra (CRM/SAP/SARLAFT/SGDEA...) o cómo se
  gestiona el proyecto. También al preguntar "documento maestro", "contexto del
  proyecto", "arquitectura GAIA", "/documento-maestro".
---

# Documento Maestro — Core Asegurador GAIA (Positiva)

Guía integral de negocio, funcional, arquitectura e integraciones del proyecto
**CORE GAIA** (LinkTIC para Positiva). Es la referencia de onboarding y consulta.

## Cómo usar este skill

1. El detalle completo está en **[`documento-maestro.md`](documento-maestro.md)**
   (10 capítulos). **Léelo cuando** necesites profundidad sobre un tema; no hace
   falta cargarlo entero para preguntas puntuales que ya resuelve el resumen de abajo.
2. Para ubicar un tema, ve directo al capítulo:

| Cap. | Tema | Cuándo consultarlo |
|---|---|---|
| 1 | Introducción y contexto | Qué es GAIA, objetivo, alcance, beneficios. |
| 2 | Glosario y siglas | Términos aseguradores (tomador, prima, RSOA…). |
| 3 | Modelo de negocio | Capacidades, cadena de valor, dominios funcionales. |
| 4 | Productos de seguros | Ramos/productos en alcance, amparos, parametrización. |
| 5 | Módulos funcionales | Qué hace cada módulo de la app (Cotización→Siniestros…). |
| 6 | Arquitectura de solución | Microservicios, stack, AWS, ambientes, **repos**. |
| 7 | Integraciones | CRM, SAP, SARLAFT, SGDEA, APIs que expone/consume CORE. |
| 8 | Gobierno y metodología | Contratos, hitos, roadmap, riesgos. |
| 9 | Mesa de servicios | Soporte, ANS/SLA, ciclo del ticket. |
| 10 | Anexos | Índice de documentos fuente y trazabilidad. |

## Estructura local (esta máquina)

Base: `/Users/hernannieto/Documents/TemasCorporativos`. Al referirte a código,
usa **la ruta local**, no el nombre del VCS del documento.

**Backend (`backend/`)** — clonados localmente:
- `dev-ms-core-core` — orquestador (repo VCS `Core-core`)
- `dev-ms-core-emisiones` — emisiones (`Core-emisiones`)
- `dev-ms-core-integraciones` — integraciones (`Core-integracion`)
- `dev-ms-core-reporteria` — reportería (`Core-reportera`)
- `dev-ms-core-siniestros` — siniestros (`Core-siniestros`)
- `dev-ms-core-siniestros-v2` — siniestros v2

**Frontend (`frontend/`)**:
- `dev-web-front-core` — front principal Quasar+Vue3+TS (repo VCS `Front_Core`)
- `dev-web-front-core-siniestros` — front de siniestros

**Otros**: `Documentos HUs/`, `CONTEXTO-*.md` (handoffs), `scripts/`, `*.sql`, `*.http`.

> ⚠️ Los demás microservicios del SAD (cotización, facturación, cartera,
> reaseguros, reservas, producto, políticas, novedades, login, jobs) **existen
> en el VCS pero NO están clonados** en esta máquina. Las rutas `assets/*` y las
> carpetas de documentación (`02. Negocio/`, `04.Producto - Funcional/`, etc.)
> del documento son del repo de documentación fuente, no locales.

## Reglas rápidas (ver también CLAUDE.md)

- Perfiles/roles se detectan por **permiso** (`authStore.permisos`), no por id.
- Backend suele devolver listas en `null`: protege `.map/.find/.flat` con `Array.isArray(x) ? x : []`.
- Errores de backend/Swagger/500/SQL/CORS: indícalos, no los "arregles" en el front.
