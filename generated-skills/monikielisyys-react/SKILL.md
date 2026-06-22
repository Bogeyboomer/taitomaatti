# React Monikielisyys (i18n)

Lisää monikielituki React-sovellukseen react-i18next-kirjastolla. Toimii Vite + TypeScript -stackilla.

## Asennus

```bash
npm install i18next react-i18next i18next-browser-languagedetector
```

## Rakenne

```
src/
  i18n/
    index.ts          # i18next-konfiguraatio
    locales/
      fi/translation.json
      en/translation.json
      sv/translation.json
```

## i18n-konfiguraatio (src/i18n/index.ts)

```typescript
import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'
import LanguageDetector from 'i18next-browser-languagedetector'
import fi from './locales/fi/translation.json'
import en from './locales/en/translation.json'
import sv from './locales/sv/translation.json'

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: { fi: { translation: fi }, en: { translation: en }, sv: { translation: sv } },
    fallbackLng: 'fi',
    supportedLngs: ['fi', 'en', 'sv', 'de', 'es', 'it', 'fr'],
    interpolation: { escapeValue: false },
    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage'],
    },
  })

export default i18n
```

## Käyttö komponentissa

```typescript
import { useTranslation } from 'react-i18next'

function Header() {
  const { t, i18n } = useTranslation()
  return (
    <div>
      <h1>{t('app.title')}</h1>
      <button onClick={() => i18n.changeLanguage('en')}>EN</button>
      <button onClick={() => i18n.changeLanguage('fi')}>FI</button>
      <button onClick={() => i18n.changeLanguage('sv')}>SV</button>
    </div>
  )
}
```

## Käännöstiedosto (fi/translation.json)

```json
{
  "app": { "title": "Sovellus" },
  "nav": { "home": "Etusivu", "events": "Tapahtumat" },
  "event": {
    "create": "Luo tapahtuma",
    "types": {
      "practice": "Harjoitukset",
      "game": "Peli",
      "tournament": "Turnaus",
      "camp": "Leiri",
      "trip": "Matka"
    }
  }
}
```

## Kielen valitsin -komponentti

```typescript
const LANGUAGES = [
  { code: 'fi', label: 'Suomi' },
  { code: 'en', label: 'English' },
  { code: 'sv', label: 'Svenska' },
  { code: 'de', label: 'Deutsch' },
  { code: 'es', label: 'Español' },
  { code: 'it', label: 'Italiano' },
  { code: 'fr', label: 'Français' },
]

function LanguageSwitcher() {
  const { i18n } = useTranslation()
  return (
    <select value={i18n.language} onChange={e => i18n.changeLanguage(e.target.value)}>
      {LANGUAGES.map(lang => (
        <option key={lang.code} value={lang.code}>{lang.label}</option>
      ))}
    </select>
  )
}
```

## Main.tsx — rekisteröi i18n ennen Reactia

```typescript
import './i18n/index'  // Importoi ennen App-komponenttia!
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode><App /></React.StrictMode>
)
```

## Avainperiaatteet

- **Avainrakenne**: `osio.aliosio.avain` — kuvaa hierarkiaa, ei sisältöä
- **Ei merkkijonoja komponentteihin** — kaikki teksti käännöstiedostoista
- **Fallback aina** — `fallbackLng: 'fi'` pitää UI ehjänä puuttuvilla käännöksillä
- **localStorage** — tallentaa kielen selaimen muistiin automaattisesti
- **TypeScript + i18next**: lisää `i18next.d.ts` tyypitys autocompletea varten

## Vianetsintä

| Ongelma | Syy | Ratkaisu |
|---|---|---|
| Avaimet näkyvät tekstinä | i18n ei alustettu ennen Reactia | Importoi i18n/index.ts ennen App |
| Kieli ei tallennu | LanguageDetector puuttuu | Lisää `i18next-browser-languagedetector` |
| Puuttuvat käännökset | fallbackLng puuttuu | Aseta `fallbackLng: 'fi'` |
| Kielivalinta resetoituu | localStorage ei käytössä | Lisää `caches: ['localStorage']` detectioniin |
