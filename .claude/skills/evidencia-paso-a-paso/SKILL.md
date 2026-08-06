---
name: evidencia-paso-a-paso
description: >-
  Patrón reutilizable para documentar un flujo/wizard multi-paso con
  Playwright: navega el flujo real (QA u otro ambiente), captura CADA paso ya
  diligenciado (con los campos llenos, justo antes de avanzar) — no solo la
  pantalla final — y nombra los archivos de forma consistente. Es la base que
  usan [[radicar-sarlaft-qa]] y [[manual-tecnico]] para su evidencia visual;
  no lo invoques como flujo aparte, referéncialo desde el skill que necesite
  capturar un flujo. Dispara con "captura cada paso", "pantallazos del flujo
  completo", "/evidencia-paso-a-paso".
---

# Evidencia paso a paso (Playwright)

Patrón base para documentar un flujo/wizard con capturas de pantalla, evitando
el error de capturar solo la pantalla final y perder el "cómo se llegó ahí".

## Regla central

Por cada paso del flujo: **diligencia los campos → toma la captura → luego
avanza** ("Continuar"/"Siguiente"). Nunca captures un paso vacío ni saltes
directo al resultado final — la evidencia debe reconstruir el recorrido
completo, paso a paso.

## Herramientas (Playwright MCP)

`browser_navigate`, `browser_snapshot` (usa `target`/`depth` para no traer todo
el árbol), `browser_click`, `browser_type`, `browser_fill_form`,
`browser_take_screenshot` (`fullPage` en pasos largos), `browser_network_requests`
/`browser_network_request` (para depurar 400/401 de cada paso),
`browser_console_messages`.

## Procedimiento

1. Define el **nombre base** de la captura antes de empezar (ver convención de
   nombres de [[manual-tecnico]] si la evidencia va a un Manual Técnico:
   `{proyecto}_{modulo}_{hu}`; si es una captura puntual, un nombre corto
   descriptivo del flujo).
2. Navega al punto de entrada del flujo.
3. Por cada paso: `browser_snapshot` → llena los campos → `browser_snapshot` de
   verificación (que quedó bien diligenciado) → `browser_take_screenshot`
   (ANTES de continuar) → click "Continuar"/"Siguiente".
4. Nombra cada captura `<base> - pasoN.png` (N en orden). Guárdala directo en
   el destino final:
   - Si es evidencia efímera/puntual → scratchpad de la sesión.
   - Si va a un entregable (Manual Técnico) → la carpeta del anexo de la HU/bug
     (ver [[manual-tecnico]]), no en scratchpad (evita el paso extra de mover).
5. Si un paso falla (400/401, "ref not found", backdrop que intercepta), vuelve
   a hacer `browser_snapshot` y reintenta con el ref fresco — los `ref` de
   componentes Quasar (selects, diálogos) cambian en cada render.
6. Al terminar, **lista las capturas tomadas** y confirma que cubren TODOS los
   pasos del flujo, no solo el último.

## Reglas

- Nunca captures solo la pantalla final "para ahorrar tiempo" — el objetivo es
  dejar evidencia completa y reproducible de cómo se llegó al resultado.
- No finalices acciones irreversibles del flujo (ej. generar un radicado real)
  salvo que el usuario lo pida explícitamente — los límites de cada flujo
  concreto los define su propia skill (ej. [[radicar-sarlaft-qa]] dice
  explícitamente no avanzar más allá del paso 6).
- El login (usuario/clave + reCAPTCHA) normalmente lo hace el usuario a mano en
  la ventana de Playwright — no es automatizable; espera su confirmación antes
  de empezar a capturar.

**Usado por:** [[radicar-sarlaft-qa]] (wizard de radicación hasta el paso
Sarlaft), [[manual-tecnico]] (evidencia de frontend por HU/bug). Relacionado:
memoria [[pantallazos-por-paso-wizard]].
