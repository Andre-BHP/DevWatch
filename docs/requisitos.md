# Requisitos de DevWatch (V10)

Fuente única: `23300759_Propuesta_V10.docx` (V10, 04/11/2026), punto 7 (módulos y pruebas) y punto 10 (tecnologías, nombres y códigos). Esta lista **no amplía ni recorta** la V10: la reordena y numera para usarla como base de los issues, las pruebas y el reporte.

- `RF-xx`: requisito funcional, agrupado por módulo.
- `RNF-xx`: requisito no funcional (límites, seguridad, tecnología).
- `PR-xx`: caso de prueba de la V10, agrupado por tipo de prueba. Cada caso tiene su carpeta de evidencia en `docs/evidencias/PR-xx/`.
- **Fase**: fase del plan (F0 a F9) en la que se implementa o se cierra.

Las decisiones que la V10 deja abiertas están en `docs/adr/`.

---

## 1. Glosario mínimo (V10, punto 7)

| Término | Significado en DevWatch |
|---|---|
| Captura | Registro de lo que ocurre en una ejecución observada: resultado, tiempo e información de rechazo o fallo |
| Paquete de captura | `integrations/devwatch_capture`, código que hace la captura y la envía |
| Función de captura | `DevWatchCapture.medir/3`, se coloca alrededor del código observado |
| Función de mensajes | `DevWatchCapture.mensaje/3`, envía un mensaje independiente |
| Punto de captura | Lugar exacto del programa donde se colocó la función de captura |
| Operación | Acción con inicio y final dentro de una función de captura |
| Aparición | Cada ejecución concreta de una operación, o cada mensaje independiente. Su identificación (UUID v4) la genera el paquete al llamar a la función, antes de ejecutar la operación |
| Resumen | Datos que la captura arma al terminar una aparición y envía en JSON |
| Receptor | `POST /api/eventos` de la plataforma |
| Evento | Registro guardado al aceptar por primera vez el resumen de una aparición. Tipos: operación completada, operación fallida, mensaje independiente |
| Diagnóstico | Emisor + código + mensaje con los que un componente explica un rechazo |
| Señal | Dato del resumen que comparan las reglas: resultado, nivel, diagnóstico, estado web, tipo de error, duración. La descripción **no** es señal |
| Incidencia | Seguimiento de un problema que reúne apariciones equivalentes |
| Ficha | Registro de una aplicación observada |
| Panel | Página donde se consulta la información de una ficha |

---

## 2. Requisitos funcionales

### 2.1 Módulo de cuentas y aplicaciones

| Id | Requisito | Fase |
|---|---|---|
| RF-01 | Crear cuenta con nombre, correo y contraseña, los tres obligatorios | F0 |
| RF-02 | Al registrar, validar datos completos, formato de correo y que el correo no pertenezca a otra cuenta | F0 |
| RF-03 | La contraseña tiene entre 12 y 128 caracteres y se guarda solo su huella con Argon2id y sal aleatoria | F0 |
| RF-04 | Iniciar sesión con correo y contraseña; crear una sesión (registro con valor aleatorio asociado a la cuenta) guardada en cookie firmada | F0 |
| RF-05 | Cerrar sesión elimina el registro de la sesión y el valor del navegador deja de servir | F0 |
| RF-06 | En cada consulta o modificación, la ficha se busca solo entre las de la cuenta; si es de otra, se responde como si no existiera | F1 |
| RF-07 | Cada cuenta da de alta hasta cinco fichas; al intentar la sexta se indica que se alcanzó el límite | F1 |
| RF-08 | La ficha tiene identificación interna, nombre obligatorio, descripción opcional, límites de duración y huella de su clave | F1 |
| RF-09 | Al crear la ficha se genera una clave (32 bytes aleatorios) que se muestra una sola vez; se guarda solo su huella SHA-256 | F1 |
| RF-10 | Cada clave está vigente o revocada; cada ficha tiene una sola clave vigente; generar otra revoca la anterior y conserva los eventos | F1 |
| RF-11 | Listado de fichas de la cuenta; al seleccionar una se abre su panel; antes del primer envío muestra «Sin eventos recibidos» | F1 |
| RF-12 | Dos fichas pueden tener el mismo nombre y siguen separadas por identificación y clave | F1 |
| RF-13 | Editar nombre, descripción y límites de duración, y generar una clave nueva | F1 / F6 |
| RF-14 | No se pueden eliminar fichas ni cuentas | F1 |
| RF-15 | Límite de advertencia y crítico por ficha en ms; iniciales 1,000 y 3,000; positivos, crítico > advertencia, ninguno > 3,600,000 | F1 |
| RF-16 | Los límites se aplican a ambos entornos; cada evento guarda los límites vigentes al recibirlo | F1 / F3 |
| RF-17 | Tablas: cuentas, sesiones, fichas, claves, eventos, identificaciones recientes (24 h), incidencias, historial de estados y notas, apariciones recientes, recuentos por incidencia y minuto, alertas y acumulados por minuto | F1–F5 |

### 2.2 Módulo de captura y envío (paquete `devwatch_capture`)

| Id | Requisito | Fase |
|---|---|---|
| RF-18 | El paquete se entrega en el repositorio público con la guía de uso y la demo; se instala copiando su carpeta y declarándolo como dependencia local en `mix.exs` | F1 / F9 |
| RF-19 | Cuatro ajustes leídos al iniciar desde `config/runtime.exs`: dirección del receptor, clave (de `DEVWATCH_KEY`), entorno (desarrollo o pruebas) y nombre de la aplicación | F1 |
| RF-20 | Si falta la clave, se escribe un aviso en la consola y no se envían resúmenes, sin detener la aplicación | F2 |
| RF-21 | Cinco partes: función de captura, función de mensajes, adaptador de base de datos, adaptador web, emisor y supervisor (`application.ex`) | F1–F2 |
| RF-22 | `medir(operacion, adaptador, fun)`: genera la identificación, lee el reloj monotónico, ejecuta, vuelve a leer, entrega la respuesta al adaptador, arma el resumen, lo pasa al emisor y **devuelve la misma respuesta** | F1 |
| RF-23 | El tiempo de envío no forma parte de la duración; una operación que nunca termina no produce resumen | F1 |
| RF-24 | El adaptador traduce la respuesta a: resultado (completada o fallida), origen, diagnóstico opcional y descripción. El resultado sale de la respuesta real, nunca del nombre | F1 |
| RF-25 | Excepciones: `try/rescue`, tipo, mensaje y traza con `__STACKTRACE__`, resumen fallido con nivel error y `reraise`. `throw` y `exit` se atrapan con `catch`, se registran como fallidas (categoría desconocido) y se dejan continuar | F2 |
| RF-26 | Traza: lista ordenada de referencias (módulo, función, archivo, línea); nunca el contenido de archivos | F2 |
| RF-27 | Orígenes: base de datos, servicio externo (con nombre obligatorio), aplicación, comprobación de red y desconocido | F1 |
| RF-28 | Adaptador Postgres: conserva código SQLSTATE, mensaje y origen base de datos | F2 |
| RF-29 | Adaptador HTTP: lee el estado de la ruta propia o del servicio externo (con su nombre); sin estado, conserva el motivo de comunicación (conexión rechazada, nombre no resuelto, tiempo agotado) | F2 |
| RF-30 | Una llamada interna a una dependencia no lleva otra captura: su diagnóstico se incorpora al resumen de la operación principal, que envía una sola vez | F2 / F7 |
| RF-31 | Solo se incorporan diagnósticos que explican el resultado final; en ruta protegida la captura abarca identidad, permisos y operación | F7 |
| RF-32 | Datos obligatorios: identificación, lenguaje (Elixir), entorno, tipo (operación o mensaje), operación, origen, descripción y nivel; una operación además resultado y duración | F1 / F2 |
| RF-33 | `mensaje(nivel, descripcion, contexto)`: el paquete añade identificación, entorno y origen (aplicación salvo que se indique otro); sin duración | F1 |
| RF-34 | Niveles: detalle, información, advertencia, error y fatal. Captura asigna información a completada y error a fallida | F1 |
| RF-35 | Datos opcionales: fecha y hora de fin (equipo del usuario), ruta web, módulo y función, estado web, diagnóstico (con emisor obligatorio), tipo y mensaje de excepción, traza | F2 |
| RF-36 | El emisor envía cada resumen en una tarea separada; espera hasta 5 s por intento | F1 / F2 |
| RF-37 | Sin respuesta o con 503: hasta tres reintentos tras 1, 2 y 4 s; con 429 espera lo que indique el receptor dentro de esos reintentos; todos con la misma identificación y contenido | F2 |
| RF-38 | Clave inválida o dato incorrecto (401, 400, 409, 413, 415, 422) no se reintentan: aviso local en la consola | F2 |
| RF-39 | Al agotar reintentos, aviso local de aparición sin confirmación de entrega; si la plataforma no está, la aplicación sigue funcionando | F2 |
| RF-40 | Supervisor que inicia las tareas de envío y las reinicia sin afectar la operación observada | F2 |

### 2.3 Módulo de recepción y validación

| Id | Requisito | Fase |
|---|---|---|
| RF-41 | `POST /api/eventos`, JSON UTF-8, `Content-Type: application/json`, clave en `Authorization: Bearer` | F1 |
| RF-42 | Calcula la huella de la clave y busca la ficha con esa clave vigente; si no existe, 401 | F1 |
| RF-43 | Comprueba datos obligatorios, valores admitidos y coherencia; rechaza indicando el dato incorrecto (422) | F2 |
| RF-44 | Valores admitidos: lenguaje Elixir; entorno desarrollo o pruebas; tipo operación o mensaje; resultado completada o fallida; 5 niveles; 5 orígenes; duración entera no negativa en ms; estado web válido | F2 |
| RF-45 | Incoherencias: operación sin resultado o sin duración; mensaje con duración; servicio externo sin nombre; diagnóstico sin emisor; diagnóstico de validación sin motivo; operación completada con excepción, diagnóstico de fallo reconocido, estado web de fallo o nivel error o fatal | F2 |
| RF-46 | Lenguaje distinto: «Lenguaje no soportado». Entorno distinto: «Entorno no admitido». Ningún rechazo modifica conteos | F2 |
| RF-47 | Descripción hasta 2,000 caracteres, traza hasta 8,000, resumen hasta 16,384 bytes; el rechazo indica si es un texto o el tamaño total | F2 |
| RF-48 | Límite de 600 eventos nuevos por minuto completo del servidor por ficha (ambos entornos); al alcanzarlo se informa cuánto falta (429) | F2 |
| RF-49 | Durante 24 h se conserva identificación y huella de contenido; misma identificación y contenido: 200 sin cambiar conteos (antes del límite por minuto); contenido diferente: 409 | F2 |
| RF-50 | El resumen nuevo pasa al motor; evento, incidencia e incrementos se guardan en una sola transacción; solo después se confirma (201) | F1 / F4 |
| RF-51 | La base impide guardar dos veces la misma identificación por ficha; dos apariciones simultáneas no abren dos incidencias; contadores por turno; si el guardado falla, se deshace todo y se responde 503 | F2 / F4 |
| RF-52 | La plataforma registra con su reloj (UTC) la hora de recepción, aparte de la fecha que informa la aplicación | F1 |
| RF-53 | Códigos: 201 nuevo, 200 reenvío, 400 mal formado, 401 clave, 409 conflicto, 413 tamaño, 415 tipo, 422 dato, 429 límite, 503 falla temporal | F2 |

### 2.4 Motor de reglas

| Id | Requisito | Fase |
|---|---|---|
| RF-54 | Catálogo de reglas (id, evidencia, condición, categoría, explicación) con número de versión; cada evento guarda la versión | F3 |
| RF-55 | `evaluar/2` recibe el resumen validado y los límites; devuelve fallo, demora, categoría, regla, evidencia y explicación | F3 |
| RF-56 | Categorías: base de datos, servicio externo, autenticación y acceso, validación, conexión, ejecución, rendimiento y desconocido | F3 |
| RF-57 | Cinco pasos: evidencia de fallo; comparar duración; primera regla de fallo que coincide; si solo hay demora, rendimiento; si nada, actividad normal | F3 |
| RF-58 | Evidencia de fallo en mensaje: nivel error o fatal, excepción, diagnóstico de fallo del catálogo o estado web 4xx/5xx | F3 |
| RF-59 | Demora: < advertencia normal; ≥ advertencia y < crítico, advertencia; ≥ crítico, crítica. Fallida y lenta conserva su categoría y lleva marca de demora | F3 |
| RF-60 | Orden: base de datos, servicio externo, autenticación y acceso, validación, conexión, ejecución; sin coincidencia, desconocido | F3 |
| RF-61 | Base de datos: origen base de datos y diagnóstico reconocido (23505, 23503, 23502, 08006, 40P01, 42501, 42601), error del controlador o fallo de comunicación; otro código conserva la categoría sin explicación específica | F3 |
| RF-62 | Servicio externo: origen servicio externo con nombre y estado 4xx/5xx o fallo de comunicación; explica 503, 401 y 403; para otros muestra el número e indica rechazo o falla; conserva el nombre | F3 |
| RF-63 | Autenticación y acceso: origen aplicación con 401 (sin identidad) o 403 (sin permiso), o diagnóstico de acceso con motivo sin identidad o sin permiso | F3 |
| RF-64 | Validación: origen aplicación con diagnóstico de validación (motivo y descripción); explicación propia para folio ausente, vehículo ocupado, renta inexistente y devolución repetida; otro motivo conserva la categoría | F3 |
| RF-65 | Un 400 o 422 sin diagnóstico de validación queda en desconocido si no coincide otra regla | F3 |
| RF-66 | Conexión: conexión rechazada, nombre no resuelto, tiempo agotado, 408 y 504; orígenes aplicación, comprobación de red y desconocido | F3 |
| RF-67 | Ejecución: `ArithmeticError`, `UndefinedFunctionError`, `ArgumentError`, `MatchError`; otra excepción conserva nombre y mensaje y queda en desconocido | F3 |
| RF-68 | Explicación con texto preparado; ejemplo: «La operación registrar renta falló: la base de datos rechazó un folio duplicado» | F3 |
| RF-69 | Ubicación: primera referencia de la traza que pertenece a la aplicación configurada; se conserva el orden de todas; solo función si es lo único; «Ubicación no disponible» si no hay | F3 |
| RF-70 | `catalogo_de_reglas.md` se publica y se mantiene al día con el catálogo | F3 |

### 2.5 Módulo de incidencias y prioridad

| Id | Requisito | Fase |
|---|---|---|
| RF-71 | Evento con fallo o demora abre o actualiza una incidencia según la firma: ficha, entorno, operación, categoría, origen, módulo y dependencia cuando existen | F4 |
| RF-72 | Distintivo en orden: diagnóstico con emisor; tipo de excepción con traza; estado web; descripción. Se normalizan espacios; rendimiento agrupa por operación y origen | F4 |
| RF-73 | Huella SHA-256 de la firma más comparación de todos sus componentes; la decisión se guarda junto con la aparición | F4 |
| RF-74 | Firma existente: suma aparición y actualiza última fecha; nueva: incidencia activa | F4 |
| RF-75 | Estados activa, en revisión y resuelta; notas; fecha de cada cambio; aparición nueva en resuelta la reabre | F4 |
| RF-76 | Severidad con apariciones de los últimos 5 min del servidor (excluye las de 5 min o más); puntaje = nivel + frecuencia + mayor aporte técnico, máximo 100 | F4 |
| RF-77 | Nivel: detalle/información 0, advertencia 10, error 25, fatal 40; fallo al menos 25; solo lentitud al menos 10 | F4 |
| RF-78 | Frecuencia: 1–4 → 0; 5–19 → 10; 20–49 → 20; ≥ 50 → 30 | F4 |
| RF-79 | Técnico (mayor): 4xx 10, 5xx 30, demora advertencia 8, demora crítica 15 | F4 |
| RF-80 | Rangos: 0–24 baja, 25–49 media, 50–74 alta, 75–100 crítica; fatal al menos 75; el detalle muestra cada aporte | F4 |
| RF-81 | Tres procesos periódicos: cada minuto (severidad y alertas), cada hora (identificaciones > 24 h), diario (acumulados y recuentos > 30 días) | F4 / F5 |
| RF-82 | Intervalo vacío: «Sin actividad reciente» y última severidad marcada como anterior | F4 |
| RF-83 | Alertas: en 5 min, 75 puntos, 20 apariciones, 5 operaciones con demora crítica o nivel fatal; cada condición por separado; se crea al cumplirse, se actualiza mientras se mantiene, se crea otra si vuelve a cumplirse | F4 |
| RF-84 | Alertas al inicio del panel con contador de no leídas; marcar como leídas; ver condición y valor; sin correos | F4 / F6 |

### 2.6 Módulo de consulta y métricas

| Id | Requisito | Fase |
|---|---|---|
| RF-85 | Elegir ficha, entorno y periodo en los últimos 30 días, en minutos completos | F5 / F6 |
| RF-86 | Métricas: total de eventos, eventos con fallo, operaciones medidas, fallidas, lentas, % fallidas, duración promedio, incidencias con actividad, activas o en revisión | F5 |
| RF-87 | Incrementos por evento según tipo; mensaje no suma a operaciones ni tiempos; fallida y lenta cuenta en ambos | F5 |
| RF-88 | Acumulados por minuto de recepción y combinación ficha, entorno y operación; % = fallidas / medidas × 100; promedio = suma / medidas; «Sin datos» sin operaciones | F5 |
| RF-89 | Recuento por incidencia y minuto durante 30 días; incidencias con actividad = identificaciones distintas con apariciones | F5 |
| RF-90 | Lista de eventos del más reciente al más antiguo por recepción: fecha, operación, resultado, categoría, duración y descripción; filtro por entorno y periodo; enlace a su incidencia | F1 / F6 |
| RF-91 | Incidencias filtrables por entorno, categoría, severidad y estado; detalle con apariciones conservadas, explicación, ubicación, puntaje y notas | F6 |
| RF-92 | Panel abierto y visible pide actualizaciones cada 5 s; si falla, conserva datos con su hora e indica actualización pendiente | F6 |
| RF-93 | Detalle de los 5,000 eventos más recientes por ficha (ambos entornos); el panel indica cuándo el texto ya no está disponible; incidencias sin vencimiento | F5 |
| RF-94 | Límites de 600 por minuto y 5,000 detalles compartidos por la ficha; métricas por entorno | F5 |

### 2.7 Módulo de consulta asistida

| Id | Requisito | Fase |
|---|---|---|
| RF-95 | Conversación en el detalle de la incidencia y en una página de ayuda, con Claude Haiku 5.5 por la API de mensajes usando Req | F8 |
| RF-96 | Comprueba que la incidencia es de la cuenta; solicitud con instrucciones fijas, guía y catálogo completos (en caché), datos de la incidencia (hasta 5 descripciones recientes) y pregunta | F8 |
| RF-97 | Respuesta que separa causas posibles de señales observadas; no modifica clasificación, agrupación, puntaje ni alertas | F8 |
| RF-98 | Filtro que oculta valores con etiquetas de contraseña, clave o credencial y textos con forma de correo; los mensajes de eventos se tratan como datos | F8 |
| RF-99 | Sin ubicación, la respuesta lo dice; si el servicio falla, «No se pudo obtener respuesta» y permite reintentar; el asistente es opcional | F8 |

### 2.8 Aplicación de demostración

| Id | Requisito | Fase |
|---|---|---|
| RF-100 | Rentas de vehículos ficticios en Elixir con pantallas propias y una base por entorno (desarrollo y pruebas) | F1 / F7 |
| RF-101 | Tablas vehículos (identificación, descripción, estado) y rentas (folio único, vehículo, estado, fechas de inicio y devolución) | F1 / F7 |
| RF-102 | Operaciones: consultar disponibilidad, registrar renta y registrar devolución; las dos últimas en una transacción | F1 / F7 |
| RF-103 | Validaciones: folio ausente, vehículo ocupado, renta inexistente y devolución repetida | F7 |
| RF-104 | Entorno de pruebas: ruta protegida con dos identidades ficticias, servicio controlado (correcto, sin credenciales, no disponible, lento) y comprobación TCP con `gen_tcp` | F7 |
| RF-105 | Folio duplicado real: en pruebas un folio ya registrado llega hasta la base con otro vehículo libre | F7 |
| RF-106 | Restablecer la base de pruebas sin alterar la de desarrollo | F7 |
| RF-107 | `medir(:registrar_renta, &RentasDemo.Adaptador.renta/1, fn -> guardar_renta(datos) end)` en `lib/rentas_demo/rentas.ex` | F1 |

---

## 3. Requisitos no funcionales

| Id | Requisito | Fase |
|---|---|---|
| RNF-01 | Elixir y Erlang/OTP en las tres piezas; Phoenix sin LiveView; PostgreSQL con Ecto (plataforma) y Postgrex (demo) | F0 |
| RNF-02 | Archivos y módulos del punto 10: `accounts.ex`, `applications.ex`, `event_controller.ex`, `events/validator.ex`, `rules.ex` (`evaluar`), `incidents.ex`, `metrics.ex`; paquete `devwatch_capture.ex`, `adapters/postgres.ex`, `adapters/http.ex`, `sender.ex`, `application.ex` | F0–F5 |
| RNF-03 | Migraciones en `priv/repo/migrations`, aplicadas con `mix ecto.migrate` | F0 |
| RNF-04 | Paquete con `mix.exs` propio, nombre `devwatch_capture`, dependencias Req y Postgrex opcional; avisos con Logger | F1 |
| RNF-05 | HTTPS entre paquete y receptor en despliegue | F9 |
| RNF-06 | UUID v4 con `:crypto`; horas en UTC; SHA-256 para claves, contenidos y firmas; claves de 32 bytes; Argon2id para contraseñas | F0–F4 |
| RNF-07 | Panel en HTML y CSS propios, JavaScript solo para la consulta cada 5 s; cookie de sesión firmada | F6 |
| RNF-08 | Interfaz con etiquetas claras, mensajes que expliquen datos incorrectos, uso completo con teclado y estados con texto además de color | F6 |
| RNF-09 | HTML siempre escapado: descripciones con instrucciones para el navegador se muestran como texto | F6 |
| RNF-10 | Capacidad: 5 apariciones/s por 5 min (1,500); meta ≥ 1,425 aceptadas con respuesta ≤ 1 s y todos los confirmados contados | F9 |
| RNF-11 | Pruebas con ExUnit (`_test.exs`, `assert`, `mix test`); el esperado se escribe como valor concreto | F0–F9 |
| RNF-12 | Docker para reunir plataforma, demo y bases | F9 |
| RNF-13 | Repositorio público en GitHub con paquete, guía, demo y versiones descargables; sin publicar en Hex | F0 / F9 |
| RNF-14 | `guia_de_uso.md` y `catalogo_de_reglas.md` en Markdown | F3 / F9 |
| RNF-15 | La API key del asistente solo en una variable de entorno del servidor | F8 |
| RNF-16 | Costo de referencia: 12 USD/mes servidor y 2 USD/mes IA | F9 |

---

## 4. Casos de prueba de la V10

Cada caso define antes de ejecutarse su preparación, acción y resultado esperado como valor concreto. La evidencia va en `docs/evidencias/PR-xx/`.

### 4.1 Unitarias

| Id | Caso | Resultado esperado | Fase |
|---|---|---|---|
| PR-01 | Por cada regla, un resumen que cumple y otro que no | Categoría, regla y explicación esperadas en el que cumple; otra salida en el que no | F3 |
| PR-02 | Siete diagnósticos de base de datos (23505, 23503, 23502, 08006, 40P01, 42501, 42601) | Categoría base de datos con explicación específica de cada uno | F3 |
| PR-03 | Cuatro excepciones (`ArithmeticError`, `UndefinedFunctionError`, `ArgumentError`, `MatchError`) | Categoría ejecución | F3 |
| PR-04 | Cuatro motivos de validación de la demo y uno fuera del catálogo | Validación con explicación propia; el desconocido conserva validación con su motivo y descripción | F3 |
| PR-05 | Estados de acceso (401, 403) y de servicio externo (401, 403, 503 y otros) | Autenticación y acceso; servicio externo con nombre | F3 |
| PR-06 | Salida desconocido, orden de prioridad y descripción que solo menciona la base de datos | Desconocido; la regla más específica gana; la descripción no cambia la categoría | F3 |
| PR-07 | Duraciones 999, 1,000, 2,999 y 3,000 ms con límites iniciales | Normal, advertencia, advertencia, crítica | F3 |
| PR-08 | Cambiar los límites de la ficha | Eventos nuevos usan los nuevos; anteriores conservan los suyos | F3 |
| PR-09 | Frecuencia con 4 y 5, 19 y 20, 49 y 50 apariciones | 0/10, 10/20, 20/30 | F4 |
| PR-10 | Severidad con 24 y 25, 49 y 50, 74 y 75 puntos | baja/media, media/alta, alta/crítica | F4 |

### 4.2 Integración

| Id | Caso | Resultado esperado | Fase |
|---|---|---|---|
| PR-11 | Resúmenes válidos al receptor | 201, evento guardado y conteos aumentados; diez envíos suman diez | F1 / F2 |
| PR-12 | Quitar un dato obligatorio o introducir incoherencia: clave inválida, otro lenguaje, duración negativa, servicio externo sin nombre, completada con señales de fallo | Rechazo con su motivo; conteos sin cambio | F2 |
| PR-13 | Límites de tamaño, incluido texto con acentos dentro de caracteres y fuera de bytes | 422 por texto o 413 por tamaño total; conteos sin cambio | F2 |
| PR-14 | Mismo caso en desarrollo y en pruebas | Filtros separados; una incidencia por entorno; límites compartidos por ficha; entorno no admitido rechazado; restablecer pruebas no altera desarrollo | F2 / F7 |
| PR-15 | Mismo resumen dos veces; misma identificación con otro contenido | Un solo evento (200 en el segundo); 409 en el conflicto | F2 |
| PR-16 | Falla provocada durante el guardado | Transacción deshecha; 503; el reintento deja un único resultado completo | F2 |
| PR-17 | Varias apariciones simultáneas del mismo problema | Una sola incidencia con el número exacto de apariciones | F4 |

### 4.3 Funcionales

| Id | Caso | Resultado esperado | Fase |
|---|---|---|---|
| PR-18 | Instalación: copia de la demo sin paquete; se agrega, se configura y se compila; función antes y después de la captura | Solo la segunda produce evento en la ficha correcta; misma respuesta en ambas | F1 / F7 |
| PR-19 | Consultar disponibilidad con tres vehículos (uno ocupado); después todos ocupados | Lista con los dos libres; después lista vacía; operación completada | F7 |
| PR-20 | Registrar renta con folio nuevo; registrar devolución | Una renta guardada y vehículo ocupado; renta terminada y vehículo disponible; cada acción con su evento, resultado y duración | F1 / F7 |
| PR-21 | Renta sin folio, vehículo ocupado, folio inexistente y devolución repetida | Motivo mostrado, datos sin cambio, categoría validación | F7 |
| PR-22 | Folio duplicado real tres veces y reenvío de uno | Tres rechazos, tres eventos, una incidencia de base de datos con tres apariciones; el reenvío no cambia nada | F7 |
| PR-23 | División entre cero, función inexistente, argumento no admitido, forma no esperada | Categoría ejecución; archivo y línea reales | F7 |
| PR-24 | Resumen sin ubicación | «Ubicación no disponible» | F3 / F7 |
| PR-25 | Esperas reales de 1,500 y 3,500 ms; fallo y demora a la vez | Duración incluye la espera; advertencia y crítica; un solo evento con ambas señales | F7 |
| PR-26 | Ruta protegida sin identidad, sin permiso y autorizada | Dos rechazos sin ejecutar la operación (autenticación y acceso); el tercero ejecuta y produce una aparición | F7 |
| PR-27 | Servicio controlado: correcto, sin credenciales, no disponible | Los dos rechazos conservan el nombre y la categoría servicio externo | F7 |
| PR-28 | Servicio detenido: comprobación TCP, llamada al servicio y conexión a base de datos | Conexión, servicio externo y base de datos | F7 |
| PR-29 | Respuesta retrasada más allá del plazo y nombre de destino inexistente | Motivo capturado coincide con la explicación | F7 |
| PR-30 | Respuesta de falla de la propia aplicación sin otra señal | Desconocido | F7 |
| PR-31 | Repetir un problema, cambiar su entorno y luego sus datos distintivos | Se actualiza o se crea la incidencia esperada en cada paso | F4 / F7 |
| PR-32 | En revisión, nota, resuelta y nueva aparición | Historial con fechas; reapertura a activa | F4 / F7 |
| PR-33 | Firma por traza (cambiar una línea) y por diagnóstico | Traza: otra incidencia; diagnóstico: misma; contadores, fechas e historial correctos | F4 / F7 |
| PR-34 | Cada una de las cuatro condiciones de alerta; mantener, marcar leída, adelantar reloj y repetir | Mismo aviso mientras se mantiene; aviso nuevo al volver a cumplirse | F4 |
| PR-35 | Reloj controlado: límite exacto de 5 min, identificaciones 24 h y acumulados 30 días | Se excluye la aparición de 5 min exactos; se borran solo los vencidos | F4 / F5 |
| PR-36 | 6 completadas, 1 fallida y 3 mensajes de error; después 1 mensaje de advertencia | 10 eventos, 4 con fallo, 7 medidas, 1 fallida, 14.29 %; dos incidencias; la advertencia solo suma al total | F5 |
| PR-37 | 5,001 eventos entre ambos entornos | 5,000 detalles, 5,001 aportaciones en acumulados, incidencias del periodo sin cambio | F5 |
| PR-38 | 600 eventos nuevos en un minuto | El 601 recibe 429 hasta el minuto próximo; los reenvíos siguen con 200 | F2 |
| PR-39 | Operación fallida que supera el límite crítico; su reenvío; resolver la incidencia | +1 en eventos, con fallo, medidas, fallidas y lentas; una aparición; reenvío sin cambios; resolver no cambia valores | F5 |
| PR-40 | Asistente: preguntas sobre la guía e incidencias completas e incompletas | Respuestas coherentes con la regla y los datos; dice cuando falta ubicación | F8 |
| PR-41 | Asistente: secretos ficticios e instrucciones dentro de un evento | Secretos ocultos antes del envío; instrucción tratada como dato | F8 |
| PR-42 | Asistente: falla simulada; misma entrada con y sin conversación | «No se pudo obtener respuesta», panel funcionando; misma clasificación y puntaje | F8 |

### 4.4 Seguridad

| Id | Caso | Resultado esperado | Fase |
|---|---|---|---|
| PR-43 | Dos cuentas: abrir ficha ajena desde la pantalla y por solicitud directa | Respuesta como si no existiera (404 idéntico) | F1 / F6 |
| PR-44 | Revocar clave y generar otra | La anterior recibe 401; historial conservado | F1 / F6 |
| PR-45 | Cerrar sesión | El valor anterior ya no sirve | F0 / F6 |
| PR-46 | Descripciones con instrucciones para el navegador | Se muestran como texto sin ejecutarse | F6 |

### 4.5 Capacidad, usabilidad y regresión

| Id | Caso | Resultado esperado | Fase |
|---|---|---|---|
| PR-47 | 5 apariciones distintas por segundo durante 5 min (1,500) | ≥ 1,425 aceptadas con respuesta ≤ 1 s; confirmados = guardados | F9 |
| PR-48 | Tres compañeros siguen la guía: ficha, paquete, operación, evento, incidencia y estado; solo teclado; actualización interrumpida | Anotaciones de ayuda; todo por teclado; aviso y última hora conservada | F9 |
| PR-49 | Regresión: repetir el caso corregido y los relacionados después de cada corrección | Todos siguen aprobando (CI completo en cada push) | F0–F9 |

---

## 5. Huecos detectados y su decisión

| Hueco de la V10 | Decisión |
|---|---|
| Orden de comprobaciones del receptor cuando hay varios errores | ADR-003 |
| Cómo comparar el "mismo contenido" de un reenvío | ADR-001 (JSON canónico) |
| Memoria del emisor si la plataforma no está disponible | ADR-008 (cola acotada) |
| `argon2_elixir` no compila en Windows sin MSVC | ADR-013 (desarrollo en WSL2) |
| La V10 no menciona confirmación de correo ni acceso por enlace mágico | ADR-014 (se retiran del generador para no ampliar el alcance) |
