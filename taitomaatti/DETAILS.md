# Taitomaatti — Yksityiskohdat

## Kontekstin kartoitus

**Työkansio:** Tunnista käytetyt teknologiat (kielet, frameworkit), toistuvat tehtävätyypit, puuttuvat automatisoinnit.

**Olemassa olevat taidot:** Lue `.claude/skills/` — mitä on, mitä puuttuu, mitä voisi parantaa.

**Keskusteluhistoria:** Toistuvat tehtävät, alueet joissa Claude improvisoi, tehtävät jotka hyötyisivät standardista prosessista.

---

## Tutkimusstrategia

WebSearch-hakustrategiat per taito:

| Tavoite | Hakumuoto |
|---------|-----------|
| Parhaat käytännöt | `"best practices" [aihe] [vuosi]` |
| Tutkimukset | `"research" OR "study" [aihe] methodology` |
| Yhteisön viisaus | `[aihe] tips site:reddit.com OR site:stackoverflow.com` |
| Dokumentaatio | `[työkalu] documentation OR guide` |
| Päivitykset | `[aihe] 2026 new OR update OR release` |

Jokaisesta lähteestä tiivistä: periaatteet, sudenkuopat, konkreettiset mallit, työkaluvinkit.

Tallenna tulokset: `Taitomaatti/references/[nimi]-tutkimus.md`

---

## Taidon luonti

### Nimeäminen
- Kansionimi: kebab-case, lyhyt (`data-analyysi`, `api-testaus`)
- description: ≤ 30 sanaa — rakenne: `[Mitä tekee.] Käytä: [trigger1, trigger2, trigger3].`

### Tokenikiintiö

**Tavalliset taidot — PAKOLLINEN:**
```
description   ≤ 30 sanaa       (~40 tokenia)
SKILL.md      ≤ 4 500 merkkiä  (~1 200 tokenia)
```
Ylitys → jaa SKILL.md + DETAILS.md.

**Meta-taidot (taitomaatti ja vastaavat) — ERI SÄÄNNÖT:**
Meta-taidot saavat kasvaa, koska niiden tehtävä on sisältää riittävästi tietoa muiden taitojen luomiseen ja hallintaan. Kiintiö ei sovi niihin.

Ratkaisu: SKILL.md pysyy lean (operatiivinen ydin ≤ 4 500 merkkiä, ladataan aina), DETAILS.md saa kasvaa vapaasti — se ladataan vain kun meta-taito oikeasti tekee työtä. Meta-taito ei maksa kasvustaan normaalikäytössä.

### SKILL.md-rakenne (ydin ≤ 4 500 merkkiä)
```markdown
---
name: [nimi]
description: "[≤30 sanaa. Mitä tekee. Käytä: trigger1, trigger2, trigger3.]"
---

# [Otsikko]
[1–2 lausetta mitä tekee ja milloin.]

## Milloin käyttää
[Max 5 kohtaa]

## Prosessi
[Numeroidut ydinvaiheet — ei selittelyjä]

## Parhaat käytännöt
[Max 5 tärkeintä]

> Esimerkit ja virhetaulukot: katso DETAILS.md
```

### DETAILS.md-rakenne (referenssi, ladataan pyydettäessä)
```markdown
# [Nimi] — Yksityiskohdat

## Esimerkit
## Yleisimmät virheet
## Resurssit
```

### Tallennus
1. `Taitomaatti/generated-skills/[nimi]/SKILL.md` (+ DETAILS.md jos tarpeen)
2. Kopioi skills-hakemistoon asennusta varten
3. Päivitä taitorekisteri

---

## Token-optimointitekniikat

### Latausmekanismi

Claude lataa taidon ajamalla: `cat /path/to/skills/[nimi]/SKILL.md`  
Koko sisältö menee kontekstiin kerralla. DETAILS.md ladataan vain jos SKILL.md ohjeistaa sen lukemaan.

### Tarkka tokenilasku
```
wc -c SKILL.md     # Merkkimäärä — parempi proxy kuin sanat
1 merkki ≈ 0.25 tokenia (suomi)
Tavoite: < 4 500 merkkiä ≈ 1 200 tokenia
```

### Kirjoitustekniikat

**Taulukko korvaa luettelon (30–50 % säästö):**
```
# Huono: Virhe X: syy A, korjaus B. Virhe Y: syy C, korjaus D.
# Hyvä:
| Virhe | Syy | Korjaus |
| X | A | B |
| Y | C | D |
```

**Tiivistä rakenne — poista täyte:**
```
# Poista: "Muista aina...", "On tärkeää että...", "Voit myös..."
# Pidä: suorat ohjeet ilman perusteluja
# Pidä asia vain kerran — ei toistoja eri osioissa
```

**Koodiblokki rakenteiselle datalle:**
```
# Huono: Kiintiö on description alle 30 sanaa ja koko tiedosto alle 4500 merkkiä.
# Hyvä:  Kiintiö: description ≤30 sanaa | tiedosto ≤4500 merkkiä
```

### Description-kirjoitusopas

Description ladataan **kaikista taidoista joka sessiossa** — 42 taitoa × 80 sanaa = ~3 400 sanaa turhaa kulutusta.

```
# Huono (68 sanaa):
"Tämä taito auttaa analysoimaan dataa monipuolisesti käyttäen Pythonia
ja erilaisia kirjastoja kuten pandas ja matplotlib..."

# Hyvä (18 sanaa):
"Python-datanalyysi, visualisointi ja raportointi.
Käytä: analysoi data, tee kaavio, CSV, tilastot, visualisoi."
```

Trigger-fraasien valinta: 4–6 fraasia jotka käyttäjä todennäköisimmin sanoo. Lyhyet ja täsmälliset. Vältä yleissanoja ("tee", "luo") — triggeröivät liian usein.

### Prompt caching

Claude cachettaa taidon sisällön 5 minuutiksi. Cache osuu kun SKILL.md ei muutu sessioiden välillä. Cache rikkoutuu jos tiedostoon kirjoitetaan dynaamista dataa (päivämäärät, muuttuvat arvot) — älä tee sitä.

### Bloat-tarkistuslista ennen tallennusta
```
□ description ≤ 30 sanaa?
□ Sisältääkö "Muista", "On tärkeää", "Voit myös" → poista
□ Toistuuko ohje useammassa osiossa → pidä vain kerran
□ Voisiko luettelon korvata taulukolla?
□ Esimerkit ytimessä → siirrä DETAILS.md:hen
□ Resurssit/linkit ytimessä → siirrä DETAILS.md:hen
□ wc -c SKILL.md alle 4 500?
```

---

## Taitorekisteri — JSON-skeema

`Taitomaatti/taitorekisteri.json` — jokainen merkintä:

```json
{
  "name": "taidon-nimi",
  "created": "2026-04-17",
  "updated": "2026-04-17",
  "last_audit": "2026-04-17",
  "audit_status": "current|needs_review|outdated",
  "word_count": 410,
  "has_details_file": false,
  "backup_exists": true,
  "status": "active|draft|archived",
  "sources": ["url1", "url2"],
  "category": "kategoria",
  "description_fi": "Suomenkielinen kuvaus",
  "description_en": "English description",
  "trigger_phrases": ["fraasi1", "fraasi2"],
  "related_skills": ["toinen-taito", "kolmas-taito"],
  "external_tools": ["vite@5", "react@19", "tailwind@4"],
  "path": "generated-skills/taidon-nimi/",
  "changelog": [
    { "date": "2026-04-17", "change": "Kuvaus muutoksesta" }
  ]
}
```

Ylätason kentät:
```json
{
  "last_scan": "2026-04-17",
  "last_audit": "2026-04-17",
  "next_actions": ["..."],
  "identified_gaps": [{ "name": "...", "priority": "...", "reason": "..." }],
  "resolved_gaps": [{ "name": "...", "resolved_by": "...", "resolved": "..." }],
  "category_balance": { "frontend-kehitys": 8, "claude-code": 3, "testaus": 2 }
}
```

---

## Itsevalidointi — Vaihe 6 taidon luonnissa

Ennen rekisterin päivitystä, aja:

```bash
# 1. Tiedoston koko
size=$(wc -c < "<path>/SKILL.md")
[ "$size" -lt 4500 ] || echo "FAIL: yli 4500 merkkiä"

# 2. Description-sanat
desc=$(grep '^description:' SKILL.md | sed 's/.*: //;s/"//g')
words=$(echo "$desc" | wc -w)
[ "$words" -le 30 ] || echo "FAIL: description yli 30 sanaa"

# 3. Nimi-kansion yhteys
name=$(grep '^name:' SKILL.md | awk '{print $2}')
dir=$(basename "$(dirname SKILL.md)")
[ "$name" = "$dir" ] || echo "FAIL: name ei vastaa kansiota"

# 4. Linkit (sources)
# Aja curl -sI jokaiselle sources[]-linkille, vaadi 200/301/302
```

Yksikin FAIL → korjaa, älä rekisteröi.

---

## Varmuuskopiot

**Luonnin/päivityksen jälkeen:**
```bash
cp generated-skills/<name>/SKILL.md generated-skills/<name>/SKILL.md.backup
[ -f "generated-skills/<name>/DETAILS.md" ] && \
  cp generated-skills/<name>/DETAILS.md generated-skills/<name>/DETAILS.md.backup
```

**Auditoinnin Vaihe 0 laajennettu:**
```
test -f "<path>/SKILL.md" ||
  (test -f "<path>/SKILL.md.backup" && cp .backup SKILL.md ja merkitse 🟡 palautettu)
  || tarkista git-historia: `git log --diff-filter=D -- "<path>/SKILL.md"`
  || 🔴 KADONNUT: luo uudelleen
```

Rekisteriin: `backup_exists: true` kun .backup luotu.

---

## Päällekkäisyyden tunnistus ennen luontia

Ennen uuden taidon luontia iteroi rekisterin taidot:

```
new_triggers = set(uusi_taito.trigger_phrases)

päällekkäisyydet = []
jokaiselle existing in registry.generated_skills:
  existing_triggers = set(existing.trigger_phrases)
  overlap = new_triggers & existing_triggers
  jos |overlap| / |new_triggers| > 0.5:
    päällekkäisyydet.append((existing.name, overlap))

jos päällekkäisyydet:
  raportoi käyttäjälle:
    "Uusi taito <nimi> jakaa > 50 % triggereistä seuraavien kanssa:
       - <existing>: <overlap>
     Luodaanko silti / yhdistetäänkö / peruutetaanko?"
```

Päällekkäisyyden merkki myös silloin kun `category` sama + `description_fi` alku-n sanaa ~samat.

---

## Riippuvuuksien seuranta

**Kenttä `related_skills[]`** — muut taidot joihin tämä viittaa SKILL.md:ssä.

Luonti-aikana:
```
grep -oE '[a-z]+-[a-z]+' SKILL.md | sort -u
→ Tunnista mainitut taidon nimet → related_skills[]
```

Auditoinnin Vaihe 3 — tarkista orvot:
```
jokaiselle skill.related_skills[]:
  jos viitattu taito != active rekisterissä:
    merkitse skill ⚠️ "rikkonut dependency: <nimi>"
```

---

## Versioseuranta ulkoisista työkaluista

**Kenttä `external_tools[]`** formaatissa `<nimi>@<major>`:
```json
"external_tools": ["vite@5", "react@19", "tailwind@4", "@testing-library/react@14"]
```

Auditoinnin Vaihe 1c:
```
jokaiselle tool in external_tools:
  WebSearch "<tool-nimi> release notes 2026"
  jos löytyy major-bump (v5 → v6):
    merkitse taito ⚠️ "version-bump: <tool>@<vanha> → @<uusi>"
```

---

## Kategoria-tasapainoraportti

Jokaisen auditoinnin lopussa laske:
```
category_balance = Counter(skill.category for skill in generated_skills)
```

Kirjoita rekisterin ylätasolle. Raportissa:
```
KATEGORIAT:
  frontend-kehitys: 8  ⚠️ (yli 40 % kaikista — tasapaino)
  claude-code:      3
  testaus:          2
  backend:          1
  ...

Suositus: harkitse testaus-kategorian kasvattamista (vain 2/21 = 10 %).
```

Kynnys: jos jokin kategoria > 40 % kaikista → varoita ylikuormituksesta.

---

## Käytön seuranta (kevyt)

Claude Code ei tällä hetkellä tarjoa käyttömetriikkaa taidoille. Kevyt proxy:

**Käyttäjän palaute rekisteriin:**
```json
"user_feedback": [
  { "date": "2026-04-19", "rating": "hyödyllinen|ei-käytetty|vanhentunut", "note": "..." }
]
```

Kysy auditoinnissa käyttäjältä: *"Mitkä taidot oikeasti aktivoituivat viime 60 pv? Mitkä eivät?"*

Ei-käytetyt 2 auditointia peräkkäin → ehdota arkistointia (`status: "archived"`).
