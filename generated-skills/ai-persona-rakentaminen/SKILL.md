---
name: ai-persona-rakentaminen
description: "Rakenna valmis AI-persona tai -järjestelmä — identiteetti, system prompt, käyttäytymissäännöt ja web-UI. Käytä kun: 'rakenna AI-assistentti', 'luo AI-hahmo', 'kirjoita system prompt', 'tee AI-asiantuntija', 'persoonallisuus AI:lle', 'AI Oracle', 'rakenna neuvoja-AI'."
---

# AI-persona-rakentaminen — Valmiin AI-järjestelmän luonti

Taito rakentaa täydellinen AI-persona: identiteetti, system prompt, käyttäytymissäännöt ja web-UI. Käytetty mm. Aatos v5.5 (kansalaisneuvoja) ja B2B Discovery Engine.

## Prosessi

### Vaihe 1: Identiteetti ja rooli

Määrittele ensin:
- **Nimi ja versio**: Esim. "Aatos v5.5" tai "B2B Discovery Engine"
- **Ympäristö**: Konteksti jossa toimii (Suomi 2026, logistiikka-markkina...)
- **Rooli 1 lauseessa**: Täsmällinen — "Et ole chatbot. Olet [TARKKA ROOLI]."
- **Mitä EI tee**: Eksplisiittiset kiellot ovat tehokkain tapa välttää geneerisyyttä

### Vaihe 2: System prompt — Moduulirakenne

2026 parhaat käytännöt: system prompt moduuleina, alle 2000 sanaa:

```
ROOLI: [1 rivi]
VERSION: [numero + nimi]
YMPÄRISTÖ: [konteksti]

MODUULI 1: ONTOLOGIA JA FILOSOFIA
[Miksi tämä persona toimii näin — arvot, toimintaperiaatteet]

MODUULI 2: YDINTEHTÄVÄT
[Konkreettiset tehtävät numeroituna — mitä teet]

MODUULI 3: PROSESSI
[Vaiheittainen toimintamalli — ensin X, sitten Y, lopuksi Z]

MODUULI 4: RAJOITUKSET
[Mitä en tee, mitä en sano, missä rajat menevät]

MODUULI 5: ULOSTULOFORMAATTI
[Muoto, pituus, rakenne, kieli, tyyli]

EPÄVARMUUDENKÄSITTELY:
[Miten toimin kun en tiedä tai tilanne on ristiriitainen]
```

**Tärkeää:** Yli 3000 sanaa heikentää ohjeiden noudattamista. Moduulirakenne helpottaa iteroinnin — muokkaat yhtä moduulia kerrallaan.

### Vaihe 3: Web-UI (HTML-artifact)

Kun persona tarvitsee selainliittymän (kuten Aatos):

```html
<!DOCTYPE html>
<html lang="fi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>[Persona nimi]</title>
  <style>/* Inline CSS — ei CDN-riippuvuuksia */</style>
</head>
<body>
  <!-- 1. Hero: Persona nimi + motto/kuvaus -->
  <!-- 2. Tilannevalinta: button-grid tai dropdown -->
  <!-- 3. Syötealue: käyttäjän viesti -->
  <!-- 4. Ulostuloalue: vastauksen esitys -->
</body>
</html>
```

**UI-periaatteet:**
- Persona-identiteetti näkyvissä heti (nimi, versio, motto)
- Max 3 vaihetta käyttäjälle: valitse tilanne → kirjoita → saa vastaus
- Mobile-first, toimii puhelimella
- Yksi HTML-tiedosto, kaikki inline — helppo jakaa ja arkistoida

### Vaihe 4: Versiointi

- Aloita **v1.0** — yksinkertainen, toimiva ydintehtävä
- Iteroi versioittain: v1.1, v1.2 → v2.0 (iso muutos) → Master Edition (vakiintunut)
- Kirjaa muutokset: `## Versiohistoria` blokkiin
- Testaa "reunatapaukset": mitä persona tekee oudon/haastavan kysymyksen kohdalla?

## Arkkityypit

| Tyyppi | Käyttö | Esimerkki |
|--------|--------|-----------|
| Oracle | Neuvoo tietystä domainista | Aatos (laki/hallinto) |
| Analyytikko | Käy läpi dataa/tilanteita | B2B Discovery Engine |
| Spesialisti | Yhden alan ekspertti | Lääketieteen neuvoja |
| Koordinaattori | Ohjaa monivaiheiset prosessit | Projektipäällikkö-AI |

## Muistisäännöt

- "Et ole chatbot" — eksplisiittinen identiteetin kieltäminen on tehokkain keino erikoistumiseen
- System prompt on koodi — versioi, testaa, dokumentoi kuten koodi
- Testaa aina kolme tapausta: tyypillinen, reunatapaus, tahallinen väärinkäyttö
- HTML-artifact: yksi tiedosto on aina parempi kuin useat — helpompi jakaa
