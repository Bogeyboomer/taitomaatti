---
name: suomi-sisalto
description: "Suomenkielisen sisällön luonti, tarkistus ja lokalisointi Kotus-ohjeiden mukaisesti. Käytä: kirjoita suomeksi, tarkista kielioppi, suomenna, käännä suomeksi, Finnish translation, localize to Finnish, oikoluku, selkosuomi, liikekirje."
---

# Suomi-sisältö — suomenkielisen sisällön mestari

Perustuu Kotimaisten kielten keskuksen (Kotus) ohjeisiin.

## Milloin käyttää

- Liikeviestintä suomeksi (sähköposti, raportit)
- Oikoluku ja kieliopintarkistus
- Käännös en → fi
- Ohjelmiston lokalisointi
- Selkosuomi
- Viralliset asiakirjat

## Suomen kielen perusperiaatteet

### Kielioppi

1. **Yhdyssanat yhteen** — `tietokone` (ei "tieto kone"), `linja-auto`. Yleisin virhe.
2. **Ei futuuria** — preesens: *"Teen sen huomenna"* (ei *"tulen tekemään"*)
3. **Isot kirjaimet** — vain virkkeen alku + erisnimet. Ei otsikoissa jokainen sana.
4. **Pilkku** — aina ennen `että`, `jotta`, `koska`, `vaikka` kun aloittaa sivulauseen.
5. **Passiivi** — yleisempi kuin englannissa: *"Suomessa syödään ruisleipää."*

### Tyylitasot

| Taso | Tunnuspiirteet |
|------|---------------|
| Virallinen | Teitittely, passiivi, kirjakieli: *"Voisitteko toimittaa..."* |
| Asiallinen | Sinuttelu/passiivi kontekstin mukaan, selkeä, yleiskieli |
| Epämuodollinen | Sinuttelu, puhekieliset muodot ok, lyhyet virkkeet |

### Liikeviestintä — suomalainen tyyli

- **Suora** — ei kiertoilmaisuja
- **Tehokas** — lyhyet virkkeet
- **Tasavertainen** — hierarkia vähäisempi kuin monissa kulttuureissa
- **Luotettava** — lupaa vain mitä pidät

## Lokalisointi — huomioi

1. **Tekstin laajeneminen** — suomi ~30–40 % pidempi kuin englanti (yhdyssanat, taivutus). UI:n pitää skaalautua.
2. **15 sijamuotoa** — UI-elementtien toimittava eri muodoissa:
   - *"Avaa tiedosto"* (perusmuoto)
   - *"Tiedoston avaaminen"* (genetiivi)
   - *"Tiedostossa"* (inessiivi)
3. **Vakiintuneet käännökset:**

| Englanti | Suomi |
|----------|-------|
| File | Tiedosto |
| Save | Tallenna |
| Settings | Asetukset |
| Download | Lataa |
| Upload | Lähetä |
| Dashboard | Koontinäyttö |

4. **Älä käännä kaikkea** — säilytä: API, URL, SQL, HTML, CSS, framework, backend, frontend.

## Prosessi

1. **Konteksti** — tyyli, kohderyhmä, tarkoitus
2. **Tyylitaso** — virallinen / asiallinen / epämuodollinen
3. **Kirjoita/tarkista** — noudata periaatteita yllä
4. **Oikolue** — yhdyssanat, pilkutus, johdonmukaisuus
5. **Luenta** — kuulostaako luonnolliselta?

## Yleisimmät virheet

| Virhe | Korjaus |
|-------|---------|
| Erikseen kirjoitettu yhdyssana | `tietokone`, ei *tieto kone* |
| Turha anglismi | `käyttöliittymä`, ei *user interface* |
| Väärä pilkutus | *"Hän sanoi, että..."* (pilkku ennen `että`) |
| Iso alkukirjain otsikoissa | *"Tämän vuoden tulokset"* (ei *"Tämän Vuoden Tulokset"*) |
| Futuurimuoto | *"Teen huomenna"* (ei *"tulen tekemään"*) |

## Lähteet

- Kotus: kotus.fi/ohjeet
- Kielitoimiston ohjepankki
- Oikofix
