---
name: liiketoiminta-analytiikka
description: "B2B-markkina-analyysi — TAM/SAM/SOM laskenta, ICP-määrittely, toimialavertailu, mahdollisuuksien pisteytys. Käytä: TAM, SAM, SOM, market sizing, ICP, markkina-analyysi, business case, toimialavertailu, B2B-analyysi."
---

# Liiketoiminta-analytiikka — TAM/SAM/SOM & B2B-markkina

Strukturoitu viitekehys markkinamahdollisuuksien arviointiin. Erityisesti B2B AI-agenttien ja SaaS-tuotteiden analyysiin.

## Milloin käyttää

- Arvioit uuden tuote- tai agentti-idean markkinapotentiaalia
- Vertailet toimialoja tai niche-markkinoita keskenään
- Tarvitset perusteltua dataa: mihin kannattaa panostaa?

## TAM / SAM / SOM — viitekehys

```
TAM — koko markkinapotentiaali jos jokainen asiakas ostaa
SAM — segmentti jonka voit tavoittaa tuotteella + jakelukanavalla
SOM — realistinen osuus 1–3 vuodessa (tyypillisesti 1–5 % SAM)
```

**Bottom-up (suositeltava B2B:ssä):**
```
TAM = kaikki potentiaaliset asiakkaat × ACV
SAM = ICP-filtteröity joukko × ACV
SOM = realistinen konversioprosentti × SAM
```

**Top-down (validointi):**
```
Gartner/IDC-raportti → koko markkina → kerro osuusprosentti
```

## ICP — Ideal Customer Profile

Määrittele ennen laskentaa. B2B AI -agentille:

| Attribuutti | Esimerkki |
|-------------|-----------|
| Toimiala | teknologia, taloushallinto, lakipalvelut |
| Koko (hlö) | 50–500 |
| Maantiede | Pohjoismaat, EU, USA |
| Teknologiapino | käyttää Salesforce, SAP, HubSpot? |
| Ongelma | toistuvat manuaaliset prosessit |

Mitä tarkempi ICP, sitä uskottavampi bottom-up-luku.

## Toimialan pisteytysmatriisi

| Kriteeri | Paino | Pisteet (1–5) |
|----------|-------|---------------|
| TAM (markkina €) | 25 % | 1=<10M, 5=>1B |
| ROI asiakkaalle | 25 % | 1=epäselvä, 5=selkeä säästö |
| Kilpailutilanne | 20 % | 5=tyhjä, 1=täynnä |
| Datan saatavuus | 15 % | 1=siiloitu, 5=strukturoitu API |
| Myyntisykli | 15 % | 5=itsepalvelu, 1=>12kk enterprise |

**Score = Σ(pisteet × paino)** — vertaile toimialoja samalla matriisilla.

## Analyysin prosessi

```
1. Tunnista ongelma: mitä manuaalista työtä tehdään toistuvasti?
2. Laske TAM: kuinka monta yritystä kärsii tästä ongelmasta?
3. ACV: mitä ratkaisusta maksetaan vuodessa? (benchmarkaa kilpailijoista)
4. SAM: tavoitettava osuus (ICP-filtterit: koko + maantiede + pino)
5. SOM: realistinen 3v osuus (1–5 % SAM)
6. Pistytä matriisilla: vertaa kilpaileviin toimiala-ideoihin
7. Validoi: onko rahoitettuja kilpailijoita? (Crunchbase)
```

## Tietolähteet

| Lähde | Käyttötarkoitus |
|-------|----------------|
| Apollo.io / LinkedIn Sales Nav | Yritysmäärät ICP-filttereillä |
| Gartner / IDC / Statista | Top-down TAM |
| Crunchbase | Funding-data, kilpailija-analyysi |
| G2 / Capterra | Onko ratkaisuja jo markkinoilla? |
| Hacker News / Reddit | Käyttäjien kipupisteet |

## Esimerkkipisteytys

```
Toimiala A — taloushallinto-agentti:
  TAM: 4×0.25 + ROI: 5×0.25 + Kilpailu: 2×0.20 + Data: 4×0.15 + Myynti: 2×0.15
  = 1.0 + 1.25 + 0.4 + 0.6 + 0.3 = 3.55 / 5

Toimiala B — rekrytointiagentti:
  TAM: 3 + ROI: 4 + Kilpailu: 1 + Data: 3 + Myynti: 4 = 3.0 / 5

→ Toimiala A voittaa pisteytyksessä
```

## Parhaat käytännöt

- **Bottom-up ensin**, top-down validointiin
- **ACV realistinen**: B2B SaaS tyypillisesti 1 000–50 000 €/vuosi
- **SOM max 5 % SAM** vuonna 1 — ylitys herättää epäilykset
- **Dokumentoi oletukset** — markkina-arviot vanhenevat nopeasti

## B2B-agentti-projektiin

```
1. Täytä ICP jokaiselle toimialaehdokkaalle
2. Hae yritysmäärät Apollo.io:sta tai LinkedIn Sales Navista
3. Arvioi ACV kilpailijoiden hinnoittelusta
4. Pistytä matriisilla → top-agentit.md-taulukkoon
5. Validoi top-3: Crunchbase-haku kilpailijoista
```

## Resurssit

- [TAM SAM SOM B2B guide — Landbase](https://www.landbase.com/blog/tam-vs-sam-vs-som-calculate-b2b-2026)
- [Bottom-up market sizing — Qubit Capital](https://qubit.capital/blog/bottom-up-market-sizing)
- [TAM SAM SOM 2026 — CharliA](https://www.charlia.io/en/blog/tam-sam-som-market-sizing-complete-guide)
