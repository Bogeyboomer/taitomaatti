---
name: claude-code-desktop
description: "Claude Code Desktop uudistettu huhtikuu 2026 — parallel sessions, Cmd+; side chat, integroitu terminaali, diff viewer. Käytä: Claude Code Desktop, parallel sessions, side chat, multiple Claude sessions, rinnakkaiset sessiot, uusi desktop-sovellus."
---

# Claude Code Desktop — Uudistus 14.4.2026

Anthropic uudisti Desktop-sovelluksen (Mac + Windows) 14.4.2026. Fokus: monen session hallinta yhdessä ikkunassa.

## Milloin käyttää

- Työn alla useita rinnakkaisia Claude-tehtäviä
- Pitkä tausta-ajo + nopea sivukysymys ilman kontekstin pilaamista
- IDE-korvaaja tai täydennys (terminaali + editori + diff sisäänrakennettu)
- Routines-seuranta samassa käyttöliittymässä

## Uudet ominaisuudet

| Ominaisuus | Kuvaus |
|-----------|--------|
| **Sidebar** | Kaikki aktiiviset + viimeiset sessiot, suodatus (status/projekti/ympäristö), ryhmittely projektin mukaan |
| **Parallel sessions** | Monta sessiota rinnakkain samassa ikkunassa — vaihda näkymää klikkaamalla |
| **Side chat** (`Cmd+;`) | Sivukysymys ilman että se sotkeutuu pääsession historiaan |
| **Integroitu terminaali** | Aja testit/buildit ilman poistumista |
| **In-app editor** | Pikamuokkaukset tiedostoihin |
| **Diff viewer** | Uudistettu, kestää ison changesetin |
| **Preview pane** | HTML, PDF ja paikalliset app-serverit |

## Työnkulku

### Monen session hallinta

```
Pääsessio: "Refaktoroi authentication"  ◆ aktiivinen
  └─ Side chat (Cmd+;): "Mikä on bcrypt rounds suositus 2026?"
     → vastaus vain tässä sivuikkunassa, pääsessio jatkuu

Toinen sessio: "Aja Taitomaatti-auditointi"  ◆ taustalla
Kolmas sessio: "Review PR #42"             ◆ valmis
```

### Suodatus ja ryhmittely

```
Sidebar → Filter:  status:running  project:pukkari
Sidebar → Group:   by project
```

## Näppäinkomennot

| Komento | Toiminto |
|---------|----------|
| `Cmd+;` | Side chat auki |
| `Cmd+N` | Uusi sessio |
| `Cmd+K` | Komentopaletti |
| `Cmd+1..9` | Vaihda sessioon N |
| `Cmd+T` | Integroitu terminaali |

## Parhaat käytännöt

- **Yksi sessio per tehtävä** — älä yritä tehdä kahta asiaa samassa sessiossa, käytä rinnakkaisia
- **Side chat nopeisiin kysymyksiin** — pääsession konteksti pysyy puhtaana
- **Projekti-ryhmittely** — nimeä sessiot projektin mukaan, suodata näkymä
- **Routines + Desktop** — seuraa ajastettujen tehtävien etenemistä sidebarista
- **Sulje valmiit sessiot** — vähentää visuaalista kuormaa

## Työnkulkumallit

### Malli 1: Pitkä työ + sivukysymykset

```
1. Pääsessio: "Migroi typescriptiin"   (työ jatkuu)
2. Cmd+;  "Miten tyypitän tämä generic?"
3. Pääsessio: jatkuu häiriöttä
```

### Malli 2: Rinnakkaiset tehtävät eri projekteille

```
Sessio A (Pukkari):    "Lisää RSVP-ominaisuus"
Sessio B (Taitomaatti): "Auditoi taidot"
Sessio C (muu repo):    "Tarkista CI-virheet"
```

### Malli 3: Ultraplan + toteutus samassa ikkunassa

```
Sessio 1: /ultraplan (pilvessä, merkki näkyy sidebarissa)
Sessio 2: odottaa planin valmistumista
→ kun ready, "inject into current session" → jatka sessiossa 2
```

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| Session katoaa sidebarista | Ei kadonnut — tarkista suodattimet (status-filter voi piilottaa) |
| Side chat -konteksti vuotaa | Side chat ei vuoda pääsessioon (by design) |
| Terminaali ei aukea | Päivitä Claude Code v2.2+ |
| Liian monta sessiota | Sulje valmiit — sidebarissa "Close completed" |

## Pukkari-sovellukseen

```
Sessio 1 (päärefaktorointi)  → "Konvertoi TS:ään typescript-siirtymä-taidolla"
Sessio 2 (testit, rinnakkain) → "Kirjoita Vitest-testit komponenteille"
Sessio 3 (tausta)            → Routine: nightly PR review
Cmd+;                        → nopeat kysymykset kumpaankaan sotkematta
```

## Resurssit

- [Desktop redesign — Anthropic](https://claude.com/blog/introducing-routines-in-claude-code)
- [MacRumors coverage](https://www.macrumors.com/2026/04/15/anthropic-rebuilds-claude-code-desktop-app/)
- [Parallel sessions review](https://devtoolpicks.com/blog/claude-code-desktop-redesign-parallel-sessions-2026)
