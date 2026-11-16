# DESIGN.md: sistema visual de DevWatch

Tokens fijados antes de construir (Gambit dis-019). El archivo que los aplica es `devwatch/priv/static/css/app.css`; ningún componente usa valores sueltos.

## Principios
1. **Monocromo con un solo acento** (dis-006). Blanco, negro y grises; el acento naranja marca solo la acción principal o el indicador que pide atención en cada pantalla.
2. **Severidad siempre con texto.** Los colores de severidad (baja, media, alta y crítica) acompañan una etiqueta escrita; nunca son la única señal (V10, punto 9).
3. **Mono solo con datos reales** (dis-039): duraciones, códigos HTTP y SQLSTATE, horas, identificaciones y puntajes. Cifras con `font-variant-numeric: tabular-nums`.
4. **Índice en páginas largas** (dis-044): el detalle de la incidencia tiene un índice con anclas y la sección activa marcada.
5. **Sin adornos animados** (dis-023): solo transiciones de 150 a 200 ms en lo que acciona la persona (foco, abrir, confirmar). Se respeta `prefers-reduced-motion`.
6. **Sin librerías de UI, sin emojis, sin fuentes externas** (la CSP solo permite recursos propios).

## Tokens

### Color
| Token | Claro | Oscuro | Uso |
|---|---|---|---|
| `--fondo` | `#ffffff` | `#0f1012` | Fondo de página |
| `--superficie` | `#f6f6f7` | `#17181b` | Tarjetas, tablas, campos |
| `--borde` | `#dcdde0` | `#2c2e33` | Bordes y separadores |
| `--texto` | `#111214` | `#ececee` | Texto principal |
| `--texto-tenue` | `#5c5f66` | `#a1a4ab` | Texto secundario (contraste AA) |
| `--acento` | `#c2410c` | `#fb923c` | Acción principal, foco |
| `--acento-texto` | `#ffffff` | `#111214` | Texto sobre el acento |
| `--sev-baja` | `#5c5f66` | `#a1a4ab` | Severidad baja |
| `--sev-media` | `#8a6100` | `#e5b443` | Severidad media |
| `--sev-alta` | `#b45309` | `#f59e0b` | Severidad alta |
| `--sev-critica` | `#b91c1c` | `#f87171` | Severidad crítica, errores de formulario |
| `--ok` | `#15803d` | `#4ade80` | Operación completada |

### Tipografía
| Token | Valor |
|---|---|
| `--fuente` | `system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif` |
| `--fuente-mono` | `ui-monospace, "Cascadia Mono", "JetBrains Mono", Consolas, monospace` |
| Escala | `--t-xs` 12px, `--t-sm` 14px, `--t-base` 16px, `--t-lg` 20px, `--t-xl` 24px, `--t-2xl` 32px |
| Interlineado | 1.5 en texto, 1.2 en títulos |
| Pesos | 400 texto, 600 títulos y etiquetas |

### Espaciado (base 8 px)
`--e-1` 4px, `--e-2` 8px, `--e-3` 12px, `--e-4` 16px, `--e-5` 24px, `--e-6` 32px, `--e-7` 48px, `--e-8` 64px.

### Forma y movimiento
| Token | Valor |
|---|---|
| `--radio` | 6px |
| `--radio-chico` | 4px |
| `--sombra` | `0 1px 2px rgb(0 0 0 / 0.06)` |
| `--dur-corta` | 150ms |
| `--dur` | 200ms |
| `--curva` | `cubic-bezier(0.2, 0, 0, 1)` |
| `--ancho-max` | 1120px |

## Componentes
- **Botón primario:** fondo `--acento`; uno por pantalla. Secundario: borde `--borde`, fondo transparente.
- **Campo:** etiqueta visible arriba, borde `--borde`, foco con contorno de 2 px `--acento`. El error va debajo, en `--sev-critica`, con texto que explica qué corregir.
- **Etiqueta de severidad:** texto en mayúscula pequeña, borde y punto del color de la severidad.
- **Tabla de eventos:** cabecera fija, cifras alineadas a la derecha en mono.
- **Aviso de actualización pendiente:** texto con la hora de los últimos datos, sin animación.

## Accesibilidad
- Todo operable con teclado; foco siempre visible.
- Contraste AA en texto normal.
- `aria-live="polite"` en mensajes y en el estado de actualización.
- Pruebas con axe en F6.
