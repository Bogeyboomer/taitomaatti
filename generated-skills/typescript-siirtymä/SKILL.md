---
name: typescript-siirtymä
description: "Muuta JavaScript-React-projekti TypeScriptiksi asteittain ilman big bang -muutosta. Käytä: TypeScript, TS migration, lisää TypeScript, muunna TS, type safety, tsx, allowJs, tsconfig."
---

# TypeScript-siirtymä — Asteittainen JS → TS React+Vite

Vite tukee TypeScriptiä natiivisti. `allowJs: true` mahdollistaa siirtymisen tiedosto kerrallaan — sovellus toimii koko ajan, ei big bang -muutosta.

## Milloin käyttää

- React+Vite-projekti on plain JS ja halutaan type safety
- Bugeja syntyy prop-tyypeissä tai API-vastauksissa
- IDE-automaatio ei toimi kunnolla (no IntelliSense)
- Tiimi kasvaa ja tyypit parantavat dokumentaatiota

## Prosessi

### Vaihe 1: Asenna ja konfiguroi

```bash
npm install -D typescript @types/react @types/react-dom
```

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": false,
    "allowJs": true,
    "checkJs": false,
    "skipLibCheck": true,
    "outDir": "./dist"
  },
  "include": ["src"]
}
```

```javascript
// vite.config.js — ei muutoksia tarvita, Vite tunnistaa TS automaattisesti
```

### Vaihe 2: Siirry tiedosto kerrallaan

```bash
# Aloita yksinkertaisimmista — utils, constants, types
mv src/data/data.js src/data/data.ts
mv src/components/Icons.jsx src/components/Icons.tsx
# Korjaa TypeScript-virheet tiedosto kerrallaan
```

**Järjestys:** utils/constants → shared components → screen components → App.tsx

### Vaihe 3: Tyypitä Props

```typescript
// Ennen (JS)
function EventCard({ event, onPress }) { ... }

// Jälkeen (TS)
interface Event {
  id: string
  name: string
  date: string
  teamId: string
}

interface EventCardProps {
  event: Event
  onPress: (id: string) => void
}

function EventCard({ event, onPress }: EventCardProps) { ... }
```

### Vaihe 4: Tiukenna asteittain

```json
// Kun kaikki tiedostot siirretty, tiukenna tsconfig:
{
  "strict": true,        // kaikki strict-tarkistukset
  "checkJs": false,      // voidaan poistaa kun JS-tiedostoja ei enää
  "noImplicitAny": true  // ei hiljaisia any-tyyppejä
}
```

## Parhaat käytännöt

- `allowJs: true` — älä poista ennen kuin kaikki tiedostot ovat TS
- Luo `src/types/index.ts` jaettuja tyyppejä varten (Event, Player, Team)
- `as unknown as T` on varoitusmerkki — korjaa tyyppi oikein
- API-vastaukset: käytä `zod` validointiin jos backend ei ole tyypitetty

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| `Cannot find module` | Lisää `@types/[kirjasto]` tai `declare module` |
| `JSX element implicitly any` | Lisää `@types/react` |
| `Property does not exist` | Tyypitä interface oikein, älä käytä `any` |
| Kaikki `any` | Ota `noImplicitAny` käyttöön vasta lopuksi |

## Pukkari-sovellukseen

```
1. tsconfig.json + npm install -D typescript @types/react @types/react-dom
2. src/types/index.ts: Event, Player, Team, RsvpStatus, UserRole
3. Muunna: data.ts → Icons.tsx → komponentit → screenit → App.tsx
4. Strict mode viimeisenä kun kaikki muunnettu
```
