---
name: pwa-kehitys
description: "Muunna React+Vite-sovellus Progressive Web Appiksi — offline, asennettavuus, push-ilmoitukset, Lighthouse. Käytä: PWA, progressive web app, offline, asennettava sovellus, service worker, vite-plugin-pwa, lisää kotinäytölle."
---

# PWA-kehitys — React+Vite Progressive Web App

`vite-plugin-pwa` tekee React+Vite-sovelluksesta asennettavan, offline-toimivan PWA:n 5 vaiheessa.

> Laajennetut caching-strategiat, push-esimerkit ja Lighthouse-checklist: lue DETAILS.md

## Milloin käyttää

- Mobiilikäyttäjät tarvitsevat natiivituntuman ilman app storea
- Sovellus heikoilla yhteyksillä (offline-tuki)
- Urheilu-/tapahtumasovellus (Pukkari) — toistuvakäyttöinen

## Peruskäsitteet

```
PWA = Web App Manifest + Service Worker + HTTPS
Manifest       → asennusmetatieto (nimi, ikonit, värit)
Service Worker → taustaskripti (cache, offline, push)
HTTPS          → pakollinen (localhost poikkeus)
```

## Prosessi

### 1. Asenna

```bash
npm install -D vite-plugin-pwa
```

### 2. vite.config.js

```javascript
import { VitePWA } from 'vite-plugin-pwa'

export default defineConfig({
  plugins: [react(), VitePWA({
    registerType: 'autoUpdate',
    includeAssets: ['favicon.ico', 'apple-touch-icon.png'],
    manifest: {
      name: 'Pukkari', short_name: 'Pukkari',
      theme_color: '#ffffff', background_color: '#ffffff',
      display: 'standalone', start_url: '/',
      icons: [
        { src: 'pwa-192x192.png', sizes: '192x192', type: 'image/png' },
        { src: 'pwa-512x512.png', sizes: '512x512', type: 'image/png', purpose: 'any maskable' }
      ]
    },
    workbox: {
      globPatterns: ['**/*.{js,css,html,ico,png,svg,woff2}'],
      runtimeCaching: [{
        urlPattern: /^https:\/\/api\./,
        handler: 'NetworkFirst',
        options: { cacheName: 'api', expiration: { maxEntries: 50, maxAgeSeconds: 86400 } }
      }]
    }
  })]
})
```

### 3. Rekisteröi (main.jsx)

```javascript
import { registerSW } from 'virtual:pwa-register'

const updateSW = registerSW({
  onNeedRefresh() {
    if (confirm('Uusi versio — päivitetäänkö?')) updateSW(true)
  },
  onOfflineReady() { console.log('Offline-valmis') }
})
```

### 4. Ikonit `public/`

```
pwa-192x192.png, pwa-512x512.png, apple-touch-icon.png (180×180), favicon.ico
```

Generoi: `npx pwa-asset-generator logo.png public/`

### 5. Testaa

```bash
npm run build && npm run preview
# DevTools → Application → Service Workers
# Lighthouse → PWA-raportti
```

## Caching-strategiat — pikavalinta

| Strategia | Käyttö |
|-----------|--------|
| `CacheFirst` | Staattiset (fontit, logot) |
| `NetworkFirst` | API muuttuva data |
| `StaleWhileRevalidate` | Usein päivittyvä (tapahtumalista) |
| `NetworkOnly` | Maksut, kirjautuminen |

## Parhaat käytännöt

- **App shell** — UI välimuistista, data verkosta
- **Graceful degradation** — toimii myös ilman PWA-kykyjä
- **Päivitysilmoitus** — kysy käyttäjältä ennen `updateSW(true)`
- **Maskable icons** — `purpose: 'any maskable'` kaikille alustoille

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| SW ei päivity | Vaihda `registerType: 'autoUpdate'` |
| Offline ei toimi | Tarkista `workbox.globPatterns` |
| iOS ei asenna | Lisää `apple-touch-icon.png` (180×180) |
| Vanha versio jää | `updateSW(true)` pakottaa päivityksen |

## Pukkari-sovellukseen

```
1. npm i -D vite-plugin-pwa
2. vite.config.js: VitePWA + manifest + runtimeCaching (events, roster)
3. main.jsx: registerSW
4. public/: 192+512+apple-touch + favicon
5. Lighthouse PWA-auditti ≥ 90
```
