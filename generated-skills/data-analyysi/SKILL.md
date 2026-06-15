---
name: data-analyysi
description: "Data-analyysi, visualisointi ja raportointi Pythonilla. Käytä aina kun käyttäjä haluaa: analysoida dataa, luoda kaavioita tai visualisointeja, käsitellä CSV/Excel-tiedostoja, laskea tilastoja, tehdä EDA-analyysin (exploratory data analysis), generoida raportteja datasta, tai kun käyttäjä sanoo 'analysoi data', 'tee kaavio', 'visualisoi', 'data analysis', 'chart', 'graph', 'statistics', 'tilastot', 'raportoi', 'pivot table', 'trend analysis', 'dashboard'. Käytä myös kun käyttäjä antaa CSV- tai Excel-tiedoston ja haluaa ymmärtää sen sisältöä."
---

# Data-analyysi — Datan analysointi ja visualisointi

Kattava taito datan analysointiin, visualisointiin ja raportointiin Python-ekosysteemillä. **2026 stack:** Polars (uudet projektit, 10–100x nopeampi) + DuckDB (SQL suurille tiedostoille) + Pandas (yhteensopivuus).

## Milloin käyttää

- CSV/Excel-tiedostojen analysointi
- Kaavioiden ja visualisointien luonti
- Tilastollinen analyysi
- Datan puhdistus ja muokkaus
- Automaattinen raportointi
- Trendien ja poikkeamien tunnistus

## Prosessi

### 1. Datan lataus ja tarkistus

```python
import pandas as pd

# Suosi Parquet-formaattia suurilla dataseteillä (nopeampi I/O)
# CSV:lle määrittele encoding ja separator
df = pd.read_csv('data.csv', encoding='utf-8', sep=';')  # Suomessa usein ; erottimena

# Ensimmäinen tarkistus
print(f"Rivejä: {len(df)}, Sarakkeita: {len(df.columns)}")
print(df.dtypes)
print(df.describe())
print(df.isnull().sum())
```

### 2. Datan puhdistus

Yleisimmät puhdistustoimenpiteet:
- Puuttuvien arvojen käsittely (täyttö, poisto, interpolointi)
- Duplikaattien poisto
- Tietotyyppien korjaus (päivämäärät, numerot)
- Outlierien tunnistus (IQR-menetelmä tai z-score)

Käytä aina vektorisoituja operaatioita — ei silmukoita. Pandas on optimoitu vektorioperaatioille.

### 3. Analyysi

**Perustilastot**: describe(), value_counts(), corr()
**Ryhmittely**: groupby() + agg() monipuolisiin aggregaatioihin
**Aikasarjat**: resample(), rolling(), shift() trendianalyysiin
**Pivot-taulukot**: pivot_table() moniulotteiseen tarkasteluun

### 4. Visualisointi — Oikean kaavion valinta

| Tarkoitus | Kaaviotyppi | Milloin käyttää |
|-----------|-------------|-----------------|
| Vertailu | Pylväskaavio (bar) | Kategorioiden vertailu keskenään |
| Trendi | Viivakaavio (line) | Aikasarjadata, muutoksen seuranta |
| Jakauma | Histogrammi/boxplot | Arvojen jakautuminen, outlierit |
| Osuudet | Pinottu pylväs | Kokonaisuuden osat (EI piirakka vertailussa) |
| Korrelaatio | Hajontakaavio (scatter) | Kahden muuttujan suhde |
| Muutos | Vesiputouskaavio (waterfall) | Peräkkäiset muutokset (budjetti, liikevaihto) |

**Piirakkakaavio**: Käytä vain likimääräisiin osuuksiin, max 5 kategoriaa. Pylväskaavio on lähes aina parempi vaihtoehto.

### 5. Visualisoinnin parhaat käytännöt

- **Värit**: Käytä selkeitä, erottuvia värejä. Huomioi värisokeus (vältä punainen/vihreä -yhdistelmää)
- **Akselien nimeäminen**: Nimeä AINA akselit ja yksiköt
- **Otsikko**: Kuvaava otsikko joka kertoo löydöksen, ei vain "Data"
- **Siisteys**: Poista turhat ruudukkoviivat, kehykset ja koristeet
- **Fonttikoko**: Vähintään 10pt luettavuuden varmistamiseksi

### 6. Raportointi

Luo raportit HTML- tai Excel-muodossa:

**HTML-raportti** (interaktiivinen):
- Plotly interaktiivisille kaavioille
- Jinja2-templateilla rakenteellinen raportti

**Excel-raportti** (liiketoiminnalle):
- openpyxl muotoilluille raporteille
- Kaaviot ja pivot-taulukot samassa tiedostossa

**PDF-raportti** (virallinen):
- ReportLab tai matplotlib → PDF

## Kaavamalli: EDA-analyysi

Kun käyttäjä antaa datatiedoston ilman tarkkaa pyyntöä, tee tämä:

1. Lataa data, näytä ensimmäiset rivit ja datatyypit
2. Laske perustilastot (describe)
3. Tarkista puuttuvat arvot ja duplikaatit
4. Tunnista numeeristen sarakkeiden jakaumat
5. Laske korrelaatiomatriisi numeerisille sarakkeille
6. Luo 3–5 relevanttia visualisointia
7. Tiivistä löydökset selkokielisesti

## Muistisääntö: Suomalainen data

- CSV-tiedostoissa erotin on usein puolipiste (;) eikä pilkku
- Desimaalierottimena usein pilkku (1234,56) — muunna pisteeksi ennen analyysia
- Päivämääräformaatti: pp.kk.vvvv (31.12.2026)
- Valuutta: euroa (€), ei dollareita
- Tuhanserotinta ei käytetä tai käytetään välilyöntiä (1 000 000)
