---
name: shadcn-ui
description: "shadcn/ui — Radix + Tailwind + TypeScript copy-paste komponentit React 2026. Käytä: shadcn, komponenttikirjasto, UI-kirjasto, button component, dialog, component library, Radix, design system React."
---

# shadcn/ui — 2026 React-komponenttikirjasto

Et asenna pakettia — **kopioit lähdekoodin** omaan repoon. Radix-primitiivit (saavutettavuus) + Tailwind (tyylit) + TypeScript (tyyppiturva). 277 000+ asennusta maaliskuussa 2026.

## Milloin käyttää

- Vanilla CSS kasvaa hallitsemattomaksi (Pukkarin `index.css`)
- Tarvitaan saavutettavat komponentit ilman bundlekustannusta
- Halutaan omistaa komponenttikoodi — ei black-box -riippuvuus
- Design system alusta alkaen, ei viisin paketin yhdistelmä

## Miksi shadcn eikä MUI/Chakra?

| Tekijä | shadcn | MUI / Chakra |
|--------|--------|--------------|
| Bundle-koko | 0 runtime (kopioitu koodi) | 50–200 KB |
| Muokkaus | Muokkaa tiedostoa suoraan | `theme`-override |
| Saavutettavuus | Radix primitives (WAI-ARIA) | vaihtelee |
| Tyylit | Tailwind | CSS-in-JS / CSS |
| Omistajuus | Sinä | Kirjaston ylläpitäjät |

## Prosessi

### 1. Tailwind-asennus (jos puuttuu)

```bash
npm install -D tailwindcss@4 @tailwindcss/vite
```

```javascript
// vite.config.js
import tailwindcss from '@tailwindcss/vite'
export default defineConfig({
  plugins: [react(), tailwindcss()]
})
```

```css
/* src/index.css */
@import "tailwindcss";
```

### 2. shadcn-init

```bash
npx shadcn@latest init
```

Luo:
- `components.json` — konfiguraatio
- `lib/utils.ts` — `cn()` -apufunktio
- `src/index.css` — CSS-muuttujat teemaksi

### 3. Lisää komponentteja tarpeen mukaan

```bash
npx shadcn@latest add button
npx shadcn@latest add dialog
npx shadcn@latest add form input label
```

Komponenttikoodi kopioituu `src/components/ui/`-kansioon. Voit muokata suoraan.

### 4. Käyttö

```tsx
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogTrigger } from "@/components/ui/dialog"

<Dialog>
  <DialogTrigger asChild>
    <Button variant="outline">Avaa</Button>
  </DialogTrigger>
  <DialogContent>Sisältö</DialogContent>
</Dialog>
```

## Teema — CSS-muuttujat

```css
/* src/index.css */
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    /* ... */
  }
  .dark {
    --background: 222.2 84% 4.9%;
    /* ... */
  }
}
```

Vaihda teema lisäämällä `class="dark"` juureen.

## Parhaat käytännöt

- **Asenna vain mitä käytät** — ei "asenna kaikki 50 komponenttia"
- **Muokkaa vapaasti** — koodi on omasi, ei kirjaston riippuvuus
- **`cn()` classname-yhdistelyyn** — tyyppiturvallinen variantti-handling (clsx + tailwind-merge)
- **Radix alla** — saavutettavuus out-of-box (keyboard, ARIA, focus)
- **Päivitys manuaalinen** — `npx shadcn@latest diff <component>` näyttää muutokset, sovellat haluamasi

## Yleisimmät komponentit Pukkariin

| Komponentti | Käyttö Pukkarissa |
|-------------|-------------------|
| `Button` | Kaikki napit (RSVP, Kirjaudu) |
| `Dialog` | CreateEventScreen modaalina |
| `Form` + `Input` + `Label` | LoginScreen, RegisterWizard |
| `Card` | EventDetail, PlayerHome |
| `Tabs` | StatsScreen |
| `Sheet` | BottomNav → sivupaneeli |
| `Toast` | Korvaa nykyinen Toast-komponentti |

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| `Cannot find module '@/components/...'` | Lisää path alias `vite.config` + `tsconfig.json` |
| Tyylit eivät näy | Tarkista `@import "tailwindcss"` index.css:ssä |
| Dark mode ei vaihdu | Lisää `class="dark"` `<html>`-tagiin |
| Komponentti rikkoutuu päivityksessä | Älä päivitä sokeasti — diff ensin |

## Pukkari-migraatio (vaiheittain)

```
1. Asenna Tailwind v4 + shadcn init
2. Button → korvaa vanhat <button className="...">
3. Form-komponentit → yhdistä lomake-validointi-taidon kanssa (RHF + Zod)
4. Dialog → CreateEventScreen, EventDetail-modaalit
5. Siirrä index.css-tyylit @layer components -osioon
6. Dark mode teema CSS-muuttujilla
```

## Resurssit

- [shadcn/ui docs](https://ui.shadcn.com/)
- [Tailwind v4 integration](https://ui.shadcn.com/docs/tailwind-v4)
- [Complete guide 2026](https://designrevision.com/blog/shadcn-ui-guide)
