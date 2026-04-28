---
name: react-testaus
description: "React-sovellusten testaus Vitest + Testing Library -stackilla. Käytä: testaa komponentti, lisää testit, Vitest, React Testing Library, unit test, component test, kirjoita testi, test coverage."
---

# React-testaus — Vitest + React Testing Library

Vitest on 2026 standardi React+Vite-testaukseen: sama konfiguraatio kuin Vitellä, natiivi ESM, Jest-yhteensopiva API. Testing Library testaa käyttäjän näkökulmasta, ei toteutusta.

## Milloin käyttää

- React+Vite-projektissa ei ole testejä (`package.json` puuttuu `vitest`)
- Komponentti rikkoutuu refaktoroinnissa
- Logiikkaa halutaan varmistaa regressiota vastaan
- CI vaatii testit ennen mergeä

## Vaatimukset

| | Versio |
|--|--------|
| Vitest | 4.x (nykyinen) |
| Vite | **≥ 6.0** — Vitest 4 pudotti Vite 5 -tuen |
| Node.js | ≥ 20 |

> ⚠️ **Pukkari käyttää Vite 5.4.2** — päivitä ensin Vite 8:aan (`vite-paivitys`-taito), sitten lisää Vitest.

## Prosessi

### 1. Asennus

```bash
npm install -D vitest @testing-library/react @testing-library/jest-dom \
  @testing-library/user-event jsdom
```

```javascript
// vite.config.js — lisää test-osio
export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/test/setup.js',
    css: true,
  },
})
```

```javascript
// src/test/setup.js
import '@testing-library/jest-dom'
```

```json
// package.json — scripts
{
  "test": "vitest",
  "test:run": "vitest run",
  "test:coverage": "vitest run --coverage"
}
```

### 2. Komponenttitesti — perusmalli

```javascript
// EventCard.test.jsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { EventCard } from './EventCard'

test('näyttää tapahtuman nimen ja päivämäärän', () => {
  render(<EventCard event={{ name: 'Treenit', date: '2026-04-20' }} />)
  expect(screen.getByText('Treenit')).toBeInTheDocument()
  expect(screen.getByText(/2026-04-20/)).toBeInTheDocument()
})

test('kutsuu onPress kun klikataan', async () => {
  const onPress = vi.fn()
  const user = userEvent.setup()
  render(<EventCard event={{ id: '1', name: 'Treenit' }} onPress={onPress} />)
  await user.click(screen.getByRole('button', { name: /treenit/i }))
  expect(onPress).toHaveBeenCalledWith('1')
})
```

### 3. Query-prioriteetti (tärkeysjärjestys)

```
1. getByRole        ← ensisijainen, saavutettavuusystävällinen
2. getByLabelText   ← lomakekentät
3. getByPlaceholderText
4. getByText        ← ei-interaktiiviset elementit
5. getByTestId      ← viimeinen vaihtoehto
```

Vältä: `container.querySelector`, CSS-luokkiin kohdistavat selektorit.

### 4. Hookin testaus

```javascript
import { renderHook, act } from '@testing-library/react'
import { useCounter } from './useCounter'

test('increment kasvattaa arvoa', () => {
  const { result } = renderHook(() => useCounter())
  act(() => result.current.increment())
  expect(result.current.count).toBe(1)
})
```

### 5. Asynkroninen testi

```javascript
test('näyttää datan latauksen jälkeen', async () => {
  render(<EventList />)
  expect(await screen.findByText('Treenit')).toBeInTheDocument()
})
```

`findBy*` odottaa automaattisesti. Älä käytä `waitFor`, jos `findBy` riittää.

## Parhaat käytännöt

- Testaa käyttäytyminen, ei toteutusta — *"mitä käyttäjä näkee"*, ei *"mitä state sisältää"*
- `beforeEach` resetoi mockit: `vi.clearAllMocks()`
- Mockaa verkko: `vi.mock('./api')` tai `msw` (Mock Service Worker)
- Coverage-tavoite: kriittiset polut 100%, kokonaisuus 70–80%
- Yksi `expect` per testi = huono — ryhmittele loogiset tarkistukset

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| `Cannot find module '@testing-library/jest-dom'` | Lisää `setupFiles` vite.configiin |
| `act()` -varoitus | Käytä `userEvent` `fireEvent` sijaan, `await findBy*` |
| Testi vuotaa toiseen | `cleanup` ajetaan automaattisesti, mutta resetoi mockit |
| `window is not defined` | `environment: 'jsdom'` puuttuu test-configista |

## Pukkari-sovellukseen

```
1. Asenna Vitest + Testing Library + jsdom
2. Setup: src/test/setup.js + vite.config.js test-osio
3. Aloita: EventCard.test → LoginForm.test → RsvpButton.test
4. CI: npm run test:run osana GitHub Actionsia (ks. git-tyonkulut)
```
