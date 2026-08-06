# 📘 Documento Maestro — Core Asegurador GAIA (Positiva)

> **Guía integral de negocio, funcional, arquitectura e integraciones del proyecto CORE GAIA.**
> Documento de referencia interno de **LinkTIC S.A.S.** · Foco principal: equipos de desarrollo · Útil para todos los roles del proyecto.

| | |
|---|---|
| **Proyecto** | Core Asegurador **GAIA** — Transformación del Core de Seguros |
| **Cliente** | Positiva Compañía de Seguros S.A. (Colombia) |
| **Proveedor / Implementador** | LinkTIC S.A.S. |
| **Identificador interno** | Proyecto 416 — "Core Positiva" |
| **Infraestructura** | AWS (nube) |
| **Naturaleza** | Plataforma core asegurador multi-ramo, parametrizable y orientada a servicios |
| **Última actualización del documento** | 2026-06-16 |

> ℹ️ **Cómo usar este documento.** Está pensado para leerse de principio a fin en el primer onboarding, y luego como referencia por capítulos. Cada capítulo es autocontenido. Los diagramas grandes se incluyen en versión web; los originales en alta resolución están en las carpetas fuente del repositorio (ver Anexos).

---

## 🗂️ Tabla de contenido

1. [Introducción y contexto](#1-introducción-y-contexto)
2. [Glosario y siglas](#2-glosario-y-siglas)
3. [Modelo de negocio](#3-modelo-de-negocio)
4. [Productos de seguros](#4-productos-de-seguros)
5. [Módulos funcionales](#5-módulos-funcionales)
6. [Arquitectura de solución](#6-arquitectura-de-solución)
7. [Integraciones](#7-integraciones)
8. [Gobierno, gestión y metodología](#8-gobierno-gestión-y-metodología)
9. [Mesa de servicios y soporte](#9-mesa-de-servicios-y-soporte)
10. [Anexos](#10-anexos)

---

# 1. Introducción y contexto

## 1.1 ¿Qué es CORE GAIA?

**CORE GAIA** es la nueva plataforma **core asegurador** que LinkTIC desarrolla e implementa para **Positiva Compañía de Seguros**. Su propósito es soportar de forma **integral, trazable y escalable** todo el **ciclo de vida de las pólizas** de los distintos ramos y productos aseguradores de Positiva:

> **Cotización → Suscripción → Emisión → Administración (novedades) → Recaudo y cartera → Siniestros → Reaseguro/Coaseguro → Reservas → Analítica.**

A diferencia de una operación apoyada en procesos manuales y sistemas dispersos, GAIA consolida estas capacidades en una arquitectura empresarial orientada a **dominios funcionales** y **capacidades de negocio**, ejecutada sobre **infraestructura AWS** e integrada con el ecosistema corporativo de Positiva (SAP, CRM, gestión documental, facturación electrónica y servicios regulatorios).

## 1.2 Las partes

| Parte | Rol |
|---|---|
| **Positiva Compañía de Seguros S.A.** | Cliente y dueño del negocio. Aseguradora estatal colombiana, fuerte en riesgos laborales (ARL), vida y salud. Define necesidades, aprueba historias de usuario y opera el sistema. |
| **LinkTIC S.A.S.** | Proveedor tecnológico. Diseña, construye, integra, prueba y soporta la plataforma GAIA. Responsable de la arquitectura de negocio, funcional y de solución. |

La relación contractual se ha desarrollado en **tres contratos consecutivos y un otrosí**, correspondientes a fases sucesivas de implementación del sistema (ver [Capítulo 8](#8-gobierno-gestión-y-metodología)).

## 1.3 Contexto del negocio asegurador

Positiva opera dentro de un ecosistema asegurador que exige **trazabilidad**, **continuidad operativa**, **gestión integral del riesgo** y **control** sobre todos los procesos asociados al ciclo de vida de pólizas, clientes, siniestros y recaudo. La transformación busca fortalecer las capacidades de negocio y tecnología para soportar estos procesos de manera **integrada, escalable y gobernada**, habilitando un modelo operativo moderno orientado a procesos, integraciones y capacidades de negocio.

## 1.4 Objetivo del proyecto

> **Objetivo general:** estructurar y consolidar una arquitectura empresarial y tecnológica que soporte los procesos *core* de seguros, optimizando la operación funcional, la trazabilidad documental, la gestión de clientes y la parametrización de productos aseguradores.

El modelo operativo objetivo (TO-BE) se sustenta en seis pilares:

- **Centralización** de la información del negocio.
- **Automatización** de procesos clave (cotización, emisión, siniestros, recaudo).
- **Integración** entre áreas funcionales y sistemas corporativos.
- **Gobierno documental** y trazabilidad operativa de extremo a extremo.
- **Escalabilidad** funcional y tecnológica (modelo multi-ramo).
- **Toma de decisiones basada en datos** (analítica e indicadores).

## 1.5 Procesos core incluidos en el alcance

El proyecto contempla capacidades y procesos relacionados con:

- Gestión de clientes y tomadores
- Cotización de productos aseguradores
- Suscripción (evaluación de riesgo)
- Emisión de pólizas
- Renovaciones y endosos (novedades)
- Gestión documental
- Gestión de siniestros y reclamaciones
- Recaudo y cartera
- Gestión de comisiones e intermediarios
- Reaseguro y coaseguro
- Reservas técnicas
- Auditoría y trazabilidad
- Parametrización de productos y coberturas
- Gobierno operativo y regulatorio (SARLAFT y listas restrictivas)

## 1.6 Beneficios esperados

| Beneficio | Detalle |
|---|---|
| 🔻 **Reducción de tareas manuales** | Meta: **> 70 %** de reducción. |
| ⚡ **Mayor eficiencia operativa** | Menores tiempos de respuesta en cotización, emisión y siniestros. |
| ✅ **Reducción de errores humanos** | Automatización y validaciones sistemáticas. |
| 🔎 **Mayor trazabilidad** | Seguimiento end-to-end de procesos, datos y transacciones. |
| 🔗 **Integración de sistemas** | Interoperabilidad con SAP, CRM, gestión documental, etc. |
| 🧩 **Centralización de productos** | Catálogo asegurador parametrizable y unificado. |

## 1.7 Riesgos y desafíos identificados

- Dependencia de conocimiento especializado (negocio asegurador).
- Trazabilidad documental históricamente distribuida.
- Complejidad de las integraciones (especialmente SAP y terceros).
- Evolución funcional continua y cambios de alcance.
- Dependencias regulatorias.
- Gestión del cambio organizacional.
- Necesidad de alineación permanente entre negocio y tecnología.

---

# 2. Glosario y siglas

Este glosario unifica los términos aseguradores, funcionales y técnicos usados en el proyecto. Es la **base conceptual común** entre negocio, operación y tecnología; conviene leerlo antes de los capítulos funcionales.

## 2.1 Actores del negocio asegurador

| Término | Definición |
|---|---|
| **Tomador** | Persona natural o jurídica que adquiere la póliza y asume la obligación de pago de la prima. |
| **Asegurado** | Persona o entidad cubierta por el seguro y expuesta al riesgo. |
| **Beneficiario** | Persona o entidad que recibe la indemnización en caso de siniestro. |
| **Cliente** | Actor genérico que puede representar al tomador, asegurado o beneficiario según el proceso. |
| **Intermediario** | Canal de comercialización (agente, corredor) que gestiona la venta y asesoría del seguro. |
| **Aseguradora** | Entidad que asume el riesgo y emite la póliza (Positiva). |
| **Reaseguradora** | Entidad que comparte/asume parte del riesgo transferido por la aseguradora. |
| **Coaseguradora** | Aseguradora que participa, junto con otras, en la cobertura de un mismo riesgo con un porcentaje definido. |
| **Aliados / Proveedores** | Entidades externas que apoyan la operación (hospitales, clínicas, ajustadores, talleres, asistencias). |

## 2.2 Conceptos del negocio

| Término | Definición |
|---|---|
| **Ramo** | Clasificación regulatoria y comercial que agrupa productos según el tipo de riesgo cubierto. |
| **Producto** | Conjunto de coberturas y condiciones comerciales ofrecidas dentro de un ramo. |
| **Póliza** | Contrato que formaliza la cobertura de un riesgo entre aseguradora y tomador. |
| **Cobertura / Amparo** | Protección específica frente a un riesgo definido. |
| **Tasa** | Base numérica (por mil, por ciento o en pesos) usada para calcular la prima. |
| **Prima** | Valor monetario que el tomador paga por la cobertura. |
| **Vigencia** | Período durante el cual la póliza mantiene cobertura activa. |
| **Reserva técnica** | Monto provisionado para cubrir obligaciones futuras. |

## 2.3 Procesos del ciclo de vida

| Término | Definición |
|---|---|
| **Cotización** | Propuesta de seguro basada en la simulación de prima y condiciones. |
| **Suscripción (Underwriting)** | Proceso de evaluación del riesgo para aceptar o rechazar una póliza. |
| **Tarificación** | Definición del precio del seguro basada en el riesgo. |
| **Emisión** | Proceso desde la solicitud hasta la generación de la póliza. |
| **Validación SARLAFT** | Verificación en listas restrictivas (cumplimiento antilavado). |
| **Listas restrictivas** | Bases de datos para validar riesgos de lavado de activos. |
| **Cálculo de prima** | Determinación del valor del seguro. |
| **Validación de prima** | Comparación entre la prima cotizada y la calculada. |
| **Novedades (Endosos)** | Cambios posteriores a la emisión; pueden generar o no prima (cobro o devolución). |
| **Endoso** | Modificación formal de una póliza vigente. |
| **Renovación** | Extensión de la vigencia de la póliza. |
| **Cancelación** | Terminación anticipada del contrato. |

## 2.4 Gestión financiera

| Término | Definición |
|---|---|
| **Recaudo** | Proceso de recepción de pagos. |
| **Facturación** | Generación de documentos de cobro. |
| **Comisiones** | Pagos a intermediarios por las ventas. |
| **Cartera** | Estado de las obligaciones del cliente (facturado, recaudado, pendiente). |
| **Edad de cartera** | Clasificación de la deuda según el tiempo de mora. |
| **Remesa** | Transferencia de dinero entre aseguradoras/reaseguradoras (coaseguro/reaseguro). |
| **Cuenta por pagar (reaseguro)** | Obligación financiera con reaseguradores. |
| **Corte de cuentas** | Proceso pactado con intermediarios o reaseguradores para liquidar periodos de comisiones o contratos. |

## 2.5 Siniestros

| Término | Definición |
|---|---|
| **Siniestro** | Evento en el cual ocurre el riesgo asegurado. |
| **Aviso de siniestro** | Notificación del evento por parte del cliente. |
| **Evaluación de siniestro** | Validación de cobertura y análisis del evento. |
| **Liquidación** | Determinación del valor a pagar. |
| **Reserva de siniestro** | Valor estimado para cubrir un siniestro reportado. |
| **Indemnización** | Pago realizado al beneficiario cuando ocurre un siniestro cubierto. |
| **Pago de siniestro** | Desembolso al beneficiario. |
| **Objeción** | Decisión de rechazo total o parcial del pago asociado a un siniestro. |

## 2.6 Conceptos avanzados de riesgo

| Término | Definición |
|---|---|
| **Reaseguro** | Transferencia parcial del riesgo a una reaseguradora. |
| **Coaseguro** | Participación de varias aseguradoras en un mismo riesgo. |
| **Coaseguradora líder (Cedido)** | Aseguradora que administra la póliza frente al cliente. |
| **Coaseguradora no líder (Aceptado)** | Aseguradora que participa sin administrar la relación directa. |
| **Participación en coaseguro** | Porcentaje del riesgo asumido por cada aseguradora. |
| **Cesión** | Porcentaje o valor del riesgo y prima transferido a otra aseguradora o reaseguradora. |
| **Retención** | Porción del riesgo que la aseguradora asume directamente sin transferir. |
| **Co-corretaje** | Distribución de la comisión de una póliza entre más de un intermediario. |

## 2.7 Términos funcionales y de proyecto

| Término | Definición |
|---|---|
| **CRM** | Sistema de gestión de relaciones con clientes y cotizaciones. Integración principal de GAIA. |
| **Backlog** | Listado priorizado de requerimientos funcionales y técnicos. |
| **Historia de Usuario (HU)** | Necesidad funcional expresada desde la perspectiva del usuario. |
| **Épica (Epic)** | Agrupador funcional de historias de usuario relacionadas. |
| **Capacidad** | Habilidad de negocio o tecnología que soporta una función organizacional. |
| **Parametrización** | Configuración funcional del sistema sin desarrollo de código. |
| **Maestros** | Información base y estructurada utilizada transversalmente. |
| **CDP (Certificado de Disponibilidad Presupuestal)** | Documento de la contratación pública colombiana que **certifica que existe presupuesto disponible** para respaldar un gasto/compromiso. En GAIA aplica en dos contextos: (1) el campo *"¿Tiene CDP?"* de la póliza cuando el **tomador es entidad pública** (requiere partida para pagar la prima); (2) los CDP que respaldan el **propio contrato** LinkTIC–Positiva (p. ej. `C15212025`, `C15172026`), con su código y vigencia fiscal. |
| **Integración** | Comunicación e intercambio de información entre sistemas. |
| **Trazabilidad** | Capacidad de seguimiento de procesos, datos y transacciones. |
| **Gobernanza** | Modelo de control, seguimiento y toma de decisiones. |

## 2.8 Arquitectura y tecnología

| Término | Definición |
|---|---|
| **AS-IS** | Estado actual de procesos, arquitectura o capacidades. |
| **TO-BE** | Estado objetivo o futuro esperado. |
| **Arquitectura Empresarial** | Marco que alinea negocio, procesos y tecnología. |
| **Arquitectura de Solución** | Diseño técnico y funcional de la solución implementada. |
| **Macroproceso / Microproceso** | Agrupación de procesos misionales / nivel atómico de un proceso. |
| **Dominio funcional** | Área funcional específica del negocio o sistema. |
| **API** | Interfaz para integración y comunicación entre aplicaciones. |
| **Middleware / BUS** | Capa tecnológica que facilita las integraciones entre sistemas. |
| **Escalabilidad** | Capacidad del sistema para soportar crecimiento. |

## 2.9 Siglas frecuentes

| Sigla | Significado |
|---|---|
| **GAIA** | Nombre del core asegurador (proyecto). |
| **ARL** | Administradora de Riesgos Laborales. |
| **CDP** | Certificado de Disponibilidad Presupuestal (contratación pública). |
| **SARLAFT** | Sistema de Administración del Riesgo de Lavado de Activos y Financiación del Terrorismo. |
| **CRM** | Customer Relationship Management. |
| **SAP** | ERP corporativo (financiero/contable). |
| **SGDEA / Gestor documental** | Sistema de Gestión de Documentos Electrónicos de Archivo. |
| **RUES** | Registro Único Empresarial y Social (consulta por NIT). |
| **NUIP** | Número Único de Identificación Personal (Registraduría). |
| **OFE** | Obligado a Facturar Electrónicamente (facturación electrónica). |
| **RSOA / RSONA** | Reserva de Siniestros Ocurridos Avisados / No Avisados. |
| **ANS (SLA)** | Acuerdo de Niveles de Servicio. |
| **KPI** | Indicador clave de desempeño. |
| **HU** | Historia de Usuario. |
| **VI** | Vida Individual. |
| **DIG** | Productos Digitales. |

---

# 3. Modelo de negocio

El modelo de negocio describe **cómo Positiva estructura y opera sus capacidades** para gestionar productos aseguradores, administrar riesgos y generar valor para clientes, intermediarios y aliados. Integra **actores, procesos, capacidades y servicios** que soportan la operación integral, garantizando trazabilidad, sostenibilidad financiera y evolución progresiva del ecosistema.

> 📐 **Fuente principal:** documento *"Arquitectura de Negocio y Funcional — Sistema de Seguros"* (LinkTIC, Xiomara Suárez). Los diagramas de esta sección provienen de la carpeta `02. Negocio/`.

## 3.1 Modelo conceptual

El modelo conceptual representa los conceptos y relaciones funcionales centrales del ecosistema asegurador. Define las **entidades de información** sobre las que opera todo el sistema:

> **Cliente · Tomador · Asegurado · Beneficiario · Producto · Cobertura · Cotización · Póliza · Prima · Siniestro · Pago · Reserva · Intermediario · Reaseguro · Coaseguro.**

Estas entidades participan transversalmente en todos los procesos y constituyen la base para la integración, la analítica y la evolución funcional.

![Modelo conceptual del sistema de seguros](assets/img/negocio-modelo-conceptual.png)

## 3.2 Catálogo de actores

El sistema distingue actores **externos**, **internos** y **sistemas**:

| Actor | Tipo | Rol |
|---|---|---|
| Tomador | Externo | Contrata la póliza y paga la prima. |
| Asegurado | Externo | Cubierto por la póliza, expuesto al riesgo. |
| Beneficiario | Externo | Recibe la indemnización ante un siniestro. |
| Intermediario (agente/corredor) | Externo | Comercializa el seguro y asesora al cliente. |
| Reaseguradora | Externo | Asume parte del riesgo transferido. |
| Coaseguradora | Externo | Participa en la cobertura de un riesgo con un % definido. |
| Proveedores / Aliados | Externo | Hospitales, clínicas, ajustadores, talleres. |
| Analista de Suscripción | Interno | Evalúa el riesgo y define condiciones de emisión. |
| Analista de Siniestros | Interno | Gestiona, evalúa y liquida los siniestros. |
| Área Financiera | Interno | Facturación, recaudo, cartera, pagos y contabilidad. |
| Administrador del Sistema | Interno | Configura productos, reglas y parametrización. |
| Aseguradora (Positiva) | Interno | Asume el riesgo, emite la póliza y gestiona su ciclo de vida. |
| Sistema CRM | Sistema | Gestión de clientes y cotizaciones (integración principal). |
| Sistema Core de Pólizas (GAIA) | Sistema | Administración de pólizas y procesos core. |
| Sistema Financiero y Contable (SAP) | Sistema | Contabilidad, facturación, recaudo y pagos. |
| Sistema de Gestión Documental | Sistema | Almacenamiento de documentos de pólizas y siniestros. |

## 3.3 Portafolio de servicios

El portafolio agrupa las capacidades que permiten gestionar el ciclo de vida completo de las pólizas en todos los ramos:

| ID | Servicio | Objeto de negocio | Actor responsable |
|---|---|---|---|
| **S1** | Configuración de productos | Producto de seguro | Administrador |
| **S2** | Cotización de seguros | Cotización | Cliente / Intermediario |
| **S3** | Emisión de pólizas | Póliza | Aseguradora / Suscripción |
| **S4** | Administración de pólizas (novedades) | Póliza | Aseguradora / Administrador |
| **S5** | Gestión de recaudo | Prima | Área financiera |
| **S6** | Gestión de comisiones | Comisión | Área financiera |
| **S7** | Gestión de reaseguro | Riesgo / Contrato | Aseguradora |
| **S8** | Gestión de coaseguro | Riesgo compartido | Aseguradoras |
| **S9** | Gestión de reservas técnicas | Reserva | Área actuarial |
| **S10** | Gestión de siniestros | Siniestro | Analista de siniestros |
| **S11** | Gestión de indemnizaciones | Indemnización | Área financiera |
| **S12** | Servicios al cliente | Póliza | Cliente / Intermediario |
| **S13** | Analítica y reportes | Información | Área administrativa |

## 3.4 Estructura del modelo de negocio

El modelo posiciona a la **aseguradora como núcleo**, integrando la gestión de productos, suscripción, administración de pólizas, gestión financiera y atención de siniestros, soportada por sistemas especializados y conectada con clientes e intermediarios a través de múltiples canales. Terceros estratégicos (reaseguradores y coaseguradores) intervienen en la gestión del riesgo y los flujos financieros.

**Componentes del modelo:** Aseguradora (core) · Clientes · Intermediarios · Reaseguradores · Coaseguradores · Sistemas de soporte (CRM, Core de pólizas, financiero, documental) · Canales de interacción (web, móvil, call center, intermediarios).

**Relaciones clave:**
- Los clientes acceden a los productos por canales directos o intermediarios.
- El **CRM** soporta la gestión comercial y la generación de cotizaciones.
- El **Core de pólizas (GAIA)** gestiona emisión, administración y siniestros.
- El **sistema financiero (SAP)** soporta facturación, recaudo, comisiones y pagos.
- Reaseguradores y coaseguradores participan en la distribución del riesgo y sus flujos financieros.

![Estructura del modelo de negocio](assets/img/negocio-estructura-modelo.png)

## 3.5 Cadena de valor

La cadena de valor articula los procesos del ciclo de vida de la póliza —de la configuración de productos a la indemnización— con las capacidades comerciales, operativas y financieras del negocio:

- **Entrada:** estructura organizacional y capacidades que habilitan la operación.
- **Procesos principales:** configuración de productos → cotización → emisión → administración (novedades) → servicios al cliente → siniestros.
- **Capacidades transversales:** funciones financieras (facturación, recaudo, comisiones), actuariales (reservas) y de riesgo (reaseguro, coaseguro).
- **Salida:** información estratégica, indicadores y tableros de control.

![Cadena de valor (vista de síntesis)](assets/svg/cadena-valor.svg)

> 🎨 SVG de elaboración propia. Diagrama original (drawio) a continuación:

![Cadena de valor (diagrama original)](assets/img/negocio-cadena-valor.png)

## 3.6 Modelo estratégico

**Componente motivacional:**

| Elemento | Contenido |
|---|---|
| **Objetivo retador** | Consolidar una arquitectura de seguros integrada que gestione eficientemente el ciclo de vida de las pólizas, optimice la administración del riesgo y garantice la sostenibilidad financiera. |
| **Visión** | Ser una plataforma líder en gestión de seguros, reconocida por integrar procesos, optimizar la operación y soportar decisiones con analítica avanzada. |
| **Misión** | Proveer una solución tecnológica integral que soporte productos, pólizas, siniestros y procesos financieros, con eficiencia, control del riesgo y cumplimiento regulatorio. |

**Valores del negocio:** Orientación al cliente (V1) · Gestión del riesgo (V2) · Sostenibilidad financiera (V3) · Eficiencia operativa (V4) · Cumplimiento regulatorio (V5) · Decisiones basadas en datos (V6).

**Decisiones estratégicas (D1–D10):** gestión integral del riesgo, automatización de procesos, optimización financiera, experiencia omnicanal, cumplimiento y control (SARLAFT), analítica para decisiones, integración de sistemas, eficiencia en siniestros, gestión de intermediarios y **plataforma multi-ramo**.

### 3.6.1 Indicadores estratégicos y metas

| ID | Indicador | Fórmula / Instrumento | Meta | Frecuencia |
|---|---|---|---|---|
| DB1 | Rentabilidad del negocio | Margen técnico = (Primas − Siniestros − Gastos) / Primas | ≥ 15 % | Mensual |
| DB2 | Satisfacción del cliente | % satisfacción / NPS | ≥ 90 % / NPS ≥ 70 | Trimestral |
| DB3 | Eficiencia en emisión | Tiempo promedio / % emisiones exitosas | ≤ 24 h / ≥ 95 % | Mensual |
| DB4 | Gestión de siniestros | Tiempo de liquidación / % pagados | ≤ 10 días / ≥ 90 % | Mensual |
| DB5 | Control de cartera | % cartera vencida / edad de cartera | ≤ 10 % | Mensual |
| DB6 | Precisión en suscripción | Índice de siniestralidad = Siniestros / Primas | ≤ 60 % (según ramo) | Trimestral |
| DB7 | Cumplimiento regulatorio | % validaciones SARLAFT exitosas | ≥ 98 % | Mensual |
| DB8 | Gestión de comisiones | % pagos oportunos / errores | ≥ 95 % | Mensual |
| DB9 | Reaseguro y coaseguro | % conciliaciones / remesas correctas | ≥ 95 % | Mensual |
| DB10 | Uso de analítica | Adopción de dashboards por áreas | ≥ 80 % | Mensual |

## 3.7 Mapa de capacidades de negocio

Las capacidades se clasifican en **estratégicas** (ventaja competitiva), **misionales** (operación directa) y **de funcionamiento** (habilitan y soportan). Se agrupan en dominios: productos y suscripción, pólizas, financiera, siniestros, riesgo (reaseguro/coaseguro), analítica, clientes y canales, y plataforma e integración.

| ID | Capacidad | Tipo | Crítica |
|---|---|---|---|
| C1.1 | Definir y gestionar productos (ramos, coberturas, tarifas) | Estratégica | Sí |
| C1.2 | Configurar reglas de suscripción y condiciones | Estratégica | Sí |
| C2.1 | Gestionar cotización de seguros | Misional | Sí |
| C2.2 | Evaluar el riesgo del cliente (suscripción) | Misional | Sí |
| C3.1 | Emitir pólizas | Misional | Sí |
| C3.2 | Validar cumplimiento normativo (SARLAFT) | Misional | Sí |
| C3.3 | Validar prima (cotizada vs. calculada) | Misional | Sí |
| C4.1 | Gestionar novedades (endosos) | Misional | Sí |
| C4.2 | Gestionar renovación y cancelación | Misional | Sí |
| C5.1 | Gestionar facturación de primas | Misional | Sí |
| C5.2 | Gestionar recaudo y pagos | Misional | Sí |
| C5.3 | Gestionar cartera (mora y pagos) | Misional | Sí |
| C5.4 | Gestionar comisiones a intermediarios | Misional | Sí |
| C6.1 | Gestionar contratos de reaseguro | Estratégica | Sí |
| C6.2 | Gestionar participación de coaseguro | Estratégica | Sí |
| C6.3 | Gestionar cuentas por pagar y remesas | Misional | Sí |
| C7.1 | Gestionar siniestros (registro, evaluación, validación) | Misional | Sí |
| C7.2 | Gestionar reservas de siniestros | Misional | Sí |
| C7.3 | Gestionar indemnizaciones | Misional | Sí |
| C8.1 | Gestionar reservas técnicas | Estratégica | Sí |
| C9.1 | Generar reportes e indicadores | Estratégica | Sí |
| C9.2 | Gestionar analítica para decisiones | Estratégica | Sí |
| C10.1 | Gestionar clientes e intermediarios | Misional | Sí |
| C10.2 | Gestionar canales (web, móvil, call center) | Funcionamiento | No |
| C11.1 | Integrar sistemas (CRM, Core, financiero, documental) | Funcionamiento | Sí |
| C11.2 | Gestionar información y datos del negocio | Funcionamiento | Sí |

![Mapa de capacidades (vista de síntesis)](assets/svg/mapa-capacidades.svg)

> 🎨 SVG de elaboración propia. Diagrama original (drawio) a continuación:

![Mapa de capacidades (diagrama original)](assets/img/negocio-mapa-capacidades.png)

## 3.8 Dominios funcionales

| Dominio | Responsabilidad |
|---|---|
| **Configuración de productos** | Productos, coberturas, tarifas, reglas y parametrización. |
| **Comercial** | Proceso comercial y generación de cotizaciones. |
| **Suscripción y emisión** | Evaluación de riesgos y formalización de pólizas (incluye SARLAFT). |
| **Administración de pólizas** | Endosos, renovaciones, cancelaciones, rehabilitaciones. |
| **Gestión financiera** | Facturación, recaudo, cartera, comisiones. |
| **Reaseguro y coaseguro** | Cesiones, remesas, participación, contratos. |
| **Siniestros** | Aviso, evaluación, liquidación, indemnización. |
| **Reservas y control actuarial** | Reservas técnicas y sostenibilidad financiera. |
| **Analítica y reportería** | KPIs, dashboards, reportería. |
| **Integración y soporte transversal** | Interoperabilidad, gestión documental, auditoría. |

### 3.8.1 Matriz de trazabilidad funcional (capacidad → proceso → sistema)

| Capacidad | Proceso principal | Dominio | Sistema | Criticidad |
|---|---|---|---|---|
| Configuración de productos | Parametrización de productos y coberturas | Productos | Core GAIA | Alta |
| Gestión comercial | Cotización y simulación | Comercial | CRM / Portal | Alta |
| Suscripción | Evaluación y aceptación de riesgo | Suscripción | Core GAIA | Alta |
| Emisión de pólizas | Generación y formalización | Emisión | Core GAIA | Alta |
| Administración de pólizas | Endosos, renovaciones, cancelaciones | Administración | Core GAIA | Alta |
| Gestión documental | Almacenamiento y consulta | Documental | Gestor documental | Media |
| Facturación | Generación de facturas y recibos | Financiera | Core / SAP | Alta |
| Recaudo | Aplicación y conciliación de pagos | Financiera | SAP / Pasarela | Alta |
| Cartera | Control de mora y estado financiero | Financiera | SAP | Alta |
| Comisiones | Liquidación de intermediarios | Intermediación | Core / SAP | Media |
| Reaseguro | Cesión y administración de contratos | Reaseguro | Core GAIA | Media |
| Coaseguro | Participación entre aseguradoras | Coaseguro | Core GAIA | Media |
| Siniestros | Registro y evaluación | Siniestros | Core GAIA | Alta |
| Liquidación de siniestros | Cálculo y autorización de pagos | Siniestros | Core / SAP | Alta |
| Analítica | Generación de reportes y KPIs | Analítica | BI / Reporting | Media |
| Integración empresarial | Orquestación e intercambio | Integración | BUS de integraciones | Alta |
| Cumplimiento SARLAFT | Validación de listas restrictivas | Cumplimiento | SARLAFT / Core | Alta |

## 3.9 Principios arquitectónicos del negocio

1. **Separación de responsabilidades** — dominios desacoplados, sin dependencias innecesarias.
2. **Parametrización funcional** — productos, coberturas, tarifas y reglas configurables sin código.
3. **Trazabilidad end-to-end** — estados, eventos, decisiones y responsables identificables.
4. **Escalabilidad operativa** — crecimiento en volumen, productos, canales y procesos.
5. **Integración desacoplada** — mecanismos estandarizados e interoperables.
6. **Reutilización de capacidades** — capacidades comunes compartidas entre procesos y productos.
7. **Gobierno arquitectónico** — evolución alineada a objetivos, capacidades y dominios.

## 3.10 Vista de arquitectura de negocio

Perspectiva estratégica que relaciona capacidades, cadena de valor y roles (cliente, intermediario, aseguradora), facilitando el entendimiento del negocio a nivel conceptual.

![Vista de arquitectura de negocio](assets/img/negocio-vista-negocio.png)

## 3.11 Vista funcional End-to-End

La **vista E2E** representa la interacción transversal entre módulos, procesos y decisiones operativas que soportan el ciclo de vida de la póliza. El proceso opera como un **flujo transaccional orquestado por eventos**: cada etapa genera datos de negocio, dispara eventos, activa procesos aguas abajo e impacta finanzas, riesgo y cumplimiento.

**Secuencia macro:**

1. **Configuración de productos** *(dominio de parametrización, no transaccional)* — define ramo, producto, plan, coberturas, reglas de suscripción, tarifas y condiciones de reaseguro/coaseguro. Alimenta los motores de cotización, emisión y siniestros.
2. **Cotización** *(primer proceso transaccional)* — transforma datos del cliente (desde CRM o canal directo) en una propuesta con prima y condiciones simuladas.
3. **Suscripción y emisión** — evaluación del riesgo, validación SARLAFT, validación de prima y generación formal de la póliza.
4. **Administración (novedades)** — endosos, renovaciones, cancelaciones y ajustes durante la vigencia.
5. **Gestión financiera** — facturación, recaudo, control de cartera y comisiones.
6. **Siniestros** — aviso, validación de cobertura, evaluación, liquidación e indemnización.
7. **Reaseguro / coaseguro y reservas** — distribución del riesgo, remesas, cuentas por pagar y provisiones.
8. **Analítica** — consolidación de información, KPIs y soporte a decisiones.

![Vista funcional End-to-End (vista de síntesis)](assets/svg/vista-e2e.svg)

> 🎨 SVG de elaboración propia. El diagrama original es de muy alta resolución (16384×8639 px); abajo se muestra completo y luego **segmentado en 3 bandas legibles**.

![Vista E2E original (completa)](assets/img/negocio-vista-e2e.png)

**Detalle por segmentos** (de izquierda a derecha del flujo):

![Vista E2E — segmento 1](assets/img/negocio-vista-e2e-1.png)

![Vista E2E — segmento 2](assets/img/negocio-vista-e2e-2.png)

![Vista E2E — segmento 3](assets/img/negocio-vista-e2e-3.png)

> 🔍 Archivo fuente en alta resolución: `02. Negocio/Vista Funcional End-to-End del Sistema de Seguros.drawio.png`.

---

# 4. Productos de seguros

GAIA es una **plataforma multi-ramo**: su diseño permite incorporar diferentes líneas de negocio mediante **parametrización** (sin desarrollo de código), apoyándose en un concepto de **Product Factory / motor de reglas (BRMS)**. Este capítulo describe los ramos y productos dentro del alcance, su estructura (ramo → producto → amparos) y los catálogos base de parametrización.

> 📐 **Fuentes:** `04_Roadmap_general.pdf`, `Informe validación contractual.pdf` (§6 Ramos y productos), `tipoProducto.xlsx` (catálogos de parametrización) y los flujos de producto en `04.Producto - Funcional/Flujos/`.

## 4.1 Jerarquía: ramo → producto → amparo

El catálogo asegurador se estructura en tres niveles:

```
RAMO  (clasificación regulatoria del riesgo, p. ej. Vida Grupo)
  └── PRODUCTO  (oferta comercial concreta dentro del ramo, p. ej. Vida Grupo Deudores)
        └── AMPAROS / COBERTURAS  (protecciones específicas: muerte, ITP, auxilio funerario…)
              └── TARIFAS y REGLAS  (cómo se calcula la prima y qué se acepta/rechaza)
```

Esta jerarquía es la base de la **configuración de productos** (servicio S1) y alimenta los motores de cotización, emisión y siniestros.

## 4.2 Ramos y productos en el alcance

Tras los ajustes contractuales formalizados, el alcance vigente comprende los siguientes ramos/productos:

| Ramo / Línea | En alcance | Notas |
|---|---|---|
| **Vida Grupo** | ✅ | Incluye varios productos (ver 4.3). Ramo núcleo. |
| **Vida Individual (VI)** | ✅ | Incluye **migración** de información (Vida Individual y Siniestros). Concentró HU pendientes que motivaron la prórroga. |
| **Accidentes Personales (AP)** | ✅ | Concentró HU pendientes junto con VI. |
| **Exequias** | ✅ | Ramo de servicios funerarios. |
| **Salud** | ✅ | Incluye plan ligero y flujo de operación específico. |
| **Colectivos** | ✅ | Pólizas colectivas. |
| **Productos Digitales (DIG)** | ✅ | Canales digitales: **Bicibles** y **Viajero**. |
| **~~Cáncer~~** | ❌ Retirado | Retirado del contrato 0116-2025 (Acta de Negociación No. 1, punto CUARTO): sin viabilidad técnica validada ni información mínima. |
| **~~Fundación de la Mujer~~** | ❌ Retirado | Retirado (Acta de Negociación No. 1): el cliente decidió desarrollarlo con Correcol. |

> ⚠️ **Aclaración importante para el equipo.** Documentos antiguos del repositorio (overview/roadmap inicial) listan **Cáncer** y **Fundación de la Mujer** como productos priorizados. **Ambos fueron retirados formalmente del alcance** mediante el Acta de Negociación No. 1; sus recursos se redistribuyeron a los evolutivos de los ramos en curso. No deben considerarse parte del desarrollo actual.

## 4.3 Productos de Vida Grupo (parametrización vigente)

El catálogo `tipoProducto` define cuatro productos bajo el ramo **Vida Grupo** (`ramo_id = 1`):

| producto_id | Producto | Código |
|---|---|---|
| 1 | Vida Grupo | **VG** |
| 2 | Vida Grupo Elección Popular | **EP** |
| 4 | Vida Grupo Convenio Uso | **CU** |
| 3 | Vida Grupo Deudores | **GD** |

Los tres primeros (VG, EP, CU) comparten un **set amplio de amparos** (≈ amparos 1 a 42 + 55). El producto **Deudores (GD)** tiene un set específico orientado a incapacidad/desempleo y vida del deudor (amparos 43, 45–47, 51–56, 52, 54, 34, 17–21, 42, 55).

## 4.4 Catálogo de amparos / coberturas

Un mismo amparo puede reutilizarse en varios productos. El catálogo base incluye 52 amparos. Los más relevantes:

| ID | Amparo |
|---|---|
| 1 | Muerte por cualquier causa |
| 2 | Incapacidad total y permanente (pago de capital) |
| 3 | Beneficio adicional por muerte o desmembración por accidente |
| 4 | Enfermedades graves – anticipo del básico |
| 5 | Auxilio funerario por muerte por cualquier causa |
| 6 | Renta diaria por hospitalización |
| 7 | Renta diaria por hospitalización en UCI |
| 8 | Renta diaria por hospitalización domiciliaria |
| 9 | Gastos médicos por accidente |
| 10 | Gastos de traslado por accidente |
| 11 | Beneficio adicional por muerte causada por otra persona (homicidio) |
| 12 | Renta mensual por muerte por cualquier causa |
| 13–15 | Rentas/beneficios por incapacidad temporal |
| 16 | Beneficio adicional por muerte accidental |
| 17–21 | Asistencias: odontológica, oftalmológica, tele-psicológica, fisioterapia, internacional en viajes |
| 22 | Incapacidad total y permanente – renta mensual |
| 23 | Enfermedades graves – pago adicional |
| 24–32 | Auxilios: bono canasta, maternidad, pérdida de ingresos por paro, paternidad, accidente, repatriación, ambulancia, desmembración por accidente, especial |
| 33–35 | Traslado de restos, ambulancia aérea, reembolso de gastos funerarios |
| 37 | Desempleo involuntario o incapacidad temporal |
| 42 | Teleconsulta médica |
| 43, 45–47 | Incapacidades temporales (deudores / AT-EP) |
| 51–56 | Coberturas de deudores y vida adicional (hijos, vida ordinario, accidentes, gastos de entierro, teleorientación nutricional) |

*(Catálogo completo de 52 amparos en `tipoProducto.xlsx`, hoja `Amparos`.)*

## 4.5 Tipos de valor asegurado

La base del cálculo del valor asegurado se parametriza con estos tipos:

| ID | Tipo de valor asegurado |
|---|---|
| 1 | Suma informada |
| 2 | N.º de SMMLV (salarios mínimos) |
| 3 | Múltiplo de sueldo |
| 4 | Valor de la cartera *(típico en Vida Grupo Deudores)* |

## 4.6 Productos Digitales (DIG)

Línea de seguros comercializados por **canales digitales**, con flujos de emisión simplificados y autoservicio:

- **Bicibles** — seguro para bicicletas/ciclistas.
- **Viajero** — seguro de asistencia en viajes.

Estos productos tienen su propio ciclo de vida ("Ciclo de vida del producto – Productos Digitales – BICIBLES – VIAJERO") y flujos diferenciados respecto a los ramos tradicionales (ver Cap. 5).

## 4.7 Implicaciones de diseño (multi-ramo y parametrización)

De los requerimientos contractuales se desprenden definiciones de arquitectura clave para los productos:

| Requerimiento | Implicación arquitectónica |
|---|---|
| Gestión multi-ramo | Modularidad y escalabilidad (nuevos ramos sin reescribir el core). |
| Parametrización funcional | **Product Factory / BRMS** — configuración de productos, reglas y catálogos vía front de parametrización. |
| Validaciones automáticas | Motor de reglas por producto/ramo. |
| Automatización operativa | Eliminación de procesos manuales y reducción de errores. |
| Migración de información | Estrategia de migración para **Vida Individual** y **Siniestros**. |
| Trazabilidad y control | Auditoría y control de duplicidad. |

> 🧩 **Idea central:** un nuevo producto no debería requerir desarrollo a medida, sino **configuración** sobre los catálogos (ramo, producto, amparos, tarifas, reglas de suscripción, condiciones de reaseguro/coaseguro). Ese es el espíritu del enfoque *Product Factory*.

---

# 5. Módulos funcionales

Este capítulo describe los **módulos del aplicativo GAIA** (también referido como *Positiva Core* / *Core Vida*). Es la parte más operativa del documento: para cada módulo se indica su **propósito**, sus **submódulos/opciones** y los **conceptos clave** que un desarrollador o analista debe conocer. Los flujos se ilustran con los diagramas BPMN del repositorio.

> 📐 **Fuentes:** manuales de usuario en `04.Producto - Funcional/Manuales/` y flujos en `04.Producto - Funcional/Flujos/`.

## 5.0 Generalidades del aplicativo

- **Acceso (entornos QA conocidos):**
  - `https://corevida-qa.linktic.com/` (entorno más reciente, manuales de 2025).
  - `https://qa.d22qt8s9m0squg.amplifyapp.com/` (entorno previo en AWS Amplify).
- **Login:** usuario + contraseña + **captcha** ("casilla de validación de usuario"). Acceso por módulo según permisos (módulo **Seguridad**).
- **Layout:** la pantalla principal tiene tres zonas — **menú de módulos** (izquierda), **pantalla principal** (centro) y **menú de accesos directos**.
- **Convención:** los campos marcados con `*` son obligatorios en todo el sistema.

### Mapa de módulos del menú

GAIA expone hasta **15 entradas** de menú (la visibilidad depende de permisos):

| Módulo | Rol funcional |
|---|---|
| **Cotización** | Generar y consultar propuestas de seguro. |
| **Emisión** | Solicitar y formalizar pólizas (incluye estudio técnico). |
| **Recaudo** | Cargue de pagos, aplicación y conciliación. |
| **Cartera** | Control de obligaciones pendientes, mora y recibos. |
| **Comisiones** | Liquidación de comisiones a intermediarios. |
| **Novedades** | Modificaciones a pólizas vigentes (endosos, renovaciones, facturación). |
| **Siniestros** | Radicación y gestión de reclamaciones. |
| **Reaseguros** | Contratos proporcionales y no proporcionales, reaseguradores y tasas. |
| **Coaseguro** | Participación de varias aseguradoras en un riesgo. |
| **Reservas** | Reservas técnicas (RSOA/RSONA). |
| **Bancos** | Configuración de cuentas/canales bancarios para recaudo. |
| **Calificación Médica** | Evaluación médica en suscripción/siniestros. |
| **Cierres** | Cierres periódicos de operación. |
| **Reportes** | Reportería operativa y financiera. |
| **Seguridad** | Usuarios, roles y permisos. |

> 💡 Los módulos **Cotización → Emisión → Recaudo/Cartera/Comisiones → Novedades → Siniestros** siguen el orden natural del ciclo de vida de la póliza; **Reaseguros/Coaseguro/Reservas** son transversales de gestión del riesgo, y **Bancos/Cierres/Reportes/Seguridad/Calificación Médica** son de soporte.

### Catálogo de procesos de negocio

El *Documento de Procesos de Negocio* (`Flujos/Anexo_procesos.docx`) formaliza los macroprocesos y subprocesos implementados, con su actor y área responsable:

| ID | Proceso / Subproceso | Actor | Área responsable |
|---|---|---|---|
| **PR-1** | Proceso de Cotización | Director Comercial | Gerencia Comercial |
| PR-1-1 | Subproceso Prospección de Cliente | Director Comercial | Gerencia Comercial |
| PR-1-2 | Subproceso Registrar Cotización | Funcionario | Intermediario |
| PR-1-3 | Subproceso Validación SARLAFT | Director Comercial | Gerencia Comercial |
| **PR-2** | Proceso de Emisión | Director Comercial | Gerencia Comercial |
| PR-2-1 | Subproceso Facturación de Pólizas | Director Comercial | Gerencia Comercial |
| **PR-3** | Proceso de Coaseguros | Profesional Especializado | — |
| **PR-4** | Proceso de Reservas | Profesional Actuario / Gerente de Área | Actuaría y Reaseguros |
| PR-4-1 | Subproceso Reservas RSOA / RSONA | Profesional Actuario / Gerente de Área | — |
| **PR-5** | Proceso de Siniestros | Profesional de Siniestros | Gerencia de Indemnizaciones |
| **PR-6** | Proceso de Reaseguros | Profesional / Corredor de Reaseguros / VP Técnico | — |

> Estos procesos se materializan en los módulos descritos a continuación; la facturación, por ejemplo, es subproceso de Emisión (PR-2-1) pero se opera también desde Novedades.

---

## 5.1 Módulo Cotización

**Propósito:** generar **propuestas de seguro** (simular prima y condiciones) y consultarlas. Es el punto de entrada al ciclo de vida.

**Opciones:** *Consultar cotizaciones* · *Crear cotización*.

**Crear cotización** se organiza en secciones:

1. **Datos generales** — fecha de solicitud, canal de comercialización (intermediario, directo, asesor avanza, director comercial), campaña, sucursal, tipo de cotización (estándar/personalizada/licitación), tipo de seguro (convencional/masivo/microseguro), modalidad (contributivo/no contributivo), tipo de negocio (nuevo, traslado, renovación, reemplazo, prorrogado, facturación), vigencias, forma y periodicidad de facturación (anticipada/vencida; mensual/trimestral/semestral/anual), forma de pago (PSE, débito automático, código de barras, tarjetas, descuento de nómina, corte de cuentas, etc.), CDP, afiliación ARL, condiciones particulares (carencia, amparo automático, ajuste blanket, acuerdo de pago, participación de utilidades, honorarios/retorno), y **coaseguro** (aceptado/cedido con porcentajes y compañía líder).
2. **Datos complementarios** — intermediario (clave, nombre), **porcentaje de comisión** (antes de IVA, editable), y **co-corretaje** (participación entre varios intermediarios).
3. **Tomador** — persona natural o jurídica (datos de identificación, contacto, ubicación; ruralidad calculada por departamento/ciudad).
4. **Productos** — ramo (vida grupo, vida individual, colectivos), producto, plan(es), número de asegurados, prima anual y valor asegurado.
5. **Grupo asegurable** — datos del grupo (edades promedio por sexo, actividad económica CIIU, ubicación del riesgo) y **detalle/perfil de asegurados** (carga individual).
6. **Siniestralidad** — historial de reclamaciones de los últimos 5 años (porcentaje de siniestralidad, amparos afectados, soportes).

![Flujo de Cotización](assets/img/flujo-cotizacion.png)

---

## 5.2 Módulo Emisión

**Propósito:** crear y **formalizar pólizas** a partir de la solicitud, con validaciones de suscripción, estudio técnico y generación de documentos.

**Opciones (7):** *Consultar solicitudes* · *Solicitar Póliza* · *Estudio Técnico* · *Emitir documentos de pólizas* · *Certificado Individual de Seguro* · *Reasignación* · *Listado de Asegurados*.

**Ramos disponibles al solicitar póliza:** Vida Grupo, Vida Individual, Accidentes Personales, Exequias, **Desempleo**, Vida Colectivo, Salud y **Conmutación Pensional**.

**Estados de una solicitud/póliza:** Guardado/Borrador → Radicada → En estudio / Verificación Documentos / Requiere Aclaración / Calificación Médica → Cargada en gestor → Generación de documento póliza → **Expedida** → **Vigente** *(no permite cambios)*; o bien Rechazada / Anulada / Eliminado.

**Solicitar Póliza** se diligencia en **6 submódulos** secuenciales (con botones *Limpiar / Regresar / Continuar*):

1. **Datos Generales** — vigencias, canal, facturación, forma de pago. *(Para el ramo **Salud** solo se permite facturar por **Tomador**.)*
2. **Datos Complementarios** — intermediación y co-corretaje.
3. **Datos del Tomador** — al ingresar el documento, el sistema **trae los datos previamente consignados desde el CRM**; si el tipo es **CC o CE**, se conecta con **Registraduría** para importar los datos del tomador (persona natural o jurídica).
4. **Beneficiarios** — registro de beneficiarios (normal/oneroso).
5. **Productos** — selección de producto, plan(es) y coberturas.
6. **Estudio Técnico / asegurados** — planes, costos asociados, cargue masivo y autorizaciones.

**Estudio Técnico:** permite ver planes, **costos asociados**, cargue masivo y **autorizaciones para suscribir** políticas del estudio técnico. Es el corazón de la suscripción dentro de Emisión.

> 🔗 **Integraciones en juego:** CRM (datos de origen), Registraduría (validación/import CC-CE), SARLAFT (cumplimiento), y SAP (creación de persona contable al expedir).

![Flujo de Emisión](assets/img/flujo-emision.png)

---

## 5.3 Módulo Recaudo

**Propósito:** **cargar, procesar y aplicar pagos** sobre los recibos de las pólizas, y generar reportes.

**Opciones (6):** *Generar archivo de Recaudo* · *Reporte de Aplicación de Pagos* · *Reportes* · *Reporte de Partidas no Aplicadas* · *Descuento por Nómina* · *Tareas*.

**Generar archivo de recaudo** admite dos cargues:
- **Cargue masivo FTP** — reportes de pagos de bancos en formato **`.CSV`**.
- **Otras partidas** — para cruzar posteriormente con los recibos de pago.

**Conceptos de aplicación de pagos:** tipo de recaudo (pago manual total/parcial, **pago automático**, retención de primas), tipo de pago (transacción cruzada, directa, aplicación de depósitos), creación de depósitos por sobrantes, y trazabilidad por banco/canal/referencia. El módulo distingue pólizas **intermediadas** (con clave, nombre y % de comisión del intermediario).

![Flujo de Recaudo](assets/img/flujo-recaudo.png)

---

## 5.4 Módulo Cartera

**Propósito:** controlar las **obligaciones pendientes** de los clientes (estado financiero de los recibos), la mora y el deterioro.

**Opciones:** *Consulta de Cartera* · *Deterioro de Cartera* · *Aplicación de Pagos Manual* · *Tipificación / Seguimiento de Cartera* · *Reversos* · *Consulta de Recibo* · *Balance por Tomador* · *Reporte de pólizas con retroactividad*.

**Conceptos clave:** estado del recibo (Pendiente de pago / Parcial / En mora), **días de cartera** (conteo desde la emisión sin legalizar), prima emitida vs. **prima neta** (pendiente), tipo de recibo (nota crédito, nota débito, retorno), e indicadores de coaseguro/reaseguro y tipo de beneficiario (normal/oneroso). Sirve de base al indicador DB5 (control de cartera).

---

## 5.5 Módulo Comisiones

**Propósito:** **liquidar y pagar comisiones** a intermediarios de forma controlada y verificable.

**Opciones:** *Validación Cuentas de Cobro y/o Facturas* · *Comisiones Estimadas* · *Reporte Cuenta Corriente* · *Ajuste de Comisiones*.

**Comisiones Estimadas:** se calculan a partir de recibos/pólizas **emitidos e intermediados** que aún no están recaudados ni liquidados. Considera: porcentaje de comisión, comisión acreditada, **comisión coaseguro cedido**, **co-corretaje** y las retenciones tributarias (**Retención en la Fuente, ICA, IVA, Retención de IVA**).

**Reporte Cuenta Corriente:** muestra al intermediario la comisión a pagar con sus descuentos; la fecha de liquidación coincide con la fecha de aplicación del recaudo. *(Expuesto también como API `GET /comisiones/crm/cuenta-corriente` — ver Cap. 7.)*

![Flujo de Comisiones](assets/img/flujo-comisiones.png)

---

## 5.6 Módulo Novedades

**Propósito:** gestionar todas las **modificaciones posteriores a la emisión** de una póliza (endosos).

**Opciones:** *Prorrogar / Renovar Póliza* · *Facturar* · *Histórico de Novedades*.

- **Prorrogar / Renovar:** extiende la vigencia (un mes o un año).
- **Facturar:** emite las facturas de las primas por póliza/periodo.
- **Histórico de Novedades:** trazabilidad de todos los movimientos de una póliza (número y tipo de movimiento, fechas inicial/final/emisión, usuario, estado del recibo —legalizado/pendiente/parcial—) con acceso a recibo, carátula, factura y listado de asegurados.

> Las novedades **pueden generar o no prima** (cobro o devolución), según el tipo de cambio aplicado.

![Flujo de Novedades / Mantenimiento](assets/img/flujo-novedades.png)

---

## 5.7 Módulo Siniestros

**Propósito:** **radicar y gestionar reclamaciones** sobre las pólizas, evaluando cobertura y liquidando indemnizaciones.

**Opciones (5):** *Radicar Reclamación* · *Consultar Reclamaciones* · *Parámetros de Siniestros* · *Mantenimiento* · *Trámites de Gestión*.

**Radicar Reclamación** se realiza según el **rol** de quien reclama (Reclamante/Siniestrado · Intermediario · Tomador); los campos cambian en función del rol. Al ingresar el número de póliza, el sistema valida contra el core: **vigencia, amparos cubiertos, asegurados y estado de pago**. Distingue si hubo **fallecimientos** (causas/motivos de muerte) frente a **amparos prestacionales**, y separa la información de la persona que reclama y de la persona siniestrada.

> Existen flujos web complementarios ("Reclamaciones desde página web") y subprocesos de reservas asociados (RSOA/RSONA).

![Flujo de Siniestros](assets/img/flujo-siniestros.png)

---

## 5.8 Módulo Reaseguros

**Propósito:** administrar la **transferencia de riesgo** a reaseguradores mediante contratos.

**Opciones (5):** *Consulta de Contratos* · *Parametrización de Contratos no Proporcionales* · *Parametrización de Contratos Proporcionales* · *Gestionar Reaseguradores* · *Gestionar Tasas*.

- **Contratos no proporcionales** (tipo exceso de pérdida): datos generales → fechas de pago → corredores → **información de capas** (*layers*). Cada **capa** define: número de capa, **capacidad por capa**, **prioridad** (punto de retención), corredor/broker, cantidad de reaseguradores y **tasas** (mínima, máxima y real). Se pueden añadir/editar/eliminar capas.
- **Contratos proporcionales**: **Modalidad** = *Contrato Cuota Parte* o *Contrato Excedentes* + datos generales e información de **corredores**.
- **Gestionar reaseguradores** y **gestionar tasas** — maestros del módulo.

> 📚 **Recordatorio conceptual:** en **proporcional** la reaseguradora comparte primas y siniestros en un porcentaje fijo (*cuota parte*) o sobre excedentes; en **no proporcional** (XL) la reaseguradora solo responde por encima de la **prioridad** (retención de la cedente), organizado en **capas**.

![Flujo de Reaseguros](assets/img/flujo-reaseguros.png)

---

## 5.9 Módulo Coaseguro

**Propósito:** gestionar la participación de **varias aseguradoras en un mismo riesgo**, con roles **líder (cedido)** y **no líder (aceptado)**, distribución de primas, gastos y **remesas**. Se configura desde la cotización/emisión (porcentajes de participación, compañía líder, aseguradoras aceptantes) y se refleja en recaudo, cartera y comisiones.

![Flujo de Coaseguros](assets/img/flujo-coaseguros.png)

---

## 5.10 Módulo Reservas

**Propósito:** gestionar las **reservas técnicas** que respaldan las obligaciones futuras del negocio. Corresponde al proceso **PR-4** (área de Actuaría y Reaseguros).

**Subproceso PR-4-1 — Reservas RSOA / RSONA:** permite **calcular y consolidar la reserva y la provisión técnica**. Conceptos:

| Sigla | Reserva | Qué cubre |
|---|---|---|
| **RSOA** | Siniestros Ocurridos y **Avisados** | Provisión para siniestros ya reportados pero aún no liquidados/pagados. |
| **RSONA** | Siniestros Ocurridos y **No Avisados** (IBNR) | Provisión estimada para siniestros que ya ocurrieron pero **todavía no han sido reportados**. |

Ciclo de la reserva: **constitución** (al reportarse o estimarse) → **ajuste** (según evoluciona el riesgo/expediente) → **liberación** (al pagar el siniestro o cerrarlo). Estas provisiones alimentan el indicador de sostenibilidad financiera y se enlazan con siniestros y reaseguro.

> ⚠️ **Alcance documentado:** las fuentes describen el **qué** (constituir, ajustar, liberar, consolidar la provisión técnica) y el flujo; el **método de cálculo actuarial específico** (factores, triángulos de desarrollo, etc.) no está detallado en la documentación revisada y se gestiona desde el área actuarial.

![Flujo de Reservas](assets/img/flujo-reservas.png)

![Subproceso Reservas RSOA y RSONA](assets/img/flujo-reservas-rsoa-rsona.png)

---

## 5.11 Módulos de soporte

| Módulo | Función |
|---|---|
| **Bancos** | Configuración de bancos, cuentas y canales de pago usados por Recaudo. |
| **Calificación Médica** | Evaluación médica como parte de la suscripción (Emisión) y de algunos siniestros. Es un estado posible de la solicitud de póliza. |
| **Cierres** | Cierres periódicos (contables/operativos) de la operación. |
| **Reportes** | Generación de reportes operativos y financieros (insumo de analítica e indicadores). |
| **Seguridad** | Gestión de usuarios, roles y permisos; controla qué módulos ve cada usuario. |

---

## 5.12 Procesos especiales y validaciones transversales

### 5.12.1 Validación SARLAFT

Verificación en **listas restrictivas** durante la cotización/emisión (proveedor **Red5G**, también FCC). Bloquea o marca para revisión a tomadores/asegurados de riesgo. Es una capacidad crítica del negocio (indicador **DB7**, meta ≥ 98 % de validaciones exitosas) y un subproceso formal (**PR-1-3**).

![Flujo SARLAFT propuesto](assets/img/flujo-sarlaft.png)

### 5.12.2 Operación de Salud

El ramo **Salud** se opera de forma diferenciada respecto a los ramos de vida:

- Tiene **microservicio propio** (`Salud`) y servicios internos **`ProductoSalud`** y **`AmparoSalud`** (gestión y consumo de amparos de salud).
- Se apoya en **operadores/aliados externos**: **Medora** (operador de pólizas de salud) y **Conexia** (gestión de consultas médicas).
- En la emisión de Salud, la facturación solo permite la opción **Tomador** (no Asegurado).
- Cuenta con flujos específicos, incluyendo un **Plan Ligero**.

> 📌 **Nota de alcance:** los flujos de Salud están documentados como **diagramas BPMN** (sin manual de usuario textual). El paso a paso fino debe leerse directamente de los diagramas fuente; abajo se incluyen para referencia.

![Flujo de operación de Salud](assets/img/flujo-salud-operacion.png)

![Flujo Salud – Plan Ligero](assets/img/flujo-salud-plan-ligero.png)

### 5.12.3 Productos Digitales (DIG)

Línea de **seguros digitales** con ciclo de vida simplificado y orientado a autoservicio: **Bicibles** (bicicletas/ciclistas) y **Viajero** (asistencia en viajes). Al igual que Salud, su detalle vive en los diagramas de flujo (no hay manual textual).

<table>
<tr>
<td><img src="assets/img/flujo-dig-bicibles.png" alt="DIG Bicibles" width="100%"></td>
<td><img src="assets/img/flujo-dig-viajero.png" alt="DIG Viajero" width="100%"></td>
</tr>
<tr><td align="center"><em>DIG – Bicibles</em></td><td align="center"><em>DIG – Viajero</em></td></tr>
</table>

---

# 6. Arquitectura de solución

Este capítulo resume el diseño técnico de GAIA: estilo arquitectónico, microservicios, stack tecnológico, infraestructura AWS, atributos de calidad y decisiones de arquitectura.

> 📐 **Fuente principal:** `03. Arquitectura de solucion/ARQUITECTURA_01 SAD_POSITIVA_CORE_V3.6.pdf` (Solution Architecture Document, LinkTIC; última versión 3.6 de dic-2025) y `Manual Técnico BackEnd - FrontEnd`. El SAD documenta el modelo **C4** (niveles 1 a 4) y la vista física de despliegue.

## 6.1 Vista de alto nivel

![Arquitectura de alto nivel CORE GAIA](assets/svg/arquitectura-alto-nivel.svg)

> 🎨 Diagrama SVG de elaboración propia, sintetizado del SAD V3.6. Para las vistas C4 originales, consultar el SAD.

## 6.2 Estilo arquitectónico

GAIA es una solución **cloud-native** basada en **microservicios**, con estos supuestos de diseño (SAD §7.1.1.4):

- Arquitectura basada en **microservicios** independientes por dominio.
- Comunicación **entre microservicios mediante colas** (RabbitMQ), con mensajes tipo **comando** (patrón *Command*): desacopla, permite transacciones síncronas/asíncronas, reintentos, control de fallos y persistencia de comandos.
- Integración con **sistemas externos vía APIs REST** (y SOAP donde el servicio destino lo exige).
- Cada microservicio sigue un **patrón en capas (4 capas) típico de Spring Boot**.

> 📌 **Nota de evolución.** El *Manual Técnico* original describía un "arquetipo monolito"; el SAD fue evolucionando (V3.4 en oct-2025 añadió microservicios y vistas C4; V3.5 añadió el microservicio de **Reportes** y el diseño de **notificaciones** síncronas/asíncronas). La referencia vigente es la **arquitectura de microservicios** del SAD V3.6.

### Patrón en 4 capas (por microservicio)

| Capa | Responsabilidad |
|---|---|
| **Controlador** | Recibe y clasifica las solicitudes (requests). |
| **Servicio / Negocio** | Lógica de la aplicación. |
| **DTO** | Objetos que transportan la información. |
| **Entity** | Mapea los datos de la base de datos a objetos. |
| **Repository** | Interactúa con sistemas externos como la base de datos. |

## 6.3 Microservicios (componentes C4 nivel 3)

| # | Microservicio | Función |
|---|---|---|
| 10 | **Core** | Recibe las peticiones desde **CRM** y **orquesta** a los demás microservicios. |
| 3 | **Cotizaciones** | CRUD de cotizaciones. |
| 5 | **Emisión** | CRUD de emisión de pólizas. |
| 11 | **Producto** | Administración de productos (catálogo/parametrización). |
| 6 | **Facturación** | Gestión financiera/facturación. |
| 4 | **Cartera** | Administración de cartera. |
| 2 | **Comisiones** | CRUD de comisiones. |
| 1 | **Coaseguros** | CRUD de coaseguros. |
| 12 | **Reaseguros** | CRUD de reaseguros. |
| 13 | **Reservas** | CRUD de reservas. |
| 15 | **Siniestros** | CRUD de siniestros. |
| 14 | **Salud** | Funciones propias de salud. |
| — | **Reportes** | Reportería (añadido en SAD V3.5). |
| 7 | **Integración** | Facilita la integración con sistemas externos. |
| 8 | **Jobs** | Procesos asíncronos programados. |
| 9 | **Login** | Acceso, autorización y gestión de usuarios (JWT, contra LDAP de Positiva). |
| 16 | **Base de datos** | Persistencia **separada lógicamente** según los módulos de la aplicación. |

### 6.3.1 Repositorios de código

El código se organiza en un **repositorio de frontend**, un **grupo de microservicios de backend** y un **grupo de jobs**. Los nombres del VCS se listan tal como están en el control de versiones (respetar exactamente al clonar/configurar CI).

> 🗂️ **Estructura local (esta máquina).** Base: `/Users/hernannieto/Documents/TemasCorporativos`.
> No todos los repos del VCS están clonados localmente; abajo se marca cuáles sí (`✅ clonado`) y su carpeta real. Al referirte a código local, usa **la ruta local**, no el nombre del VCS.

**Frontend** — carpeta local: `frontend/`

| Repositorio (VCS) | Clon local | Contenido |
|---|---|---|
| `Front_Core` | ✅ `frontend/dev-web-front-core` | Aplicación web principal (Vue/Quasar + TypeScript). |
| — | ✅ `frontend/dev-web-front-core-siniestros` | Front específico de Siniestros. |

**Backend — grupo `dev_ms_core`** — carpeta local: `backend/`

| Componente / carpeta (`dev_ms_core`) | Repositorio (VCS) | Clon local |
|---|---|---|
| `core` (orquestador) | `Core-core` | ✅ `backend/dev-ms-core-core` |
| `emisiones` | `Core-emisiones` | ✅ `backend/dev-ms-core-emisiones` |
| `integraciones` | `Core-integracion` | ✅ `backend/dev-ms-core-integraciones` |
| `reporteria` | `Core-reportera` | ✅ `backend/dev-ms-core-reporteria` |
| `siniestros` | `Core-siniestros` | ✅ `backend/dev-ms-core-siniestros` |
| `siniestros` (v2) | — | ✅ `backend/dev-ms-core-siniestros-v2` |
| `cotizacion` | `Core-cotizacion` | ⬜ no clonado |
| `facturacion` | `Core-facturacion` | ⬜ no clonado |
| `cartera` | `Core-cartera` | ⬜ no clonado |
| `coaseguros` | *(sin repo `Core-*` en la fuente)* | ⬜ no clonado |
| `reaseguros` | `Core-reaseguro` | ⬜ no clonado |
| `reservas` | `Core-reservas` | ⬜ no clonado |
| `producto` | `Core-producto` | ⬜ no clonado |
| `politicas` | `Core-politicas` | ⬜ no clonado |
| `novedades` | `Core-novedad` | ⬜ no clonado |
| `login` | `Core-login` | ⬜ no clonado |

**Jobs — grupo `355 positiva core jobs`**

| Carpeta | Repositorio (VCS) | Clon local |
|---|---|---|
| `tarifas` | `Core-jobs` | ⬜ no clonado |

**Otros repositorios identificados**

| Repositorio (VCS) | Nota |
|---|---|
| `Core-qa-segfuros` | Repositorio adicional del grupo (aparente relación con QA/seguros). No clonado local. |

> 📌 **Documentos y demás rutas locales** (fuera de `backend/` y `frontend/`), bajo la misma base `/Users/hernannieto/Documents/TemasCorporativos`:
> - `Documentos HUs/` — documentación de Historias de Usuario.
> - `CONTEXTO-*.md` — handoffs de continuidad entre sesiones.
> - `scripts/`, `*.sql`, `*.http` — utilidades y evidencias de pruebas.
> - Las rutas `assets/img/*`, `assets/svg/*` y las carpetas de documentación (`00. Start Here`, `01. Gobierno y gestión`, `02. Negocio`, `03. Arquitectura de solucion`, `04.Producto - Funcional`) que aparecen en este documento pertenecen al **repo de documentación fuente** (no clonado en esta máquina); quedan como referencia bibliográfica, no como paths locales.

> ✅ **Nombres confirmados (usar exactamente así).** Los siguientes nombres son los **reales del control de versiones**, no errores de transcripción — **no deben "corregirse"**:
> - `Core-novedad` (en singular, aunque la carpeta funcional sea `novedades`).
> - `Core-reaseguro` (singular, carpeta `reaseguros`).
> - `Core-reportera` (carpeta `reporteria`).
> - `Core-cotizacion` (sin tilde, carpeta `cotización`).
> - `Core-qa-segfuros` (nombre literal del repositorio, escrito así en el VCS).
> - El grupo de **jobs** (`355 positiva core jobs`) alberga `tarifas`, en el repositorio `Core-jobs`.
>
> ℹ️ **Pendientes de mapeo** (informativo, no bloqueante):
> - **`coaseguros`** figura como carpeta en `dev_ms_core` pero sin repo `Core-*` correspondiente en el listado.
> - **Comisiones** y **Salud** (microservicios del SAD) no tienen repo propio en este listado; podrían estar integrados en otro servicio.

## 6.4 Matriz de tecnologías

| Capa / Componente | Tecnología | Versión | Rol |
|---|---|---|---|
| Front-End | **Vue.js** (framework **Quasar**) + TypeScript | 3.0 | Interfaz de usuario web reactiva. |
| Estilos | Tailwind / Vuetify | — | Opcionales. |
| Back-End | **Java OpenJDK** | 17+ | Lenguaje base de microservicios. |
| Framework | **Spring Boot** | 3.1 | Microservicios empresariales. |
| Contenedores | **Docker** (base Linux) | — | Empaquetado de microservicios. |
| Orquestación | **Amazon ECS** | — | Orquestación de contenedores en producción *(ver decisión 6.7)*. |
| Nube | **AWS** | — | Región **us-east-1** (Norte de Virginia). |
| Base de datos | **PostgreSQL** | 15 | Relacional, persistencia transaccional. |
| Mensajería | **RabbitMQ** (Amazon MQ) | — | Comunicación síncrona/asíncrona entre MS. |
| Caché | **Redis** | — | Caché de la aplicación. |
| Servicios | **REST API + JSON** | — | Exposición front ↔ back. |
| BPM | **Thanos BPM** | — | Motor de procesos / orquestación lógica. |
| IaC | **Terraform** | — | Infraestructura como código. |

## 6.5 Infraestructura AWS (vista física de despliegue)

Arquitectura **cloud-native** sobre AWS, alta disponibilidad y escalabilidad:

| Servicio AWS | Rol en GAIA |
|---|---|
| **CloudFront** | CDN: contenido estático del frontend y caché de respuestas. |
| **ALB** (Application Load Balancer) | Balanceo, enrutamiento y *health checks* de microservicios. |
| **ECS** | Orquestación de los contenedores Docker (Spring Boot). |
| **RDS PostgreSQL (Multi-AZ)** | Base de datos transaccional con respaldo automático y réplica de lectura. |
| **Secrets Manager** | Credenciales y configuración sensible, con rotación automática. |
| **S3** | Frontend estático, documentos de pólizas, cargas masivas (Excel), reportes y backups. |
| **ECR** | Registro de imágenes Docker de los microservicios. |
| **Lambda** | Funciones serverless para eventos y tareas programadas. |
| **Amazon MQ (RabbitMQ)** | Mensajería asíncrona entre microservicios. |
| **EventBridge** | Orquestación de eventos, schedulers y triggers. |
| **CloudWatch** | Monitoreo centralizado de logs, métricas y alarmas. |
| **CloudTrail** | Auditoría de acciones sobre recursos AWS. |

**Flujo de tráfico:** Usuario/CRM → **CloudFront** → **API Gateway** → **ALB** → microservicios en **ECS** → datos en **RDS / Redis / S3** y mensajería **RabbitMQ**.

> ⚠️ **Aclaración:** el *Manual Técnico* menciona "AZURE Environments / Secrets Manager"; es una referencia heredada del arquetipo base. La infraestructura real es **AWS**, y la gestión de secretos es **AWS Secrets Manager** (confirmado por el SAD V3.6).

### 6.5.1 Ambientes

GAIA cuenta con **4 ambientes** en cuentas AWS separadas, desplegados con Terraform:

| Ambiente | Front-End | Back-End | Cuenta AWS |
|---|---|---|---|
| **Desarrollo** | `corevida-dev.linktic.com` | `apicorevida-dev.linktic.com/dev/` | 726972821175 |
| **Pruebas (QA)** | `corevida-qa.linktic.com` | `apicorevida-qa.linktic.com/qa/` | 382766170909 |
| **UAT** | `corevida-uat-v2.linktic.com` | `apicorevida-uat.linktic.com/uat/` | 382766170909 |
| **Producción** | `corevida.positiva.gov.co` | `apicorevida-prod.linktic.com/prod/` | 737380355969 |

> 🔒 **Uso interno LinkTIC.** Estos dominios y cuentas son para referencia del equipo; no compartir fuera de LinkTIC. Producción se publica bajo el dominio de Positiva (`positiva.gov.co`).

### 6.5.2 Política de autoescalado

Autoescalado por **uso de CPU**: al superar el **70 %**, escala hasta un **máximo de 2 instancias**. Superado ese punto, se debe investigar posible degradación de rendimiento.

## 6.6 Atributos de calidad (referencia ISO/IEC 25000)

| Atributo | Criterio |
|---|---|
| **Desempeño** | ≤ 400 usuarios diarios; media 700 conexiones/día; respuesta < 10 s por transacción (promedio ~5 s); pico ~8,63 TPS. |
| **Capacidad** | 200 usuarios, 40 % concurrentes, ~50.000 transacciones/mes. |
| **Tiempos esperados** | Transacción: 0,5–2 s · Cargue masivo: 5–60 s · Descarga de archivos: 20–60 s. |
| **Fiabilidad** | Máx. 9 fallas por 10.000; rollback ante fallo; **disponibilidad > 99,8 %**; persistencia 100 % de datos misionales (consulta 99 % sobre últimos 24 meses). |
| **Disponibilidad** | **7 × 24**. |
| **Mantenibilidad** | Cobertura automatizada 60 % (40 % manual); estabilidad mínima 90 %; multi-navegador. |
| **Seguridad** | Cifrado en tránsito y reposo; mejores prácticas AWS; **autenticación con token JWT**; OWASP. |

## 6.7 Decisiones de arquitectura (ADR)

| Decisión | Alternativas | Resolución |
|---|---|---|
| **Tecnología de despliegue** | Kubernetes / EC2 / ECS | **ECS** — alta disponibilidad, versátil y sin servidor; el consumo de APIs REST pasa por **API Gateway**, que dirige al ALB y este al ECS. |
| **Base de datos** | MySQL / PostgreSQL / Oracle / SQL Server | **PostgreSQL** — gratuita, alto rendimiento y buen soporte. |
| **Estrategia de consultas** | Directas / réplicas / caché | **Caché primero** (Redis); si no está, consulta a la **réplica de lectura** y actualiza la caché; los comandos van a la BD principal. |

## 6.8 Estado actual (AS-IS)

El diagrama AS-IS resume la arquitectura actual de Positiva Core como punto de partida de la transformación.

![Arquitectura AS-IS Positiva Core](assets/img/arquitectura-as-is.png)

---

# 7. Integraciones

GAIA opera dentro del ecosistema corporativo de Positiva. Este capítulo detalla las **integraciones internas** (entre microservicios) y **externas** (con sistemas de terceros), sus protocolos y los **contratos de API** relevantes.

> 📐 **Fuentes:** `Integraciones/.../INFORME DE INTEGRACIONES INTERNAS Y EXTERNAS.pdf` (CPS 0116/2025, ago-2025), SAD V3.6 (catálogo de componentes externos), definiciones **YAML/OpenAPI** y **requests JSON** de ejemplo, y los documentos de integración con **CRM**.

## 7.1 Principios de integración

- **Comunicación principal vía API REST con JSON sobre HTTPS.**
- **SOAP/RFC** solo donde el sistema destino lo exige (caso **SAP**).
- **Autenticación interna con JWT**; autenticación corporativa contra **LDAP / Active Directory**.
- **Mensajería asíncrona** entre microservicios con **RabbitMQ** (Amazon MQ).
- **Caché (Redis)** para optimizar consultas frecuentes.
- El **Bus de Servicios (EBS "thanos")** existe en Positiva pero **NO se utiliza** para estas integraciones (decisión documentada en el SAD).

## 7.2 Integraciones internas (entre microservicios)

| Origen | Se integra con | Tipo | Protocolo | Propósito |
|---|---|---|---|---|
| Autenticación (Login) | Usuarios | API REST | HTTPS / JWT | Validar credenciales y emitir tokens. |
| Notificaciones | Usuarios | Mensajería asíncrona | RabbitMQ / Amazon MQ | Alertas internas y recordatorios. |
| Facturación | Pagos | API REST interna | JSON / HTTPS | Registrar y consultar pagos. |
| Reportes | Base de datos | Conexión directa | SQL / PostgreSQL | Extraer datos consolidados. |
| Emisión | Cotización | API REST | JSON / HTTPS | Procesar solicitudes de emisión. |
| AmparoSalud | ProductoSalud | API REST | JSON / HTTPS | Gestión de amparos de salud. |
| SolicitudPoliza | Emisión | API REST | JSON / HTTPS | Procesar solicitudes de pólizas. |
| ServicioConsumoSalud | AmparoSalud | API REST | JSON / HTTPS | Consumo de servicios de salud. |
| CargueMasivo | Base de datos | Conexión directa | SQL / PostgreSQL | Procesamiento masivo de datos. |

## 7.3 Integraciones externas (terceros)

| Sistema externo | Proveedor / Entidad | Comunicación | Formato | Funcionalidad |
|---|---|---|---|---|
| **CRM Positiva** | **Wimbu (Odoo)** | API REST | JSON / HTTPS | Gestión de cotizaciones y pólizas. *(Integración principal.)* |
| **SAP** | SAP ERP | **SOAP / RFC** | XML / HTTPS | Creación de personas y asientos contables. |
| **Facturación Electrónica** | **Open-eb.io** | API REST | JSON / HTTPS | Emisión y gestión de facturas electrónicas. |
| **SARLAFT** | **Red5G** | API REST | JSON / HTTPS | Validación SARLAFT y FCC. |
| **RUES** | Cámara de Comercio | API REST | JSON / HTTPS | Consulta de información empresarial (por NIT). |
| **Registraduría** | Registraduría Nacional | API REST | JSON / HTTPS | Validación de cédulas (NUIP). |
| **Listas Restrictivas** | **AGS** | API REST | JSON / HTTPS | Consulta de listas restrictivas. |
| **SGDEA** | **3tcapital** | API REST | JSON / HTTPS | Gestión documental. |
| **Correo electrónico** | 3tcapital | SMTP | MIME | Envío de notificaciones. |
| **LDAP** | Active Directory | LDAP | LDAP / HTTPS | Autenticación corporativa. |
| **Medora** | — | API REST | — | Operador de pólizas de salud. |
| **Conexia** | — | API REST | — | Gestión de consultas médicas. |
| **Pasarela de pagos** | (vía página web) | API REST | — | Recaudo en línea. |
| **SFTP** | AWS Transfer Family | SFTP | CSV | Recepción de archivos de recaudo de bancos. |

## 7.4 Caso destacado: integración con SAP

La integración con **SAP** es la más compleja porque es **bidireccional** y mezcla REST y SOAP. Patrón observado en el código del microservicio:

- **Exposición REST interna** (`SapController`): `POST /sap/crear-persona`, `POST /sap/crear-asiento`, `POST /sap/crear-asiento-contable` — consumidos por los demás procesos.
- **Orquestador contable** (`CrearAsientoContableSapImpl`): selecciona el servicio especializado según `CodigosContabilizacionSapEnum` (emisión, recaudo, depósitos, comisiones, siniestros) y maneja modos mock/bulk/asíncrono.
- **Cliente SOAP saliente** (`SapService` / `SoapSapClient`): llama a SAP para **personas** y **asientos**, agregando cabecera **WS-Security UsernameToken** + credenciales básicas.
- **Servicio SOAP entrante** (`ServicioSapSoap`, vía Apache CXF en `/RespuestaServicioSap`): recibe **confirmaciones** de SAP; un interceptor valida autenticación básica.
- **Procesos programados** (`@Scheduled`, `EnvioContabilizacionSap`): envíos masivos y actualización del consecutivo de comisiones.
- **Persistencia y auditoría** (`RegistroCreacionAsientoSap`): guarda request/response SAP (JSONB + XML), referencias y estado del envío.
- **Control de concurrencia:** en recaudo se **bloquea el tomador** (singleton en memoria) antes del envío para evitar condiciones de carrera, liberándolo al final.

> 🧱 **Objetos SAP clave:** `ZPersona` (datos de persona/aseguradora/intermediario) y `ZAsiento` (asiento contable). Las constantes de mapeo se obtienen desde base de datos (`mapaConstantesSap`).

## 7.5 APIs que CORE expone (consumo desde CRM)

CORE publica servicios REST para que el **CRM** consulte información financiera. Definidos en OpenAPI 3.0.3:

| Servicio | Endpoint | Descripción |
|---|---|---|
| **Cuenta corriente** | `GET /comisiones/crm/cuenta-corriente` | Consulta de cuenta corriente de comisiones. Filtros: `claveIntermediario`, `fechaInicialRecaudo`, `fechaFinalRecaudo`, `documentoTomador`, paginación (`pagina`, `tamanio`). Requiere `Authorization: Bearer {token}`. |
| **Recibos de pago** | `GET /recibos-pago/crm/obtener-recibos` | Consulta de recibos por `numeroEmision` (número de póliza), con paginación. Requiere token Bearer. |
| **Radicar comisiones** | `POST .../comisiones/crm/radicar-comisiones` | Crea la emisión/comisión; si el intermediario enviado no existe en CORE, **lo crea**. URL QA: `https://apicorevida-qa.linktic.com/qa/mono/comisiones/crm/radicar-comisiones`. |
| **Registrar reclamación (siniestro)** | `POST /reclamacionSiniestradaService/crm/save/` | Registra solicitudes de reclamación desde el CRM. Body `ReclamacionSiniestrada` (tipo/número de documento, nombres, correo…). `Authorization: Bearer {token}`. Server dev: `positivacoredes.linktic.com`; QA: `positivacoreqa.linktic.com`. |

> 🔎 **Detalle técnico de los servicios** (autenticación JWT, REST/Spring Boot, parámetros) en `Integraciones/3.3.3.3 Especificaciones de Servicios/` (cuenta corriente, recibos de pago, radicación de comisiones) y `3.3.3.2/Contratos Siniestro Core.docx`.

## 7.6 Servicios externos que CORE consume (requests de ejemplo)

| Servicio | Entrada clave (request) |
|---|---|
| **Registraduría** | `{ "solicitudConsultaEstadoConsulta": { "nuip": <número de cédula> } }` |
| **RUES** | `{ "solicitudConsulta": { "nit": <NIT> } }` |
| **SARLAFT (Red5G)** | `{ "gestion_type", "daughter_key", "product", "policy_holder": { document_type, document_number, check_digit }, "url_callback", ... }` — soporta callback asíncrono. |
| **SAP – personas** | Objeto `ZPersona` con `PBancos`, `PIn` (sociedad, grupo de cuentas), titular, cuenta, etc. |
| **Facturación electrónica (Open)** | Documento `FC` con `ofe_identificacion` (OFE 860011153), `adq_identificacion`, resolución, tipo de documento (`tde_codigo`), etc. |

> 💡 **Para desarrolladores:** los requests/definiciones completos están en `04.Producto - Funcional/Integraciones/` (`3.3.3.4 APIs - Requests JSON` y `3.3.3.5 APIs - Definiciones YAML`). Úsalos como contrato de referencia al implementar o probar integraciones.

## 7.7 Documentación CRM (integración principal)

La integración **CORE ↔ CRM (Wimbu/Odoo)** es la principal del proyecto (código interno **355 - POSITIVA CORE VIDA**) y está documentada en detalle en `3.3.3.1 Documentos Core (CRM - Integración principal)`.

### 7.7.1 Endpoints (cotización y emisión desde CRM)

| Operación | Método | Endpoint |
|---|---|---|
| Crear cotización/emisión combinada | `POST` | `https://positivacoredes.linktic.com/datosCombinadosEmision/save` |
| Editar emisión | `PUT/POST` | `https://positivacoredes.linktic.com/emisionService/editar/{idEmision}` |
| Catálogo de servicios (Swagger UI) | — | `https://positivacoredes.linktic.com/swagger-ui/index.html` (`/v2/api-docs`) |

> 💡 El **Swagger UI** del entorno es el contrato vivo de la API: úsalo como referencia autoritativa de campos y tipos al integrar o probar.

### 7.7.2 Estructura del payload (`datosCombinadosEmision`)

El cuerpo es un **arreglo de secciones etiquetadas** (`label` + objeto de datos), que refleja 1:1 la estructura de la cotización/emisión del core. Secciones identificadas:

| `label` | Contenido |
|---|---|
| `Emision` | Datos de cabecera (p. ej. `usuarioACargo`). |
| `Datos generales póliza` (`datosGeneralesEmision`) | Vigencias, canal, facturación, forma de pago, etc. |
| `Tomador póliza` | Datos del tomador (natural/jurídico). |
| `Intermediación póliza` | Clave, comisión, co-corretaje. |
| `Coaseguro póliza` | Participación, líder, aceptantes. |
| `Condición particular póliza` | Carencia, acuerdos de pago, participación de utilidades. |
| `Grupo Asegurable póliza` | Datos del grupo y asegurados. |
| `Producto vida grupo elección popular póliza` | Datos del producto **EP**. |
| `Producto vida grupo deudores póliza` | Datos del producto **GD**. |
| `Producto vida grupo convenio uso póliza` | Datos del producto **CU**. |
| `Licitación póliza` | Datos de licitación (si aplica). |
| `Siniestralidad póliza` | Historial de siniestros. |

> 🧩 Las secciones de producto son específicas por producto de Vida Grupo (EP/GD/CU), lo que confirma el enfoque parametrizable por producto descrito en el Cap. 4.

### 7.7.3 Otros documentos CRM

- **CRM Cotización** (V3 / actualizado V4) y **CRM Emisión** (+ V2) — formatos de endpoint y ejemplos.
- **CRM Especificación Grupo 1** — primer grupo de servicios.
- **HU206 — Control de Cambios / Excepciones Tributarias:** añade en el formulario "Vinculación de intermediarios" (pestaña *Información Bancaria / Impuestos*) el registro de **excepciones tributarias** por intermediario, con nombre e impuesto **parametrizables**. Impacta el cálculo de retenciones en Comisiones.

---

# 8. Gobierno, gestión y metodología

Este capítulo resume **cómo se gestiona el proyecto**: la metodología de trabajo, las fases, el gobierno, los hitos y los riesgos. Se presenta a nivel ejecutivo; el detalle contractual (valores, cláusulas) se mantiene en las fuentes originales de `01. Gobierno y gestión/`.

> 📐 **Fuentes:** `02 METODOLOGÍA DEL PROYECTO v1.3.pdf`, `Informe validación contractual.pdf`, matrices de riesgos y cronograma (`01. Gobierno y gestión/`).

## 8.1 Marco contractual (contexto)

La relación Positiva ↔ LinkTIC se desarrolló en **tres contratos consecutivos y un otrosí**, correspondientes a fases de implementación del core:

| Contrato | Año | Rol en el proyecto |
|---|---|---|
| **0082-2023** | 2023 | Fase inicial (arquitectura, primeros módulos). |
| **0324-2024** | 2024 | Continuidad (core asegurador, parametrización, automatización). |
| **0116-2025** | 2025 | Fase vigente (multi-ramo, despliegues). |
| **Otrosí No. 01** | 2025 | **Prórroga de 7 meses → hasta 31-jul-2026** (por 113+ HU pendientes de definición en Vida Individual y AP). Sin modificación del valor. |

> 🔒 Valores económicos, CDP y cláusulas se omiten aquí intencionalmente (documento de uso interno LinkTIC). Consultar `01. Gobierno y gestión/Contrato/` si se requiere el detalle.

## 8.2 Metodología del proyecto

GAIA opera bajo un **enfoque híbrido** (gestión tradicional por hitos + prácticas ágiles con Historias de Usuario). El flujo de trabajo estándar por funcionalidad:

```
Historia de Usuario → Verificación de requisitos → Aprobación de requisitos detallados
   → Implementación (con control de cambios) → Integración de servicios
   → Pruebas → Certificación → Despliegue → Estabilización / Soporte
```

Etapas definidas en la metodología (v1.3, ajustada tras el KickOff del 12-feb-2025):

1. **Definiciones estratégicas** — elaboración/aprobación de HU, estrategia de pruebas, infraestructura, alcance de parametrización, integraciones, prerrequisitos.
2. **Verificación de requisitos funcionales** por módulo.
3. **Aprobación de requisitos detallados.**
4. **Implementación** — con **procedimiento de control de cambios**.
5. **Integración de servicios.**
6. **Pruebas** — estrategia con cobertura automatizada (~60 %) + manual (~40 %).
7. **Certificación y despliegue.**

## 8.3 Reparto de responsabilidades

| LinkTIC | Positiva |
|---|---|
| Diseño, construcción, integración y pruebas de la solución. | Definición y **aprobación oportuna de HU** y requisitos. |
| Arquitectura de negocio, funcional y de solución. | Disponibilidad de usuarios funcionales clave. |
| Documentación y transferencia de conocimiento. | Accesos, información de sistemas e insumos. |
| Soporte evolutivo y correctivo. | Decisiones de alcance y priorización. |

> ⚠️ **Factor crítico recurrente:** la **aprobación oportuna de HU por parte de Positiva** es el principal cuello de botella (causa de la prórroga). La participación activa de los usuarios clave es un factor crítico de éxito.

## 8.4 Hitos y avance (matriz de cumplimiento)

Estado consolidado de las obligaciones principales del contrato 0116-2025 + Otrosí No. 01:

| Hito | Obligación | Estado | Evidencia |
|---|---|---|---|
| **Hito 1** | Acta de inicio, cronograma y equipo mínimo | ✅ Cumplida | Acta inicio 12-feb-2025 |
| **Hito 3** | Puesta en producción ramo **Vida Grupo** | ✅ Cumplida | Abr-2025 |
| **Hitos 5, 7** | Evidencias de integraciones internas/externas | ✅ Cumplida | Informes mensuales |
| **Hito 6** | Documento de definiciones estratégicas (operativo, seguridad, continuidad, migración) | ✅ Cumplida | Jul-2025 |
| **Hitos 5–10** | Informes mensuales de ejecución | ✅ Cumplida | Informes radicados |
| **Hito 10** | Informe de pruebas de rendimiento | ✅ Cumplida | Nov-2025 |
| **Hito 11** | Despliegue 100 % **Accidentes Personales** y **Vida Individual** | 🟡 En curso | Foco 2026 (hasta 31-jul-2026) |

## 8.5 Gobierno: capacidades críticas

| Capacidad | Criticidad | Justificación |
|---|---|---|
| Continuidad operativa | **Crítica** | Operación core aseguradora. |
| Seguridad | **Crítica** | Protección de información sensible. |
| Parametrización | Alta | Base del modelo multi-ramo. |
| Integración | Alta | Dependencia del ecosistema Positiva. |
| Escalabilidad | Alta | Incorporación de nuevos ramos. |
| Gobierno de datos | Alta | Integridad y trazabilidad. |
| Automatización | Alta | Reducción de operación manual. |
| SLA / soporte | Alta | Garantía de operación continua. |
| Migración | Alta | Continuidad del negocio (VI y Siniestros). |
| Gestión del cambio | Media | Adopción organizacional. |

## 8.6 Riesgos estratégicos

- Cambios no controlados de alcance.
- **Dependencia de SAP y de terceros** (integraciones).
- Riesgos regulatorios (SARLAFT y normativa del sector).
- **Retrasos en la aprobación funcional** de HU.
- Riesgos de facturación y flujo financiero.
- Dependencia de conocimiento especializado.

> Las matrices detalladas (interna y con cliente) están en `01. Gobierno y gestión/` (`Matriz de Riesgos…`, `2025 Matriz Interna de Riesgos…`).

## 8.7 Roadmap del proyecto (4 fases)

| Fase | Contenido |
|---|---|
| **1 – Inicio** | Kickoff, levantamiento funcional, definición de capacidades. |
| **2 – Construcción** | Refinamiento de HU, parametrización, desarrollo de módulos, integraciones. |
| **3 – Validación** | Pruebas funcionales, integrales y certificación. |
| **4 – Despliegue** | Salidas productivas, estabilización y soporte post-despliegue. |

---

# 9. Mesa de servicios y soporte

Describe el modelo de **soporte y operación** del Core Vida Positiva una vez en producción: niveles de atención, ciclo de vida del ticket, herramienta y **Acuerdos de Niveles de Servicio (ANS)**.

> 📐 **Fuentes:** `Mesa de Servicios/MANUAL DE SOPORTE v5.docx`, `Metodología de Soporte e Infraestructura de MS.docx`, `Anexo 2. ANS propuesto.pdf`, `416 Plan de soporte v1.docx`, `Formato Transición Proyectos a Soporte_V1.xlsx`.

## 9.1 Modelo de Mesa de Servicios (MS)

La operación de soporte se alinea con un enfoque tipo **ITIL** (Cadena de Valor del Servicio: Planear, Mejorar, Involucrar, Diseñar/Transición, Obtener/Construir, Entregar/Soportar). La gestión de tickets se realiza en la herramienta **Aranda Software** (plataforma de Positiva), donde LinkTIC recibe en línea incidentes y requerimientos.

## 9.2 Niveles de atención

| Nivel | Quién | Alcance |
|---|---|---|
| **Nivel 1** | Soporte de primer nivel | Resuelve el incidente **sin modificar el desarrollo** (parametrización, datos, orientación). |
| **Nivel 2** | Especialistas (equipo MS) | **Interviene el código** por errores de funcionalidad o mejoras autorizadas. |
| **Nivel 3** | Soporte especializado / equipo de desarrollo (vía líder técnico) | Incidentes que no resuelve el nivel 2; mejoras de fondo. |

## 9.3 Roles

- **Usuario** — solicita soporte por incidentes del sistema.
- **Coordinador de Soporte de Mesa (LinkTIC)** — enlace con Aranda; valida completitud de tickets, escalamiento, cumplimiento de ANS, cierre de calidad y mejora continua.
- **Líder Técnico** — delega en ingenieros front/back la atención de incidentes y problemas.

## 9.4 Ciclo de vida del ticket

```
Registro (usuario en Aranda) → Clasificación/categoría → Escalamiento por nivel
   → En proceso → Solucionado → Cerrado (validado por el usuario)
                              ↘ Pausado (info incompleta / escalamiento externo)
```

| Estado | Significado |
|---|---|
| **En proceso** | Asignado a un responsable según el nivel (escalado), trabajando en la solución. |
| **Solucionado** | Resuelto e informado al usuario. |
| **Cerrado** | Solución documentada en Aranda y **validada por el usuario** sin comentarios. |
| **Pausado** | Detenido por información incompleta o por escalamiento externo (cliente/proveedor). |

> El ticket debe incluir la cadena/desglose donde ocurre el incidente (**Ramo, Producto, Tipo**), síntomas, códigos de error y anexos (pantallazos).

## 9.5 Acuerdos de Niveles de Servicio (ANS)

Tiempos máximos de atención/entrega del plan de acción por tipo de caso:

| Severidad | Definición | Tiempo máx. |
|---|---|---|
| **Indisponibilidad** | El sistema dejó de funcionar en su totalidad. | **1 hora** |
| **Crítico** | Impide continuar; funcionalidad **crítica** para el negocio. | **2 horas** |
| **Alto** | Impide continuar, pero **no es** funcionalidad crítica. | **6 horas** |
| **Estándar** | No impide continuar, pero debe atenderse con prioridad. | **12 horas** |
| **Bajo** | No impide continuar y no requiere prioridad. | **24 horas** |

**Valor de aceptación:** cumplimiento **≥ 90 %** sin penalización. Por debajo del 90 % se aplica un **descuento del 1 %** del valor del servicio de soporte del mes de la incidencia.

> 📏 El **tiempo de respuesta** se mide entre el registro del plan de acción en Aranda y el cierre del caso por parte del usuario. Si un caso no puede resolverse en el tiempo de ANS, debe entregarse un **plan de acción** dentro de ese mismo tiempo.

## 9.6 Gestión de problemas

Un **problema** es la causa potencial de uno o más incidentes de Indisponibilidad/Criticidad (ANS nivel 1 y 2). Se gestiona con **análisis de causa raíz** y plan de acción; una vez implementado y probado, se incorpora al seguimiento como conocimiento para futuros incidentes.

## 9.7 Transición a soporte

El paso de proyecto a operación se formaliza con el **Formato de Transición de Proyectos a Soporte** y el **Plan de Soporte** (416), que definen alcance, equipo, herramientas (Aranda) y procedimientos operativos estándar antes de la salida a producción de cada ramo.

---

# 10. Anexos

## 10.1 Índice de documentos fuente

Mapa de las carpetas del repositorio y su contenido principal (insumo de este documento maestro):

### 00. Start Here
| Documento | Aporta a |
|---|---|
| `01_Guia de navegacion.pdf` | Estructura del repositorio. |
| `02_Overview_Proyecto.pdf` | Cap. 1 (contexto, objetivos, capacidades). |
| `03_Glorario.pdf` | Cap. 2 (glosario). |
| `04_Roadmap_general.pdf` | Cap. 1, 4, 8 (capacidades, productos, fases). |

### 01. Gobierno y gestión
| Documento | Aporta a |
|---|---|
| `02 METODOLOGÍA DEL PROYECTO v1.3.pdf` | Cap. 8 (metodología, fases, responsabilidades). |
| `Kickoff Proyecto Core GAIA.pptx` | Cap. 8 (inicio del proyecto). |
| `416 - GPR-FOR-010 Plan de Dirección del Proyecto (V.6).xlsx` | Cap. 8 (gestión). |
| `Cronograma 416 - CORE POSITIVA.xlsx` | Cap. 8 (hitos). |
| `Matriz de Riesgos…` / `2025 Matriz Interna de Riesgos…` | Cap. 8 (riesgos). |
| `Entregables Cierre Proyecto 416.xlsx` | Cap. 8 (entregables). |
| `Contrato/` (0082-2023, 0324-2024, 0116-2025, Otrosí, actas, pólizas) | Cap. 8 (marco contractual). |

### 02. Negocio
| Documento | Aporta a |
|---|---|
| `ARQUITECTURA SISTEMA DE SEGUROS.pdf` | Cap. 3 y 4 (arquitectura de negocio y funcional). |
| `Informe validación contractual.pdf` | Cap. 4, 8 (ramos, obligaciones, riesgos). |
| `*.drawio.png` (cadena valor, capacidades, modelo conceptual, vista negocio, E2E, estructura, AS-IS) | Cap. 3 y 6 (diagramas). |

### 03. Arquitectura de solución
| Documento | Aporta a |
|---|---|
| `ARQUITECTURA_01 SAD_POSITIVA_CORE_V3.6.pdf` | Cap. 6 (arquitectura de solución, C4, despliegue). |
| `Arquitectura_AS-IS_Positiva_Core.drawio.png` | Cap. 6 (estado actual). |

### 04. Producto – Funcional
| Documento / carpeta | Aporta a |
|---|---|
| `Manuales/` (Cotización, Emisión V2, Recaudo, Cartera, Comisiones, Novedades, Siniestros, Reaseguros, Manual Técnico) | Cap. 5 (módulos) y 6 (stack). |
| `Flujos/` (50+ BPMN/PNG por proceso y producto) | Cap. 5 (flujos). |
| `Integraciones/` (informe, contratos, especificaciones, APIs JSON/YAML, CRM) | Cap. 7 (integraciones). |
| `Mesa de Servicios/` (Manual de Soporte v5, ANS, Plan de soporte, Transición) | Cap. 9 (soporte). |

## 10.2 Matriz de trazabilidad capítulo → fuentes

| Capítulo | Fuentes principales |
|---|---|
| 1. Introducción | Overview, Roadmap, Validación contractual |
| 2. Glosario | Glosario, Arquitectura de negocio |
| 3. Modelo de negocio | Arquitectura de negocio y funcional, diagramas Negocio |
| 4. Productos | Roadmap, Validación contractual, `tipoProducto.xlsx` |
| 5. Módulos | Manuales de usuario, Flujos |
| 6. Arquitectura | SAD V3.6, Manual Técnico |
| 7. Integraciones | Informe de integraciones, APIs JSON/YAML, docs CRM |
| 8. Gobierno | Metodología, Validación contractual, matrices de riesgos |
| 9. Soporte | Manual de Soporte v5, ANS propuesto |

## 10.3 Mapa rápido de siglas del proyecto

`GAIA` (core asegurador) · `CRM` Wimbu/Odoo · `SAP` ERP · `SGDEA` gestión documental · `SARLAFT`/`FCC` cumplimiento · `RUES`/`NUIP` validación · `OFE` facturación electrónica · `RSOA/RSONA` reservas · `ANS/SLA` niveles de servicio · `HU` historia de usuario · `VI` Vida Individual · `AP` Accidentes Personales · `DIG` digitales.

## 10.4 Convenciones de este documento

- 📐 = referencia a la fuente original. ⚠️ = advertencia/aclaración. 🔒 = dato de uso interno. 💡/🧩 = nota para desarrolladores.
- Las imágenes incrustadas son versiones optimizadas para web; los originales en alta resolución están en las carpetas fuente.
- Diagramas SVG marcados como "elaboración propia" fueron creados para este documento maestro.

## 10.5 Notas de mantenimiento

Este documento es un **consolidado vivo**. Al actualizar:
1. Editar `DOCUMENTO_MAESTRO.md` (fuente Markdown).
2. Regenerar `index.html` (export navegable).
3. Registrar el cambio en `progress.md`.
4. Si cambia una decisión de alcance/arquitectura, revisar también `CLAUDE.md`.

> **Aviso de vigencia:** la documentación refleja el estado del proyecto a la fecha de las fuentes (2025–2026). Verificar contra el repositorio antes de tomar decisiones, especialmente en arquitectura (SAD evoluciona por versiones) e integraciones.

---

*Fin del Documento Maestro — Core Asegurador GAIA · LinkTIC S.A.S. · Uso interno.*
