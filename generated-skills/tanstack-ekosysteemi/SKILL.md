---
name: tanstack-ekosysteemi
description: "TanStack-kirjastot React 2026 — Router, Query, Table, Form tyyppiturvallisesti. Käytä: TanStack Router, TanStack Table, type-safe routing, reittiparametrit, taulukkonäkymä, datagrid, router migration, React Router vs TanStack."
---

# TanStack-ekosysteemi — tyyppiturvallinen React-stack

TanStack-kirjastot tarjoavat **100 % tyyppiturvalliset** palikat React-sovelluksiin: Router, Query, Table, Form, Virtual. Query on jo `react-tila-hallinta`-taidossa — tämä taito kattaa muut.

## Milloin käyttää

- React Router ei anna tyyppitukea reittiparametreille
- Iso taulukko (pelaajat, tilastot) tarvitsee virtualisointi + sorting + filtering
- Form-validointi halutaan headless (RHF + Zod vaihtoehtona)
- End-to-end tyyppiturva URL → loader → komponentti

## Ekosysteemi — osa taitoina

| Kirjasto | Koko | Milloin käyttää |
|----------|------|-----------------|
| **Router** | ~45 KB | Tyyppiturvallinen reititys (ks. alla) |
| **Query** | — | Palvelintila — katettu `react-tila-hallinta`-taidossa |
| **Table** | ~14 KB | Datagrid: pelaajatilastot, tapahtumalista |
| **Form** | ~10 KB | Vaihtoehto React Hook Formille (vrt. `lomake-validointi`) |
| **Virtual** | ~5 KB | Pitkän listan virtualisointi |

## TanStack Router — tyyppiturvallinen reititys

### Router vs React Router

| Tekijä | TanStack Router | React Router v7 |
|--------|-----------------|-----------------|
| Tyyppiturva | 100 % (params, search) | Manuaalinen |
| Bundle | 45 KB | 20 KB |
| Data loading | Integroitu + cache | Loaders (uusi) |
| SSR | Kyllä | Kyllä |
| Ekosysteemi | Kasvava | Massiivinen |
| Suositus | Uudet projektit jotka haluavat tyyppiturvan | Olemassa oleva / pieni projekti |

### Asennus

```bash
npm install @tanstack/react-router
npm install -D @tanstack/router-plugin  # Vite-plugin
```

```javascript
// vite.config.js
import { TanStackRouterVite } from '@tanstack/router-plugin/vite'

export default defineConfig({
  plugins: [TanStackRouterVite(), react()]
})
```

### Reitit — file-based

```
src/routes/__root.tsx         → layout
src/routes/index.tsx          → /
src/routes/events/$eventId.tsx → /events/:eventId
```

```tsx
export const Route = createFileRoute('/events/$eventId')({
  loader: ({ params }) => fetchEvent(params.eventId),
  component: EventDetail
})

function EventDetail() {
  const { eventId } = Route.useParams()     // tyypitetty
  const event = Route.useLoaderData()       // fetchEventin tyyppi
  return <h1>{event.name}</h1>
}
```

### Navigointi — tyyppiturvallinen

```tsx
<Link to="/events/$eventId" params={{ eventId: '42' }}>Avaa</Link>
// Virheellinen param → TS-virhe compile-aikana
```

## TanStack Table — datagrid (headless)

```tsx
import { useReactTable, getCoreRowModel, flexRender } from '@tanstack/react-table'

const columns = [
  { accessorKey: 'name', header: 'Pelaaja' },
  { accessorKey: 'goals', header: 'Maalit' }
]

const table = useReactTable({ data, columns, getCoreRowModel: getCoreRowModel() })
// Renderöi itse headers + rows flexRender-apurilla
```

Lisää: sorting, filtering, pagination, row selection — kaikki headless.

## Parhaat käytännöt

- **File-based routing** — helpompi lukea
- **Search params skemana** — validoi Zodilla kuten lomakkeet
- **Router + Query yhdessä** — `loader` kutsuu Queryn → cache + SWR
- **Table headless** — toimii shadcn-ui:n kanssa
- Älä vaihda React Routerista jos tyyppiturva ei ole ongelma

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| `Route tree not generated` | Aja `vite dev` → plugin generoi `routeTree.gen.ts` |
| Params-tyyppi `any` | Tarkista tiedostopolku vastaa `createFileRoute`-argumenttia |
| Loader-cache pettää | Käytä `staleTime`, ei manuaalista invalidointia |

## Pukkari-sovellukseen

```
Nykyinen: 12 screeniä state-pohjaisesti → ei URL:eja, ei back-nappia

1. Asenna @tanstack/react-router + Vite-plugin
2. Luo src/routes/: index, events/$eventId, players, chat, stats
3. Korvaa App.jsx:n state-pohjainen näyttö <RouterProvider>
4. Deep linking toimii: pukkari.fi/events/42 avaa suoraan
5. PlayerStats → TanStack Table (sorting, filter joukkueittain)
```

## Resurssit

- [TanStack Router docs](https://tanstack.com/router/latest)
- [Router vs React Router 2026](https://www.pkgpulse.com/blog/tanstack-router-vs-react-router-v7-2026)
- [TanStack Table docs](https://tanstack.com/table/latest)
