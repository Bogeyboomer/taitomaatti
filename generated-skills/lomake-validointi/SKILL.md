---
name: lomake-validointi
description: "React-lomakkeet React Hook Form + Zod -stackilla. Käytä: lomake, validointi, form, React Hook Form, Zod, schema validation, input validation, lomakevirhe, RSVP-lomake."
---

# Lomake-validointi — React Hook Form + Zod

React Hook Form on 2026 standardi React-lomakkeille: uncontrolled-inputit → minimi re-rendereitä. Zod tuo tyyppiturvallisen skeemavalidoinnin — sama skeema frontissa ja backendissa.

## Milloin käyttää

- Lomake käyttää pelkkää `useState`-per-kenttä -mallia
- Validointi on ad-hoc tai puuttuu
- Kentät re-renderöityvät turhaan jokaisesta näppäinpainalluksesta
- Sama validointi tarvitaan sekä UI:ssa että API:ssa

## Prosessi

### 1. Asennus

```bash
npm install react-hook-form zod @hookform/resolvers
```

### 2. Skeema + perusmalli

```javascript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const loginSchema = z.object({
  email: z.string().email('Virheellinen sähköposti'),
  password: z.string().min(8, 'Vähintään 8 merkkiä'),
})

export function LoginForm({ onSubmit }) {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm({ resolver: zodResolver(loginSchema) })

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} placeholder="sähköposti" />
      {errors.email && <p>{errors.email.message}</p>}

      <input type="password" {...register('password')} />
      {errors.password && <p>{errors.password.message}</p>}

      <button disabled={isSubmitting}>Kirjaudu</button>
    </form>
  )
}
```

### 3. Monimutkaisemmat skeemat

```javascript
// Riippuvat kentät — vahvistus pitää täsmätä
const registerSchema = z.object({
  password: z.string().min(8),
  confirm: z.string(),
}).refine((d) => d.password === d.confirm, {
  message: 'Salasanat eivät täsmää',
  path: ['confirm'],
})

// Valinnaiset + oletukset
const eventSchema = z.object({
  name: z.string().min(1, 'Pakollinen'),
  date: z.string().date(),
  maxPlayers: z.number().int().positive().default(20),
  notes: z.string().optional(),
})

// Enum
const rsvpSchema = z.object({
  status: z.enum(['tulossa', 'ei_tulossa', 'ehka']),
})
```

### 4. Skeeman uusiokäyttö

```typescript
// src/schemas/event.ts — sama skeema sekä UI:ssa että Supabase-insertissa
export const eventSchema = z.object({ /* ... */ })
export type Event = z.infer<typeof eventSchema>

// Frontissa: validoi lomake
useForm({ resolver: zodResolver(eventSchema) })

// Backendissa (tai ennen Supabase-kutsua):
const parsed = eventSchema.parse(input) // heittää jos invalidi
```

### 5. Controller — custom-komponentit

```javascript
import { Controller } from 'react-hook-form'

<Controller
  name="date"
  control={control}
  render={({ field }) => <DatePicker {...field} />}
/>
```

Käytä vain kun inputia ei voi rekisteröidä suoraan `register`illä (esim. 3rd party -komponentit).

## Parhaat käytännöt

- **Yksi skeema per lomake** — jaa yhteisiä osia `z.object({ ... }).extend({})` -mallilla
- **Validoi serverillä uudelleen** — frontin validointi on UX, ei turva
- `mode: 'onBlur'` useFormin optioihin → validointi vasta kentästä poistuttaessa, ei jokaisesta kirjaimesta
- Virheviestit suomeksi heti skeemassa — ei käännöksiä komponentissa
- `isSubmitting` disabloi napin → estää tuplalähetykset

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| `ref is not a function` | Käytä `{...register('x')}`, ei `ref={register}` |
| Validointi ei laukea | Lisää `resolver: zodResolver(schema)` useFormiin |
| Turhia re-renderöityjä | Käytä `register`, älä `watch` jos arvoa ei tarvita UI:ssa |
| Controlled + uncontrolled -varoitus | Anna `defaultValues` useFormiin, ei `value`-propia |

## Pukkari-sovellukseen

```
1. src/schemas/: event.ts, login.ts, register.ts, rsvp.ts
2. LoginScreen    → loginSchema
3. RegisterWizard → registerSchema (monivaiheinen: z.object per vaihe)
4. RsvpButton     → rsvpSchema (enum)
5. Sama skeema + supabase.from('events').insert(eventSchema.parse(data))
```
