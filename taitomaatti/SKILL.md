---
name: taitomaatti
description: "Luo, auditoi ja päivittää Claude-taitoja automaattisesti. Käytä: taitomaatti, luo taito, auditoi taidot, skill factory, päivitä taidot, ovatko taidot ajan tasalla, skill audit, mitä taitoja tarvitsen."
---

# Taitomaatti — Automaattinen Claude-taitojen kehitys

Tunnistaa taitotarpeet, tutkii ulkopuolisia lähteitä ja luo tai päivittää taitoja automaattisesti.

> Tarkemmat ohjeet: taidon luonti, validointi, varmuuskopiot, riippuvuudet, token-optimointi → **lue DETAILS.md**

## Käynnistys — aja aina session alussa

Kysy käyttäjältä (AskUserQuestion):

**"Taitomaatti on valmis! Mitä haluat tehdä?"**
- **Tutki uusia taitoja** → sykli 2a
- **Auditoi olemassa olevat** → sykli 2b
- **Tee molemmat** → 2b ensin, sitten 2a
- **Ei nyt** → ohita

### 2a — Uusien taitojen tunnistus ja luonti

1. **Skannaa** työkansio: teknologiat, tiedostotyypit, puuttuvat automatisoinnit
2. **Lue** asennetut taidot, tunnista aukot
3. **Päällekkäisyystarkistus** — vertaa uuden taidon `trigger_phrases` olemassa oleviin. Jos > 50 % päällekkäisyyttä → varoita, kysy käyttäjältä ennen jatkoa.
4. **Esitä** löydökset (AskUserQuestion)
5. **Tutki** (WebSearch) → kirjoita SKILL.md
6. **Validoi** (Vaihe 6 alla) — ennen rekisteröintiä
7. **Varmuuskopio** — `cp SKILL.md SKILL.md.backup`
8. **Päivitä** rekisteri: lisää `related_skills`, `external_tools`

**Vaihe 6 — Itsevalidointi** (ei skippaa):
```
✓ wc -c SKILL.md                    → < 4 500
✓ description sanamäärä             → ≤ 30
✓ frontmatter name == tiedosto      → täsmää
✓ sources-linkit validit            → curl -sI palauttaa 200
✓ frontmatter valmis yaml            → parsittavissa
```
Jos joku ✗ → korjaa ENNEN rekisteröintiä.

### 2b — Taitoauditointi

**PERUSSÄÄNTÖ:** Käy läpi KAIKKI `registry.generated_skills[]`. Ei ohituksia.

**Vaihe 0 — Tiedoston olemassaolo:**
```
test -f "<path>/SKILL.md" || 🔴 KADONNUT → palauta .backupista
```

**Vaihe 1 — Ikä** (`updated`-kentästä):
```
≤ 60 pv → ✅ | 61–120 → ⚠️ | > 120 → 🔴
```

**Vaihe 1b — Tokenikoko** (`wc -c`):
```
< 4 500 → ✅ | 4 500–7 000 → ⚠️ | > 7 000 → 🔴 jaa
```
Tarkista description ≤ 30 sanaa.

**Vaihe 1c — Versioseuranta** (per taito `external_tools`):
```
WebSearch "[tool] release notes 2026" → major bump? → ⚠️
```

**Vaihe 2 — Sisältötarkistus** (⚠️/🔴 WebSearchillä):
```
"[aihe] best practices 2026 update OR deprecated"
"[työkalu] release notes 2026"
```

**Vaihe 3 — Relevanssi + riippuvuudet:**
- Onko taito yhä käytössä projektissa?
- Tarkista `related_skills` — jos riippuvainen taito poistettu, merkitse orpo.

**Vaihe 4 — Raportti:**
```
TAITOAUDITOINTI — [pvm]
✅ Ajan tasalla:   N
⚠️  Tarkista:      N
🔴 Vanhentunut:   N
🔴 Liian suuri:   N
🔴 Kadonnut:      N
🔴 Rikkonut dep:  N

KATEGORIAT: { frontend: 8, claude-code: 3, testaus: 2, ... }
(Tasapainotarkistus: tasaisesti jakautunut?)

LÖYDÖKSET:
• [nimi]: [muutos] — [vakavuus]

Päivitetäänkö?
```

**Vaihe 5 — Päivitys:**
1. Kirjoita vain muuttuneet osiot
2. Päivitä .backup: `cp SKILL.md SKILL.md.backup`
3. Rekisteriin: `updated`, `last_audit`, `audit_status`, `word_count`, `changelog`
4. Päivitä `related_skills` jos uudet ristiviittaukset syntyivät

## Tarpeiden priorisointi

**toistuvuus** × **monimutkaisuus** × **vaikuttavuus**
Kriittinen päivitys (🔴) menee uuden taidon luonnin edelle.

## Automaattinen sykli (Tee molemmat)

1. Auditointi ensin
2. Uusien tunnistus
3. Priorisoi: 🔴-päivitykset ennen uusia
4. Tutki ja toteuta (WebSearch + validointi + backup)
5. Päivitä rekisteri (`last_scan`, `last_audit`)

## Kielituki

Taidot ensisijaisesti suomeksi. Description-triggerit FI + EN. Tekninen terminologia EN.
