# Handoff — Iván Galar · Book 26'

Sitio one-page (portfolio + about + trabajos + contacto) para Iván Galar, copywriter creativo. Estático, sin build, listo para servir desde nginx.

## Sobre este paquete

Este bundle es el **sitio final**, no un mockup. Es HTML/CSS/JS plano — sin bundler, sin frameworks, sin dependencias de node. Podés subirlo tal cual a cualquier servidor estático.

- `index.html` — la página completa (hero, sobre, trabajos con grid, lightbox, contacto)
- `_ds/iv-n-galar-book-26-.../` — design system: tokens (colores, tipografía, espaciado, reset) + `styles.css` que los importa
- `assets/brand/` — collage de portada
- `assets/works/` — 30 piezas (12 horizontales + 18 verticales, PNG 1920×1080)

Fidelidad: **hi-fi, production-ready**. Los colores, tipografías, tamaños y espaciados son finales.

## Estructura

```
index.html
_ds/iv-n-galar-book-26-4ab9f679-6e55-4a37-ac61-48167ee0a83a/
  tokens/colors.css
  tokens/typography.css
  tokens/spacing.css
  tokens/reset.css
  styles.css
assets/
  brand/cover-collage.png
  brand/collage-bg.png
  works/002-BACK_ARTE_CELULAR_HORIZONTAL_001..012_1920x1080.png
  works/003-BACK_ARTE_CELULAR_VERTICAL_001..018_1920x1080.png
```

## Secciones

1. **Hero** — collage de portada full-bleed, título "Iván Galar" en Instrument Serif italic (clamp 80→260px), meta en JetBrains Mono, reloj live CDMX en el nav.
2. **Sobre — ¿Quién soy?** — grid 1fr/2fr. Sidebar sticky con mark "Copywriter por obsesión" + `<dl>` de facts (Rol, Base, Idiomas, Disponible). Cuerpo con 5 párrafos + drop-cap naranja en el primero + chips de marcas (GWM, Bécalos, Teletón, NIU sushi).
3. **Trabajos — Arte celular** — dos series:
   - Serie A / Horizontal · 12 piezas · grid 2 columnas · aspect-ratio 16/9
   - Serie B / Vertical · 18 piezas · grid 3 columnas · aspect-ratio 9/16
   - Cada card: index mono + tag con `mix-blend-mode: difference` sobre la imagen. `cursor: zoom-in`.
4. **Contacto** — sección oscura (`--ink` bg), headline gigante italic, `<dl>` con email/tel/LinkedIn.

## Interacciones

- **Lightbox**: click en cualquier card abre modal fullscreen con la imagen, index mono en la esquina, botones ←/→ y Esc. Deep-link por hash (`#w-h5`, `#w-v12`). Escucha teclas ArrowLeft/ArrowRight/Escape.
- **Nav**: fixed top, `mix-blend-mode: difference` para adaptarse al fondo. Anchors a `#about`, `#works`, `#contact`.
- **Reloj**: se actualiza cada 30s en zona `America/Mexico_City`.

## Design tokens

Ver `_ds/.../tokens/`. Resumen:

- **Colores**: `--ink #0A0908`, `--paper-100 #E9E3D6`, `--paper-50 #F2ECDF`, `--orange #C24E2A`, `--orange-bright #E56338`, escala `--ash-*`
- **Tipografías**: Instrument Serif italic (display), Space Grotesk (UI, 400–700), JetBrains Mono (tags, números)
- **Escala tipográfica**: fluid con `clamp()` en display; mono/UI fijos (11–20px)

## Recreación en otro stack

Los archivos son diseño de referencia si se quiere recrear en React/Next/etc. Notas:

- El sitio no necesita framework — es un HTML de ~450 líneas. Migrarlo a React es opcional.
- Si migran: los 30 works son datos, no markup — meterlos en un array `works.json` y renderizar con `.map()`. Ver los data-attrs `data-idx / data-total / data-series` en cada `.card` y `<figure>`.
- El lightbox está en un IIFE al pie de `index.html`. En React, reemplazar por un `<Dialog>` de Radix / Headless UI y manejar el estado con `useState`.

Ver `DEPLOY_CONTABO.md` para subirlo al VPS.
