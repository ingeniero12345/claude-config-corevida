# Plantilla oficial de Manual Técnico (referencia: HU635)

Fijada como formato obligatorio para todo backend, **ahora y en el futuro**
(pedido explícito del usuario, 2026-08-05, adjuntando el PDF de HU635 "Enviar
soporte de pago ISARL - GAIA"). `scaffold_manual.py` y `template-base.docx`
ya generan este formato por defecto — no reconstruir a mano salvo que se
este corrigiendo un manual viejo desalineado.

## Header de pagina (tabla 2 filas x 3 columnas, SIN merge vertical)

| [logo POSITIVA] | PROCESO:<br>{título} | Versión: 1<br>Clasificación: Pública<br>Fecha: {fecha}<br><br>FORMATO |
|---|---|---|
| Aprobó: | Revisó: | Elaboró: {nombre} |

Esta info vive **solo** en el header — no se repite como tabla en el cuerpo. El logo
de la celda 1 ya está embebido en `template-base.docx` (se conserva al copiar la
plantilla); una copia suelta del mismo logo vive en `logo-positiva.png` (misma
carpeta del skill) para reutilizarlo en la portada.

## Portada (antes del índice)

Después del header de página, la portada es **solo**:
1. Espacio en blanco.
2. El logo grande de POSITIVA centrado (`logo-positiva.png`, ancho ~2.2in).
3. Espacio en blanco.
4. `Manual Tecnico` — centrado, negrita.
5. `{HU} - {título}` — centrado, negrita (ej. `HU865 - Cargue de pruebas o
   reconsideracion de la reclamacion`).
6. Salto de página.

**NO lleva ninguna tabla de metadatos adicional** (nada de "Historia de
Usuario/Bug", "Repositorio(s)", "Tipo de cambio" en la portada — eso fue un
error de una versión anterior del scaffold, corregido 2026-08-05). Si esos
datos de seguimiento interno hacen falta, van en "Notas y discrepancias", no
en la portada.

`scaffold_manual.py` ya genera exactamente esto — verificado visualmente
(render real con `qlmanage -t`, no solo lectura de estructura con
python-docx) contra el manual de HU865, 2026-08-05.

## Estructura del cuerpo

1. **Información General del Servicio** — Nombre del Servicio, Proveedor,
   Consumidor, Método HTTP, URL Base {ENV}, Endpoint, Content-Type, Encoding.
2. **Descripción del Servicio** — párrafo de prosa (qué hace y por qué).
3. **Especificación del Request**
   - 3.1 Headers Requeridos
   - 3.2 Estructura del Request Body (ejemplo JSON real)
   - 3.3 Validaciones de Entrada — **tabla**, columnas exactas:
     `Campo | Tipo | Longitud | Obligatorio | Validaciones`
4. **Especificación del Response** — subsecciones numeradas independientes:
   - 4.1 Response Exitoso (HTTP 200)
   - 4.2 Response con Error de Negocio (HTTP 404 o el código real que aplique)
   - 4.3 Response con Error de Validación (HTTP 400)
   - agregar 4.4, 4.5... si hay más casos relevantes (autenticación,
     comunicación con otro servicio, etc.)
   - cada subsección con ejemplo JSON real (no inventado)
5. **Códigos de Respuesta HTTP** — **tabla**, columnas exactas:
   `Código | Descripción | Escenario`. Filas base (siempre): 200, 400, 401,
   404, 500, 503; agregar 409 (u otros) si el servicio los usa realmente.
6. **Catálogo de Mensajes Funcionales** (opcional; omitir si el servicio no
   maneja códigos propios tipo MB-xx)
7. **Arquitectura y Flujo** — decisiones de implementación (capas, clases,
   gateways, decisiones de diseño) — contexto adicional DESPUÉS de la spec,
   no antes.

## Notas

- Frontend (sin contrato REST propio) NO usa este formato — sigue con
  evidencia paso a paso (ver skill `evidencia-paso-a-paso`).
- Manuales viejos con header/tablas desalineadas se corrigen uno por uno al
  retomar esa HU/bug, conservando el contenido real ya redactado.
