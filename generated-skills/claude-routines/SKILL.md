---
name: claude-routines
description: "Claude Code Routines — ajastetut pilvipohjaiset tehtävät (julkaistu 14.4.2026). Käytä: routines, ajasta tehtävä, /schedule, scheduled automation, recurring task, cron Claude, automaattinen raportti, nightly bug triage, daily PR review."
---

# Claude Routines — Ajastetut pilvitehtävät

Anthropic julkaisi 14.4.2026 (research preview). Routines ajavat Claude Code -tehtäviä **pilvessä** — kone ei tarvitse olla auki. Täydentää Ultraplania: Ultraplan = pitkä suunnittelu kerran, Routines = toistuva ajo aikataulussa.

## Milloin käyttää

- Toistuva tehtävä (päivittäin/viikoittain): PR-review, bug triage, riippuvuusauditointi
- Öinen raportti: kerää GitHub-tiedot, tee yhteenveto aamuksi
- Event-pohjainen laukaisu: uusi PR → analyysi automaattisesti
- Taitomaatti-auditointi itse ajastettuna (60 pv välein)

## Vaatimukset

| Tier | Routines / päivä |
|------|------------------|
| Pro | 5 |
| Max | 15 |
| Team / Enterprise | 25 |

Claude Code v2.2+, GitHub yhdistetty.

## Käynnistys — 3 tapaa

```bash
# 1. Slash-komento omassa sessiossa
/schedule daily PR review at 9am
/schedule weekly dependency audit on mondays

# 2. Dashboard
# claude.ai/code/routines → New routine

# 3. CLI suoraan
claude routines create --prompt "..." --cron "0 9 * * *"
```

Kaikki 3 tapaa kirjoittavat samaan pilviaccountiin — näkyy välittömästi kaikissa.

## Routine-rakenne

```
Routine = Prompt + Repo + Connectors + Trigger
                                       ├─ Schedule (cron)
                                       ├─ API call
                                       └─ GitHub event (PR, issue, push)
```

## Esimerkit

### 1. Päivittäinen PR-review klo 9

```
/schedule daily PR review at 9am in main repo

Prompt: "Tarkista kaikki avoimet PR:t. Listaa: 
- odottavat review:ta
- rikki oleva CI
- yli 7 pv vanhat
Postaa yhteenveto Slackiin."
```

### 2. Event-triggeröity PR-analyysi

```
Trigger: GitHub PR opened
Prompt:  "Tarkista PR vastaan CLAUDE.md. Kommentoi rikkomukset."
```

### 3. Taitomaatti-auditointi 60 pv välein

```bash
/schedule monthly audit on 1st at 10am

Prompt: "Aja Taitomaatti 2b — auditoi kaikki 16 omaa taitoa.
Tuota raportti: 🔴/⚠️/✅ per taito."
```

## Tulokset ja seuranta

```bash
claude routines list              # kaikki routines
claude routines runs ROUTINE_ID   # aiemmat suoritukset
claude routines logs RUN_ID       # yksittäinen ajo
```

Dashboard: session-linkit, event-historia, kustannukset per ajo.

## Parhaat käytännöt

- **Rajattu tehtävä per routine** — ei "tee kaikki", vaan "review PR:t" + erillinen "audit deps"
- **Testaa ensin manuaalisesti** — aja prompt interaktiivisesti → kun toimii, ajoita
- **Output-formaatti eksplisiittinen** — muuten tulokset vaihtelevat ajokerralta toiselle
- **Connectors määrittelyssä** — mitkä MCP-palvelimet käytössä (Slack, GitHub, jne.)
- **Aikarajoitus** — aseta `max_duration`, ettei yksi ajo syö päivän kiintiötä

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| Routine ei laukea | Tarkista cron-lauseke + tier-kiintiö |
| Kustannukset karkaavat | Aseta `max_tokens` / `max_duration` |
| GitHub-trigger ei toimi | Webhook-oikeudet puuttuvat — yhdistä uudelleen |
| Output epäjohdonmukainen | Tiukenna `<output_format>` promptissa |
| Päivän kiintiö loppu | Nosta tier tai karsi routineja |

## Taitomaattiin

```
Luo routine: "taitomaatti-audit"
  Cron: 0 10 1 * *  (kk 1. klo 10)
  Prompt: "Aja Taitomaatti-auditointi 2b, tuota raportti"
  Output: markdown-raportti taitorekisteriin
  Notify: Slack / email
```

## Resurssit

- [Routines documentation](https://code.claude.com/docs/en/routines)
- [Introducing routines — Claude blog](https://claude.com/blog/introducing-routines-in-claude-code)
- [9to5Mac coverage](https://9to5mac.com/2026/04/14/anthropic-adds-repeatable-routines-feature-to-claude-code-heres-how-it-works/)
