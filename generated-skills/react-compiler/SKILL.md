---
name: react-compiler
description: "React Compiler v1.0+ — automaattinen memoisointi, ei enää useMemo/useCallback. Käytä: react compiler, automaattinen memoisointi, useMemo turha, useCallback turha, re-render optimointi, React.memo, INP parannus, performance React."
---

# React Compiler — automaattinen memoisointi

v1.0 julkaistu lokakuu 2025, laaja käyttö 2026. Build-time-optimointi joka muistaa komponentit ja hookit automaattisesti — `useMemo`, `useCallback` ja `React.memo` ovat useimmiten tarpeettomia.

## Milloin käyttää

- Koodipohja täynnä manuaalisia `useMemo`/`useCallback`-kutsuja
- Re-render-ongelmia, turhat renderit hidastavat UI:ta
- INP-metriikka (Interaction to Next Paint) huono
- Uusi React-projekti — ota käyttöön alusta asti

## Mitä Compiler tekee

```tsx
// ENNEN — manuaalinen
const C = memo(function C({ items, onSelect }) {
  const sorted = useMemo(() => items.sort(), [items])
  const handle = useCallback((id) => onSelect(id), [onSelect])
  return <List items={sorted} onClick={handle} />
})

// JÄLKEEN — Compiler memoisoi automaattisesti
function C({ items, onSelect }) {
  const sorted = items.sort()
  return <List items={sorted} onClick={(id) => onSelect(id)} />
}
```

## Vaatimukset

| Asia | Vaatimus |
|------|----------|
| React | 19+ (17/18 tuettu incremental-moodissa) |
| Build | Vite, Next.js 15+, Babel, Rsbuild |
| Kieli | JS tai TS |
| Säännöt | Rules of React noudatettava (ei mutaatiota, pure-komponentit) |

## Prosessi — Vite + React

### 1. Asenna

```bash
npm install -D babel-plugin-react-compiler
npm install -D eslint-plugin-react-hooks@latest
```

### 2. vite.config.js

```javascript
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [
    react({
      babel: {
        plugins: [['babel-plugin-react-compiler', {}]]
      }
    })
  ]
})
```

### 3. ESLint — `rules-of-react` pakollinen

```javascript
// eslint.config.js
import reactHooks from 'eslint-plugin-react-hooks'

export default [
  {
    plugins: { 'react-hooks': reactHooks },
    rules: reactHooks.configs['recommended-latest'].rules
  }
]
```

Compilerin optimointi edellyttää että koodi noudattaa React-sääntöjä — ESLint huomauttaa rikkomuksista.

### 4. Testaa

```bash
npm run build
# Tarkista: bundle sisältää Compilerin generoima memoisointi
# Jos komponentti EI memoisoidu, Compiler raportoi syyn buildissä
```

## Vaiheittainen käyttöönotto

```javascript
// 1. annotation-tila — vain "use memo"-direktiivillä merkityt tiedostot
{ compilationMode: 'annotation' }
// 2. 'use memo' tiedoston alkuun → optimoi vain se
// 3. compilationMode: 'all' — kaikki pakolla
```

## Mitä poistetaan koodista

| Vanha | Uusi |
|-------|------|
| `useMemo(() => x, [deps])` | `const y = x` |
| `useCallback(fn, [deps])` | `const fn = ...` |
| `memo(Component)` | `function Component()` |
| `React.memo(...)` | — |

**Älä poista:**
- `useEffect`-hookin `[deps]` — semantiikka eri (side effects)
- `useRef`, `useState` — edelleen tarpeen

## Parhaat käytännöt

- **ESLint ensin** — korjaa `rules-of-react`-rikkomukset ennen Compileria
- **Mittaa**: React DevTools Profiler ennen/jälkeen
- **Ei mutaatioita** — käytä immutable-päivityksiä (`[...arr, x]`)
- **Pure-komponentit** — side effects vain `useEffect`issä

## Yleisimmät virheet

| Virhe | Syy | Ratkaisu |
|-------|-----|----------|
| Komponentti ei optimoidu | Rules of React -rikkomus | ESLint-viesti kertoo — korjaa |
| Mutaatio-bugi ilmenee | Koodi muutti objektia paikalla, Compiler paljastaa | Käytä immutable-päivityksiä |
| Testit hajoavat | Snapshot muuttui (generoitu koodi) | Päivitä snapshot, tarkista logiikka ei muuttunut |
| Build hidas | Ensimmäinen build optimoi kaiken | Hyväksy kertakulu, seuraavat buildit nopeita |

## Pukkari-sovellukseen

```
1. Tarkista: React 19 + Vite (package.json)
2. npm i -D babel-plugin-react-compiler
3. vite.config.js: lisää plugin react()-konfiguraatioon
4. ESLint: rules-of-react aja — korjaa mahdolliset rikkomukset
5. Poista useMemo/useCallback-kutsut asteittain (DevTools-varmistuksen jälkeen)
```

## Resurssit

- [React Compiler — React docs](https://react.dev/learn/react-compiler)
- [React Compiler v1.0 — blog](https://react.dev/blog/2025/10/07/react-compiler-1)
- [Migration guide 2026](https://www.live-laugh-love.world/blog/react-compiler-migration-guide-2026/)
