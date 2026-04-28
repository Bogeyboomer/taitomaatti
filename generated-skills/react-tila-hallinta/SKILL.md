---
name: react-tila-hallinta
description: "React state management 2026 — Zustand client-tilalle, TanStack Query server-tilalle. Käytä: state management, tilan hallinta, Zustand, TanStack Query, prop drilling, global state, useState ei riitä."
---

# React-tila-hallinta — Zustand + TanStack Query

2026 standardi: **server state** ja **client state** erotetaan. TanStack Query omistaa kaiken API-datan, Zustand omistaa UI:n tilan.

## Milloin käyttää

- Prop drilling yli 2 tason syvyyteen
- Sama API-data useasta komponentista
- Lataustilat ja caching toistuvat koodissa
- `useState` + `useEffect` -kombinaatioita liikaa

## Arkkitehtuuri

```
Server state  →  TanStack Query  (API, caching, refetch, loading)
Client state  →  Zustand         (auth, UI, notifikaatiot)
Form state    →  React Hook Form
Local state   →  useState         (yksittäinen komponentti)
```

## Prosessi

### Zustand — client state

```bash
npm install zustand
```

```javascript
// store/authStore.js
import { create } from 'zustand'
export const useAuthStore = create((set) => ({
  user: null,
  isAdmin: false,
  login: (user, isAdmin) => set({ user, isAdmin }),
  logout: () => set({ user: null, isAdmin: false }),
}))
// Komponentissa: const { user, login } = useAuthStore()
```

### TanStack Query — server state

```bash
npm install @tanstack/react-query
```

```javascript
// main.jsx — kääri QueryClientProvideriin
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
const queryClient = new QueryClient()
// <QueryClientProvider client={queryClient}><App /></QueryClientProvider>

// Komponentissa
const { data: events, isLoading } = useQuery({
  queryKey: ['events'],
  queryFn: () => fetch('/api/events').then(r => r.json()),
  staleTime: 1000 * 60 * 5,
})
```

## Kirjaston valinta

| Tilanne | Valinta |
|---------|---------|
| Selkeät storet (user, ui, cart) | **Zustand** |
| Paljon derivoitua / atomista tilaa | Jotai |
| Suuri tiimi, strict patterns | Redux Toolkit |
| API-data, caching, loading | **TanStack Query** |

## Parhaat käytännöt

- Yksi store per domain: `useAuthStore`, `useNotificationStore`
- `queryKey` aina tarkka: `['events', userId]`
- `staleTime` API-kutsuille — estää turhat uusintatäsmäykset
- Älä laita server-dataa Zustandiin

## Pukkari-sovellukseen

```
isLoggedIn, isAdmin useState → useAuthStore (Zustand)
data.js mock                 → TanStack Query + Supabase API
queryKey:                      ['events'], ['roster'], ['stats', playerId]
```
