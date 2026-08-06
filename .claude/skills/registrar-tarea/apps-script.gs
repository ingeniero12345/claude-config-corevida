/**
 * Web App para registrar tareas en la hoja "actividades".
 *
 * DESPLIEGUE (una sola vez):
 *  1. Abre la hoja:
 *     https://docs.google.com/spreadsheets/d/<TU_SHEET_ID>/edit
 *  2. Menú: Extensiones > Apps Script.
 *  3. Borra el contenido y pega TODO este archivo.
 *  4. Cambia SECRET por una cadena tuya (la misma que pondrás en webapp-url.txt).
 *  5. Guarda (💾).
 *  6. Implementar > Nueva implementación > Tipo: "Aplicación web".
 *       - Ejecutar como: "Yo (tu cuenta)".
 *       - Quién tiene acceso: "Cualquier usuario".
 *     Implementar > Autoriza los permisos.
 *  7. Copia la "URL de la aplicación web" (termina en /exec).
 *  8. Guárdala junto al secret en:
 *     ~/.claude/skills/registrar-tarea/webapp-url.txt
 *     (primera línea = URL, segunda línea = SECRET)
 */

var SHEET_ID = '<TU_SHEET_ID>';
var GID = 0;                    // pestaña destino
var SECRET = '<UN_SECRETO_TUYO>';

// Diagnóstico: un GET a /exec devuelve la config en vivo de esta implementación.
function doGet(e) {
  return json_({ ok: true, sheetId: SHEET_ID, gid: GID });
}

function doPost(e) {
  try {
    var body = JSON.parse(e.postData.contents);
    if (body.secret !== SECRET) {
      return json_({ ok: false, error: 'secret invalido' });
    }
    var ss = SpreadsheetApp.openById(SHEET_ID);
    var sheet = ss.getSheets().filter(function (s) {
      return s.getSheetId() === GID;
    })[0] || ss.getSheets()[0];   // fallback: primera pestaña
    if (!sheet) return json_({ ok: false, error: 'hoja sin pestañas' });

    // Columnas: A=fecha, B=actividad, C=(vacía), D=numero, E=descripcion
    var fila = [
      body.fecha || '',
      body.actividad || '',
      '',
      body.numero || '',
      body.descripcion || ''
    ];
    sheet.appendRow(fila);
    var added = sheet.getLastRow();
    ordenarPorFecha_(sheet);          // reordenar por fecha en cada alta
    return json_({ ok: true, fila: added });
  } catch (err) {
    return json_({ ok: false, error: String(err) });
  }
}

/**
 * Ordena las filas por la columna A (fecha, formato YYYY-MM-DD → orden
 * cronológico correcto), DESCENDENTE: la fecha más reciente arriba.
 * Respeta una fila de encabezado si A1 == 'fecha'.
 */
function ordenarPorFecha_(sheet) {
  var last = sheet.getLastRow();
  var start = 1;
  if (String(sheet.getRange(1, 1).getValue()).toLowerCase() === 'fecha') start = 2;
  var n = last - start + 1;
  if (n < 2) return;
  sheet.getRange(start, 1, n, 5).sort({ column: 1, ascending: false });
}

/** Resuelve la pestaña destino y la ordena (usada por el trigger diario). */
function ordenarHojaDiario() {
  var ss = SpreadsheetApp.openById(SHEET_ID);
  var sheet = ss.getSheets().filter(function (s) {
    return s.getSheetId() === GID;
  })[0] || ss.getSheets()[0];
  if (sheet) ordenarPorFecha_(sheet);
}

/**
 * EJECUTA ESTO UNA SOLA VEZ (menú Run, seleccionando esta función) para
 * instalar el proceso diario que ordena la hoja por fecha en el servidor.
 * Borra triggers previos para no duplicar.
 */
function crearTriggerDiario() {
  ScriptApp.getProjectTriggers().forEach(function (t) {
    if (t.getHandlerFunction() === 'ordenarHojaDiario') ScriptApp.deleteTrigger(t);
  });
  ScriptApp.newTrigger('ordenarHojaDiario')
    .timeBased().everyDays(1).atHour(6).create();
}

function json_(obj) {
  return ContentService
    .createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}
