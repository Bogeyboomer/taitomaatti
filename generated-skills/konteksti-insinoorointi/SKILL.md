---
name: konteksti-insinoorointi
description: "Context engineering — optimoi AI-agentin koko informaatioympäristö. Käytä: context engineering, konteksti-insinoorointi, optimoi system prompt, paranna CLAUDE.md, agentti improvisoi, prompt liian pitkä, context window."
---

# Konteksti-insinoorointi — Context Engineering

Korvaa prompt engineeringin 2026 tärkeimpänä AI-taitona. Arkkitehtuureitsee koko informaatioympäristön: system promptit, muistin, työkalut, esimerkit, historian.

> *"The quality of prompts matters less than the quality of context fed to models."* — 9 649 kokeeseen perustuva tutkimus, 2026

## Milloin käyttää

- CLAUDE.md / SKILL.md ei ohjaa Claudea halutusti
- Agentti improvisoi tehtäviä joihin ei pitäisi
- System prompt yli 3 000 tokenia → järkeily heikkenee
- Multi-agent-järjestelmä arvaamaton

## Kontekstin 6 kerrosta

```
1. SYSTEM PROMPT   Rooli + rajoitteet
2. TOOLS           Mitä Claude voi tehdä
3. MEMORY          Mitä Claude muistaa
4. RETRIEVAL       Mitä haetaan tarvittaessa
5. EXAMPLES        Few-shot demot
6. MESSAGE HISTORY Aiempi keskustelu
```

## Prosessi

### 1. Diagnoosi

```
Improvisoi liikaa        → System prompt epämääräinen
Ignoroi ohjeet           → Context ylikuormittunut (>3000 tok.)
Epäjohdonmukainen        → Puuttuvat few-shot-esimerkit
Hidas                    → Liikaa tarpeetonta kontekstia
Virheellinen output      → Puuttuva output_format
```

### 2. System promptin rakenne (XML)

```xml
<role>Olet [ROOLI]. Erikoisosaamistasi on [ALUE].</role>

<capabilities>
Voit: [lista]
Et voi: [rajoitteet]
</capabilities>

<process>
1. [Askel]
2. [Askel]
</process>

<output_format>
[Tarkka formaatti + esimerkki]
</output_format>

<constraints>
- [Rajoite]
</constraints>
```

### 3. Just-in-time -konteksti

```python
# HUONO: lataa kaikki (50 000 tok.)
context = load_entire_database()

# HYVÄ: hae vain tarvittava (~500 tok.)
relevant = search_by_embedding(task, limit=5)
```

### 4. Muistinhallinta

```
Lyhytaikainen (history)     → katkaise vanhat, säilytä viimeiset N
Pitkäaikainen (tiedostot)   → semanttinen haku, älä lataa kaikkea
Työmuisti (tool results)    → tiivistä ennen palautusta
```

### 5. Few-shot -esimerkit (3–5 kpl)

```xml
<examples>
<example>
Input: "Analysoi Q1 myynti"
Output: { "summary": "...", "metrics": [...] }
</example>
</examples>
```

## Parhaat käytännöt

**Tokenitehokkuus:**
- System prompt optimum: **150–300 sanaa** (400–800 tokenia)
- Rikkoutumispiste: ~3 000 tokenia
- Poista kohteliaisuudet ja toistot

**Priorisointi:**
```
KRIITTINEN    Rooli, rajoitteet, output-formaatti
TÄRKEÄ        Projektikäytännöt, esimerkit
VALINNAINEN   Detaljit, referenssit
POISTA        Toistot, ilmiselvät selitykset
```

**CLAUDE.md-rakenne:**
```markdown
## Projekti (2–3 lausetta)
## Käytännöt (luettelo)
## Kielletyt toimet
## Output-formaatti
```

## Ennen/jälkeen

**ENNEN (2 800 tok., epämääräinen):**
> "Olet avulias AI-assistentti joka auttaa monenlaisissa tehtävissä. Olet ystävällinen..."

**JÄLKEEN (600 tok., täsmällinen):**
```xml
<role>Koodirevisoija — analysoit PR:t, löydät bugit ennen mergeä.</role>
<process>1. Lue diff  2. Tunnista bugit/turvat  3. Ehdota korjaukset</process>
<output_format>{"severity": "high|medium|low", "issues": [...], "approved": bool}</output_format>
```

## Yleisimmät virheet

| Virhe | Oire | Korjaus |
|-------|------|---------|
| Context stuffing | Ignoroi ohjeet | Leikkaa < 2 000 tok. |
| Epämääräinen rooli | Improvisoi | Eksplisiittinen rajoitelista |
| Puuttuva output-format | Epäjohdonmukainen | Lisää esimerkki |
| Kaikki kerralla | Hidas, kallis | Just-in-time -haku |
| Ei esimerkkejä | Väärä taso | 3–5 few-shot |

## Resurssit

- [Effective context engineering — Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Context Engineering Guide 2026 — The AI Corner](https://www.the-ai-corner.com/p/context-engineering-guide-2026)
