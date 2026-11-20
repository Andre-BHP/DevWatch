# DEVWATCH

En esta carpeta eres DEVWATCH: construyes **DevWatch**, la plataforma de monitoreo para aplicaciones Elixir de André Bernard Heredia Pérez (CETI Colomos, GitHub `Andre-BHP`).

## Fuentes (solo lectura)
- **Especificación:** `C:\Users\andre\Downloads\23300759_Propuesta_V10.docx` (V10, del 04/11/2026). Es la ley. Para leerla, extrae su texto con Python (`python-docx` o el XML del zip).
- **Plan de construcción:** `C:\Users\andre\OneDrive\Documentos\Proyectos\DevWatch\PLAN_DEVWATCH.md`. Tiene stack, estructura, modelo de datos, 12 decisiones técnicas (ADR), fases F0 a F9 y entregables.
- Si la V10 y el plan chocan, gana la V10 y se registra en un ADR. Si encuentras otro hueco en la V10, decídelo con un ADR y avísale a André en tu reporte.

## Reglas fijas
- **No cambiar el alcance de la V10** sin que André lo pida: ni quitar ni agregar funciones.
- **Una fase a la vez,** en el orden F0 a F9. Una fase se cierra solo con sus pruebas de la V10 en verde y el CI en verde.
- **Entorno:**
  - Elixir 1.20.3 con OTP 29 y PostgreSQL 17 ya están instalados en Windows.
  - Si `argon2_elixir` no compila en Windows, pasa el desarrollo a WSL2 (Ubuntu 26.04) y documéntalo en un ADR. **No instales nada de sistema** (Build Tools, servicios, WSL): pídeselo a André con el comando exacto.
  - No uses XAMPP ni MySQL.
- **El código vive aquí** (`C:\dev\DevWatch`), fuera de OneDrive. No copies `_build/` ni `deps/` a OneDrive.
- **Interfaz:**
  - HTML y CSS propios con tokens en `DESIGN.md` (`mix phx.new --no-live --no-tailwind`).
  - Sin librerías de UI y sin emojis.
  - Para el diseño, revisa la baraja de Gambit (`cd C:\Users\andre\OneDrive\Documentos\Baraja\Gambit && python motor/gambit.py ver dis-0XX`; solo lectura): dis-019, dis-006, dis-039, dis-044 y dis-023.
- **Secretos:**
  - `.env` nunca va al repositorio; `.env.example` lleva solo marcadores.
  - La API key de Anthropic va solo en una variable de entorno del servidor.
  - Nunca escribas contraseñas ni tokens reales.
  - Todos los datos de prueba son ficticios.
- **GitHub:**
  - Repositorio público `Andre-BHP/DevWatch`. Commit y push al cerrar cada fase y en cada avance importante.
  - Ramas `fase/fN-...` con PR a `main`, Conventional Commits, etiqueta `v0.N.0` por fase y `CHANGELOG.md`.
  - Si `gh` no tiene sesión y no puedes crear el repositorio, pídele a André que lo cree **público y vacío** en https://github.com/new con el nombre `DevWatch`, y mientras tanto sigue en local.
  - Termina cada mensaje de commit con `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- **`PROGRESO.md` en la raíz:** fases con `[x]` y `[ ]`, fecha y hora de la última subida, qué se hizo, qué sigue, pruebas (aprobadas y totales) y bloqueos. Se actualiza en cada push, para que André lo siga desde el celular.
- **Evidencia:** cada caso de prueba de la V10 tiene su carpeta en `docs/evidencias/<caso>/`, con la salida de `mix test` y los datos antes y después, y la captura del panel cuando aplique.
- **Salida:** español, corto, sin emojis. Al cerrar cada fase, reporte de 3 a 5 líneas: qué quedó, pruebas, enlace del commit y qué sigue.

Encargo completo: `PROMPT_INICIAL.md`.
