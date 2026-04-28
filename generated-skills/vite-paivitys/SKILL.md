---
name: vite-paivitys
description: "Päivitä Vite 5 → 8 — Rolldown-bundler, nopeat buildit, yhteensopivuus Vitest 4:n kanssa. Käytä: Vite päivitys, upgrade Vite, Vite 6, Vite 7, Vite 8, Rolldown, build nopeus, vite versio."
---

# Vite-päivitys — Vite 5 → 8

Vite 8.0 julkaistiin 12.3.2026. Suurin muutos: **Rolldown** korvaa esbuild/Rollup-bundlerit — buildit 10–30× nopeampia. Vitest 4 vaatii Vite ≥ 6, joten Pukkarin Vite 5 on päivitettävä ennen testien lisäämistä.

## Miksi päivittää

| | Vite 5 | Vite 8 |
|--|--------|--------|
| Bundler | Rollup + esbuild | Rolldown + Oxc |
| Build-nopeus | perusviiva | 10–30× nopeampi |
| Vitest 4 | ❌ ei tue | ✅ vaatimus |
| CSS minify | esbuild | Lightning CSS |
| Tuki | päättynyt | ✅ aktiivinen |

## Prosessi — Pukkari (Vite 5 → 8)

### 1. Päivitä riippuvuudet

```bash
npm install -D vite@latest @vitejs/plugin-react@latest
```

### 2. Tarkista vite.config.js

Suurin muutos: `rollupOptions` → `rolldownOptions`.

```javascript
// ENNEN (Vite 5)
export default defineConfig({
  build: {
    rollupOptions: { output: { manualChunks: { vendor: ['react', 'react-dom'] } } }
  }
})

// JÄLKEEN (Vite 8)
export default defineConfig({
  build: {
    rolldownOptions: { output: { manualChunks: { vendor: ['react', 'react-dom'] } } }
  }
})
```

> **Huom:** Vite 8 sisältää kompatibiliteettitason — `rollupOptions` toimii edelleen varoituksella. Voit siirtyä asteittain.

### 3. CSS-minimointi

```javascript
// Jos haluat säilyttää esbuild-minimoinnin:
export default defineConfig({
  build: { cssMinify: 'esbuild' }  // oletus on nyt Lightning CSS
})
```

### 4. Testaa build

```bash
npm run build
npm run preview
```

Tarkista: bundle-koko, console-virheet, CSS-renderöinti.

### 5. HMR-muutos (jos käytät)

```javascript
// ENNEN — URL import.meta.hot.accept:iin
import.meta.hot.accept('/src/foo.js', handler)

// JÄLKEEN — moduuli-id (ei URL)
import.meta.hot.accept('./foo.js', handler)
```

## Vite 5 → 6 → 7 → 8 — muutoskaari

```
Vite 6  (kesä 2025):   Environment API, parempi SSR
Vite 7  (kesä 2025):   baseline-widely-available default target
Vite 8  (maaliskuu 2026): Rolldown + Oxc, 10–30× nopeampi build
```

Suora hyppäys 5 → 8 toimii yleensä — kompatibiliteettitaso hoitaa useimmat muutokset automaattisesti.

## Yleisimmät ongelmat

| Ongelma | Syy | Ratkaisu |
|---------|-----|----------|
| `optimizeDeps.esbuildOptions deprecated` | Vite 8 käyttää Rolldown | Siirrä `rolldownOptions`:iin tai poista |
| CSS muuttui visuaalisesti | Lightning CSS tulkitsee eri tavalla | `cssMinify: 'esbuild'` tilapäisesti |
| Vite 5 -plugin ei toimi | API muuttunut | Tarkista pluginin yhteensopivuus v8:n kanssa |
| Vitest ei toimi | Vitest 4 vaatii Vite ≥ 6 | Päivitä Vite ensin, sitten Vitest |

## Parhaat käytännöt

- **Päivitä Vite ennen Vitestia** — Vitest 4 vaatii Vite ≥ 6
- **Aja `npm run build` heti päivityksen jälkeen** — catch-varhainen
- **Kompatibiliteettitaso** — `rollupOptions` toimii vielä, mutta varoittaa
- Vite+ (superset) tulossa 2026 loppuvuodesta — seuraa kehitystä

## Pukkari-sovellukseen

```
1. npm install -D vite@latest @vitejs/plugin-react@latest
2. npm run build → tarkista virheet
3. Jos rollupOptions → muuta rolldownOptions:iin
4. npm run preview → visuaalinen tarkistus
5. Nyt voi asentaa Vitest 4: ks. react-testaus-taito
```

## Resurssit

- [Vite 8.0 julkistus](https://vite.dev/blog/announcing-vite8)
- [Migration from v7 | Vite](https://vite.dev/guide/migration)
- [Vite 8 Rolldown migration guide](https://byteiota.com/vite-8-rolldown-migration-guide-10-30x-faster-builds/)
