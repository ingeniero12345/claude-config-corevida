---
name: radicar-sarlaft-qa
description: >-
  Recorre en el navegador (Playwright) el wizard de radicación de reclamaciones del front CORE en QA
  (corevida-qa-v2) hasta el PASO 6 "Sarlaft" para ver/capturar el panel de Información SARLAFT
  (InformacionSarlaft.vue). Incluye los atajos y las reglas de negocio que bloquean el flujo. Úsalo
  cuando pidan "pantallazo SARLAFT", "llegar al paso Sarlaft", "probar el diligenciamiento SARLAFT en
  el front", "/radicar-sarlaft-qa". NO finaliza la radicación (no genera radicado).
---

# Radicar hasta el paso SARLAFT (QA) — guía rápida

Objetivo: llegar al **paso 6 "Sarlaft"** del wizard `ReclamacionStepperV3` (`AgregarSolicitud.vue`,
componente `InformacionSarlaft.vue`) y capturar el panel. El panel consume
`GET /api/integraciones/api/sarlaft/consulta` y, si el reclamante no tiene FCC, muestra el botón
**"Relanzar diligenciamiento SARLAFT"** (`POST /api/sarlaft/enviar-diligenciamiento`).

> El paso Sarlaft SOLO existe dentro del wizard de radicación (no hay ruta de solo-lectura para una
> reclamación ya radicada). Por eso hay que recorrer los pasos 1–5.

## Prerrequisitos
- Herramientas Playwright MCP disponibles (`browser_navigate`, `browser_snapshot`, `browser_click`,
  `browser_type`, `browser_fill_form`, `browser_take_screenshot`, `browser_network_requests/request`,
  `browser_console_messages`).
- El usuario debe **loguearse manualmente** en la ventana de Playwright: navega a
  `https://corevida-qa-v2.linktic.com`, pídele que ingrese usuario/clave y resuelva el **reCAPTCHA**
  (no automatizable). Espera su "listo" y confirma con un snapshot que la URL es `/home`.
- Túnel a BD QA en `127.0.0.1:5438` para elegir datos válidos (usuario `generico.qa`, ver memoria
  [[db-gaia-credenciales]]). `psycopg2` en python3 (no hay psql).
- Guarda los pantallazos en el **scratchpad de la sesión**, NO en la raíz del repo (evita clutter);
  luego se pueden embeber en el .docx con python-docx (`document.add_picture`).

## Elegir datos válidos (crítico — evita 2 bloqueos)
Consulta QA antes de empezar. Dos reglas de negocio del backend bloquean la radicación:
1. **No duplicar**: no puede existir otra reclamación con misma `numero_poliza` + `numero_documento_asegurado`
   + `fecha_evento`. → usa una **fecha de evento única** (que no choque con reclamaciones previas del asegurado).
2. **Amparo no repetido**: el asegurado **no puede** reclamar un amparo que ya usó
   (`POST Amparos/eventos/save` → 400 "El asegurado ya utilizó el amparo '<X>'"). → elige un amparo NUEVO.

```python
import psycopg2
c=psycopg2.connect(host="127.0.0.1",port=5438,dbname="ebdb",user="generico.qa",
                   password="<DB_PASSWORD_QA>",sslmode="require").cursor()
# póliza SALUD con asegurado persona (CC) ya conocida:
#   POLIZA=SA3510003179  ASEGURADO/RECLAMANTE=CC 1082884011 (EDWIN CARDENAS)
# amparos que el asegurado YA usó (elige uno que NO aparezca aquí):
c.execute("""select tipo_amparo, causas, count(*) from dbo.reclamacion_siniestrada
             where numero_documento_asegurado='1082884011' group by tipo_amparo, causas""")
print(c.fetchall())
```
Mapa causa → amparo (parametrización SALUD, útil para elegir uno libre):
- **Defecto visual** → motivo Genérico → **AUXILIO DE LENTES**  (suele estar libre)
- Enfermedad general / Accidente* / Ahogamiento → Genérico → RENTA DIARIA POR HOSPITALIZACIÓN
- Enfermedad o control medico / Accidente y/o urgencia → Consulta externa|Urgencia → GASTOS MEDICOS
- Cirugia → Alta/Baja complejidad... → GASTOS MEDICOS COMPLICACIONES EN CIRUGIA

## Recorrido del wizard (atajos)
Abre `https://corevida-qa-v2.linktic.com/reclamos/agregar`. Tras cada acción, `browser_snapshot`
(usa `target`/`depth` para no traer todo el árbol). Los `<select>` de Quasar abren un `listbox` a nivel
raíz; haz snapshot con `target` del listbox para leer sus `option`s.

1. **Rol** → "Reclamante, Siniestrado".
2. **Paso 1 (Póliza)**: Ramo=SALUD. Escribe **Número de Póliza** (SA3510003179) y sal del campo →
   abre diálogo *"Usted cuenta con las siguientes pólizas"* → click en **Seleccionar** (chevron) →
   diálogo *"¿Desea afectar la póliza…?"* → **OK**. Eso **autocompleta tomador y producto** (el buscador
   de tomador NO funciona por nombre). Luego: Tipo doc asegurado=Cédula de Ciudadanía, Número=1082884011
   (reabre el diálogo de pólizas; ciérralo con **Cerrar**). ¿apoderado?=**No**, ¿misma siniestrada?=**Si**,
   ¿fallecimientos?=**No**. Continuar.
3. **Paso 2 (Reclamante)**: Tipo doc=Cédula de Ciudadanía + Número=1082884011 → **autocompleta** nombres,
   sexo, correo, fecha de nacimiento (readonly). Completa lo que falte: Correo (si vacío), **Dirección**,
   **Teléfono móvil**, **Departamento** (BOGOTÁ, D.C.), **Ciudad** (BOGOTA D.C.). Tipo de persona suele venir
   "PERSONA NATURAL". Continuar.
4. **Paso 3 (Beneficiario)**: "Agregar beneficiario" está deshabilitado (reclamante=siniestrado) → Continuar.
5. **Paso 4 (Evento)**: Fecha evento **única** (p.ej. 2026-07-10), Hora (10:00), Departamento/Ciudad
   (BOGOTÁ / BOGOTA D.C.), Medio de declaración=Portal Web, Tipo de declarante=Asegurado,
   **Causa → Motivo → Amparo** (amparo NO usado por el asegurado, p.ej. Defecto visual → Genérico →
   AUXILIO DE LENTES), Descripción. Pulsa **"Agregar amparo"** y verifica que aparezca en la tabla
   "Listado de amparos agregados" (si sale 400, revisa `browser_network_request` response-body: casi
   siempre es la regla de duplicado o de amparo repetido). Continuar.
6. **Paso 5 (Medios de pago)**: Abono a cuenta bancaria → Tipo=Ahorros, Banco=Bancolombia,
   Número=12345678901. Continuar.
7. **Paso 6 (Sarlaft)**: aquí está el panel. `browser_take_screenshot` de la página completa y otro con
   `target` del panel (elemento "Información Sarlaft"). Si el reclamante no tiene FCC, verás
   "El reclamante no cuenta con FCC…" y el botón **Relanzar diligenciamiento SARLAFT**.

## Capturas por paso (requerido)
Sigue el patrón general de [[evidencia-paso-a-paso]]: captura CADA paso ya diligenciado, justo **antes**
de pulsar "Continuar". Es decir: paso 1 lleno, paso 2 lleno, … paso 5 lleno, y el paso 6 (Sarlaft).
Nómbralos `sarlaft-paso1.png … sarlaft-paso6.png` en el scratchpad. Si un paso es largo, captura `fullPage`.

## IMPORTANTE
- **No finalices la radicación**: no avances a paso 7/8 ni pulses "Generar radicado". Queda un borrador
  en QA en estado "PROCESO DE RADICACIÓN" (aceptable como registro de prueba); ofrécele al usuario anularlo.
- Al radicar, el backend crea la reclamación (obtiene un `id`) y dispara la consulta SARLAFT, que se
  persiste en `dbo.sarlaft_consulta` (verificable por `reclamacion_id`). Resultado típico sin FCC:
  `without_forms` / "Sin formularios" / sin PDF.
- Los `option`/`listbox`/diálogos de Quasar cambian de `ref` en cada snapshot; si un click falla por
  "ref not found" o backdrop que intercepta, vuelve a hacer snapshot y reintenta con el ref fresco.
- Guarda capturas en el scratchpad de la sesión, no en la raíz del workspace.

Relacionado: contrato del servicio en el Manual Técnico SARLAFT (HU 295592 / 416_SIN_HU762) y memorias
[[sarlaft-conexion-red5g]], [[sarlaft-fcc-endpoints]], [[reclamaciones-consulta-qa-v2]].
