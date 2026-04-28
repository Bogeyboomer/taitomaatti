---
name: supabase-integraatio
description: "Lisää Supabase-backend React-sovellukseen — auth, tietokanta, realtime. Käytä: supabase, backend, tietokanta, autentikointi, realtime, database, Row Level Security, edge functions, lisää backend."
---

# Supabase-integraatio — React + Supabase

Supabase on 2026 selkein valinta React-web-appeihin: PostgreSQL, autentikointi, realtime ja Edge Functions yhdessä paketissa. Korvaa mock-datan oikealla backendillä.

## Milloin käyttää

- Sovelluksessa on vain mock-dataa (kuten `data.js`)
- Tarvitaan käyttäjäautentikointi
- Data pitää säilyä sessioiden välillä
- Useampi käyttäjä jakaa saman datan reaaliajassa

## Prosessi

### 1. Projekti ja asennus

```bash
npm install @supabase/supabase-js
```

Luo projekti: [supabase.com](https://supabase.com) → New project → kopioi `URL` ja `anon key`

```javascript
// lib/supabase.js
import { createClient } from '@supabase/supabase-js'

export const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)
```

```bash
# .env
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```

### 2. Autentikointi

```javascript
// Kirjautuminen
const { data, error } = await supabase.auth.signInWithPassword({
  email, password
})

// Rekisteröinti
await supabase.auth.signUp({ email, password })

// Uloskirjautuminen
await supabase.auth.signOut()

// Nykyinen käyttäjä
const { data: { user } } = await supabase.auth.getUser()

// Kuuntele muutoksia
supabase.auth.onAuthStateChange((event, session) => {
  setUser(session?.user ?? null)
})
```

### 3. Tietokanta (CRUD)

```javascript
// Hae
const { data } = await supabase.from('events').select('*')

// Hae suodatuksella
const { data } = await supabase
  .from('events').select('*')
  .eq('team_id', teamId)
  .order('date', { ascending: true })

// Lisää
await supabase.from('events').insert({ name, date, team_id })

// Päivitä
await supabase.from('events').update({ rsvp: true }).eq('id', eventId)

// Poista
await supabase.from('events').delete().eq('id', eventId)
```

### 4. Realtime

```javascript
// Kuuntele muutoksia taulussa
const channel = supabase
  .channel('events-changes')
  .on('postgres_changes',
    { event: '*', schema: 'public', table: 'events' },
    (payload) => setEvents(prev => [...prev, payload.new])
  )
  .subscribe()

// Muista poistaa
return () => supabase.removeChannel(channel)
```

### 5. Row Level Security (RLS)

Ota RLS käyttöön **kaikissa tauluissa**:
```sql
-- Käyttäjä näkee vain oman joukkueen tapahtumat
CREATE POLICY "team_events" ON events
  FOR SELECT USING (team_id = auth.uid());
```

## Parhaat käytännöt

- RLS jokaiseen tauluun jossa on käyttäjädataa — älä luota pelkkään anon key:hin
- `user_id` viittaa aina `auth.users`-tauluun
- Käytä TanStack Queryn kanssa: `queryFn: () => supabase.from(...).select()`
- `.env` ei koskaan versionhallintaan — lisää `.gitignore`

## Pukkari-sovellukseen

```
data.js mock → Supabase-taulut: events, players, teams, rsvps, chat_messages
LoginScreen  → supabase.auth.signInWithPassword
RegisterWizard → supabase.auth.signUp
ChatScreen   → realtime subscription
StatsScreen  → supabase.from('stats').select()
```
