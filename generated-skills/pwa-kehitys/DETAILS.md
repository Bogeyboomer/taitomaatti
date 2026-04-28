# PWA-kehitys — laajennetut ohjeet

Lisämateriaali `SKILL.md`:lle. Ladataan vain kun PWA-taito on aktiivinen ja tarvitaan syvempää tietoa.

## Caching-strategiat — laajennettu

| Strategia | Käyttötilanne | Esimerkki |
|-----------|--------------|-----------|
| `CacheFirst` | Staattiset resurssit | Fontit, logot, kuvakkeet |
| `NetworkFirst` | API-data joka muuttuu | Pelaajatilastot, tapahtumat |
| `StaleWhileRevalidate` | Usein päivittyvä sisältö | Tapahtumalista, uutisvirta |
| `NetworkOnly` | Aina tuore data | Maksut, kirjautuminen |
| `CacheOnly` | Täysin offline-pakko | Asetukset, käyttöohje |

### Pukkari-spesifinen caching

```javascript
runtimeCaching: [
  {
    urlPattern: /\/api\/events/,
    handler: 'NetworkFirst',
    options: {
      cacheName: 'events-cache',
      expiration: { maxAgeSeconds: 3600 },
      networkTimeoutSeconds: 3
    }
  },
  {
    urlPattern: /\/api\/roster/,
    handler: 'StaleWhileRevalidate',
    options: { cacheName: 'roster-cache' }
  },
  {
    urlPattern: /\.(png|jpg|jpeg|webp|svg)$/,
    handler: 'CacheFirst',
    options: {
      cacheName: 'images',
      expiration: { maxEntries: 100, maxAgeSeconds: 2592000 }
    }
  }
]
```

## Push-ilmoitukset — täysi flow

```javascript
// 1. Pyydä lupa
const permission = await Notification.requestPermission()
if (permission !== 'granted') return

// 2. Tilaa push-palveluun
const registration = await navigator.serviceWorker.ready
const subscription = await registration.pushManager.subscribe({
  userVisibleOnly: true,
  applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY)
})

// 3. Lähetä subscription backendille (tallennetaan DB:hen)
await fetch('/api/push/subscribe', {
  method: 'POST',
  body: JSON.stringify(subscription)
})
```

VAPID-avainten generointi backendissä:
```bash
npx web-push generate-vapid-keys
```

Backend lähettää ilmoituksen:
```javascript
import webpush from 'web-push'
webpush.sendNotification(subscription, JSON.stringify({
  title: 'Uusi tapahtuma',
  body: 'Treenit huomenna 18:00',
  url: '/events/123'
}))
```

## Lighthouse PWA -tarkistuslista

```
□ HTTPS tai localhost
□ Web App Manifest: name, icons (192+512), start_url, display: standalone
□ Service Worker rekisteröity ja aktivoitu
□ Toimii offline (custom offline-sivu vähintään)
□ Installability prompt
□ Splash screen (background_color + icons)
□ Viewport meta-tag
□ theme-color meta-tag
□ apple-touch-icon (iOS)
□ Maskable icon (Android adaptive icons)
```

## App shell -arkkitehtuuri

```
Ensimmäinen lataus:
  HTML/CSS/JS      → välimuistiin (CacheFirst)
  Perus-UI         → näkyy heti
  Data             → NetworkFirst taustalla

Toistuva lataus:
  Shell            → välimuistista (nopea)
  Data             → offline: cache, online: verkko
```

## HTTPS dev-ympäristössä

```javascript
// vite.config.js
import basicSsl from '@vitejs/plugin-basic-ssl'

export default defineConfig({
  plugins: [react(), basicSsl(), VitePWA({ /* ... */ })],
  server: { https: true }
})
```

Vaihtoehto: `mkcert` luo luotetut sertifikaatit paikallisesti.

## iOS-erityispiirteet

- Ei `beforeinstallprompt` -tapahtumaa → lisää manuaalinen ohje ("Lisää kotinäytölle")
- `apple-touch-icon` pakollinen (180×180)
- `apple-mobile-web-app-capable` meta-tag
- `apple-mobile-web-app-status-bar-style` värittää statusbar
- Ei push-ilmoituksia PWA:sta ennen iOS 16.4 — varmista versio

## Troubleshooting-lippuja

| Oire | Todennäköinen syy |
|------|-------------------|
| SW rekisteröityy mutta ei cache:a | `globPatterns` ei kata tiedostoja |
| Päivitys ei pääse läpi | `skipWaiting` puuttuu workbox-konfista |
| Ikoni näkyy valkoisella taustalla | Ei maskable-variantti |
| Offline näyttää selaimen 404 | Ei `navigateFallback` konfissa |

## Resurssit

- [vite-plugin-pwa dokumentaatio](https://vite-pwa-org.netlify.app/guide/)
- [Workbox-strategiat](https://developer.chrome.com/docs/workbox/reference/workbox-strategies)
- [Web Push protocol](https://web.dev/push-notifications-overview/)
- [Lighthouse PWA audits](https://web.dev/lighthouse-pwa/)
