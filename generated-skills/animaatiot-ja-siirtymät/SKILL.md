---
name: animaatiot-ja-siirtymät
description: "React-animaatiot Motion v12 (ent. Framer Motion) — screen-siirtymät, listanimaatiot, layout-animaatiot. Käytä: animaatio, siirtymä, Framer Motion, Motion, screen transition, lista animaatio, fade, slide, mobile animation."
---

# Animaatiot ja siirtymät — Motion v12

Motion (ent. Framer Motion) on React-animaatioiden standardi 2026. v12 julkaistu maaliskuu 2026 — täysi React 19 -tuki, hardware-accelerated scroll, uudet värityypit.

**Paketti:** `motion` (ei enää `framer-motion`)  
**Import:** `motion/react`

## Milloin käyttää

- Mobiilityylinen app tarvitsee sulavat screen-siirtymät
- Listan itemit animoidaan sisään/ulos (pelaajat, tapahtumat)
- UI-elementit reagoivat eleisiin (drag, tap, swipe)
- Shared element -transitio näkymien välillä (kortti → detail)

## Asennus

```bash
npm install motion
```

## Peruskäyttö

```tsx
import { motion } from 'motion/react'

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  exit={{ opacity: 0 }}
  transition={{ type: 'spring', stiffness: 300, damping: 30 }}
>
  Sisältö
</motion.div>
```

## Screen-siirtymät

```tsx
import { AnimatePresence, motion } from 'motion/react'

const variants = {
  enter: { x: '100%', opacity: 0 },
  center: { x: 0, opacity: 1 },
  exit: { x: '-100%', opacity: 0 }
}

function App() {
  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={currentScreen}
        variants={variants}
        initial="enter"
        animate="center"
        exit="exit"
        transition={{ type: 'spring', stiffness: 300, damping: 30 }}
      >
        <CurrentScreen />
      </motion.div>
    </AnimatePresence>
  )
}
```

## Listanimaatiot — stagger

```tsx
const container = {
  hidden: {},
  show: { transition: { staggerChildren: 0.07 } }
}
const item = {
  hidden: { opacity: 0, y: 16 },
  show: { opacity: 1, y: 0 }
}

<motion.ul variants={container} initial="hidden" animate="show">
  {players.map(p => (
    <motion.li key={p.id} variants={item}>{p.name}</motion.li>
  ))}
</motion.ul>
```

## Layout-animaatiot (shared element)

```tsx
// Listassa
<motion.div layoutId={`card-${event.id}`}>
  <EventCard event={event} />
</motion.div>

// Detailissa — Motion animoi automaattisesti välissä
<motion.div layoutId={`card-${event.id}`}>
  <EventDetail event={event} />
</motion.div>
```

## Bundle-optimointi

```tsx
import { LazyMotion, domAnimation, m } from 'motion/react'
// LazyMotion pienentää bundia 30 KB → 15 KB
<LazyMotion features={domAnimation}>
  <m.div animate={{ opacity: 1 }}>...</m.div>
</LazyMotion>
```

## Saavutettavuus

```tsx
const prefersReduced = useReducedMotion()
const transition = prefersReduced ? { duration: 0 } : { type: 'spring' }
```

## Parhaat käytännöt

- **Vain transform + opacity** → 60fps, ei layout-laskentaa
- **variants-tiedosto** — kerää animaatiot yhteen `lib/motion-variants.ts`
- **AnimatePresence mode="wait"** screen-siirtymissä (yksi ruutu kerrallaan)
- **spring-fysiikka** mobiilissa — luonnollisempi kuin easing

## Pukkari-sovellukseen

```
1. npm install motion
2. App.jsx: kääri <AnimatePresence> → screen-siirtymät slide-efektillä
3. PlayerList, EventList: stagger-animaatio itemien sisääntulolle
4. EventCard → EventDetail: layoutId shared element -transitiolle
5. LazyMotion tuotannossa — bundle 15 KB vs 30 KB
```

## Resurssit

- [Motion for React — docs](https://motion.dev/docs/react)
- [AnimatePresence & page transitions](https://motion.dev/docs/react-animate-view)
- [Layout animations](https://motion.dev/docs/react-layout-animations)
