---
name: virhekasittely-tuotanto
description: "React 19 tuotantovirheiden käsittely — Error Boundary, Sentry, source mapit. Käytä: error boundary, Sentry, tuotantovirhe, crash, virheseuranta, production error, stack trace, fallback UI, virheraportointi."
---

# Virhekäsittely tuotannossa — React 19 + Sentry

React 19 toi uudet root-tason error hookit. Sentry integroi niihin suoraan — virheistä näet koko stack tracen, käyttäjäkontekstin ja source-mapattuna alkuperäisen koodin.

## Milloin käyttää

- App menee tuotantoon → tarvitset virheseurannan
- Käyttäjät raportoivat bugeista joita et pysty toistamaan
- Haluat nähdä missä komponentissa virhe syntyi + stack trace

## Asennus

```bash
npm install @sentry/react
npx @sentry/wizard@latest -i sentry  # konfiguroi automaattisesti
```

## React 19 + Sentry — main.jsx

```tsx
import * as Sentry from '@sentry/react'
import { reactErrorHandler } from '@sentry/react'

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN,
  environment: import.meta.env.MODE,   // 'development' | 'production'
  tracesSampleRate: 0.2                // 20 % performance traces
})

createRoot(document.getElementById('root'), {
  onUncaughtError: reactErrorHandler(),   // React 19 hook
  onCaughtError: reactErrorHandler(),
}).render(<App />)
```

## Error Boundary — fallback-UI

```tsx
import { ErrorBoundary } from '@sentry/react'

function App() {
  return (
    <ErrorBoundary
      fallback={({ error, resetError }) => (
        <div className="error-screen">
          <p>Jotain meni pieleen.</p>
          <button onClick={resetError}>Yritä uudelleen</button>
        </div>
      )}
    >
      <AppContent />
    </ErrorBoundary>
  )
}
```

## Mitä Error Boundary EI nappaa

| Ei napata | Ratkaisu |
|-----------|----------|
| Event handlerit | `try/catch` + `Sentry.captureException` |
| `async/await` | `try/catch` + `Sentry.captureException` |
| Promise reject | `window.onunhandledrejection` (Sentry hoitaa) |

```tsx
// Event handler -virhe manuaalisesti
async function handleSubmit() {
  try {
    await saveData()
  } catch (err) {
    Sentry.captureException(err)
    setError('Tallennus epäonnistui')
  }
}
```

## Source mapit — Vite

```bash
npm install @sentry/vite-plugin -D
```

```javascript
// vite.config.js
import { sentryVitePlugin } from '@sentry/vite-plugin'

export default defineConfig({
  build: { sourcemap: true },
  plugins: [
    react(),
    sentryVitePlugin({
      authToken: process.env.SENTRY_AUTH_TOKEN,
      org: 'your-org',
      project: 'pukkari'
    })
  ]
})
```

Nyt `npm run build` lähettää source mapit Sentryn palvelimelle → stack trace näyttää alkuperäisen koodin.

## Yleisimmät virheet

| Virhe | Syy | Ratkaisu |
|-------|-----|----------|
| Stack trace minified | Source mapit puuttuu | Lisää vite-plugin |
| Duplikaattiraportit dev-moodissa | React 19 rethrows | Normaalia, testaa `preview`-moodilla |
| DSN näkyy bundlessa | Julkinen DSN on ok — ei secret | `VITE_SENTRY_DSN` .env:iin |

## Parhaat käytännöt

- **Yksi ErrorBoundary ylätasolla** + lisää kriittisille osioille (chat, stats)
- **source maps tuotantoon aina** — ilman niitä debug on mahdotonta
- **tracesSampleRate 0.1–0.2** — ei laskuteta jokaisesta tapahtumasta
- **environment-kenttä** — erottaa prod vs staging virheet

## Pukkari-sovellukseen

```
1. npm install @sentry/react && npx @sentry/wizard -i sentry
2. Sentry.init + reactErrorHandler main.jsx:ssa
3. <ErrorBoundary> App.jsx:n juureen → "Jotain meni pieleen" -näkymä
4. @sentry/vite-plugin → source mapit automaattisesti buildissä
5. ChatScreen, StatsScreen: omat ErrorBoundaryt osastojen virheiden eristämiseen
```

## Resurssit

- [Sentry for React](https://docs.sentry.io/platforms/javascript/guides/react/)
- [Error Boundary](https://docs.sentry.io/platforms/javascript/guides/react/features/error-boundary/)
- [Source Maps + Vite](https://docs.sentry.io/platforms/javascript/guides/react/sourcemaps/)
