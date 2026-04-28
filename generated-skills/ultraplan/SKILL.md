---
name: ultraplan
description: "Siirrä Claude Code -suunnittelu pilveen, terminaali vapautuu. Käytä: ultraplan, suunnittele pilvessä, cloud planning, /ultraplan, plan remotely, pitkä suunnitelma."
---

# Ultraplan — Pilvipohjainen suunnittelu Claude Codessa

Ultraplan siirtää suunnitteluvaiheen Anthropicin pilveen (Opus 4.7, max 30 min). Terminaalisi vapautuu heti — palaat vasta kun plan on valmis.

## Milloin käyttää

- Monimutkainen refaktorointi tai arkkitehtuurimuutos
- Suunnitelma vaatii syvällistä analyysiä (>5 min paikallisesti)
- Haluat kommentoida ja tarkistaa suunnitelman ennen toteutusta
- Tiimityö: jaa plan linkki muille kommentoitavaksi

## Vaatimukset

| Vaatimus | Arvo |
|----------|------|
| Claude Code | v2.1.91+ |
| Tili | Pro / Max / Team / Enterprise |
| GitHub | yhdistetty repositorio |

## Prosessi

**1. Käynnistys** — kolme tapaa:
```bash
/ultraplan migrate auth from sessions to JWTs
# TAI: kirjoita "ultraplan" normaaliin promptiin
# TAI: paikallisen planin jälkeen valitse "Refine with Ultraplan"
```

**2. Seuranta terminaalissa:**
```bash
/tasks   # valitse ultraplan-merkintä → näet session-linkin ja tilan
# Tila ◆ ultraplan ready = valmis tarkistettavaksi
```

**3. Tarkistus selaimessa:**
- Avaa session-linkki → dedikoidussa review-näkymässä
- Highlight tekstiä → jätä inline-kommentti
- Emoji-reaktiot osioihin (hyväksy / huolenaihe)
- Sidebar-outline → hyppää osioiden välillä

**4. Toteutus:**
```
"Approve plan and teleport back to terminal"
→ Inject into current session   (jatkaa kontekstissa)
→ Start new session             (puhdas aloitus)
→ Save to file                  (tallenna myöhempää varten)
```

## Parhaat käytännöt

- Anna selkeä, rajattu tehtävä — "migrate X to Y", ei "paranna koodia"
- Käytä inline-kommentteja ennen hyväksyntää: löydät ristiriidat aikaisemmin
- Tiimeissä: jaa linkki ennen hyväksyntää → kaikki näkevät saman planin
- Ultraplan kuluttaa enemmän tokeneita kuin paikallinen plan — käytä harkiten

## Yleisimmät virheet

| Virhe | Syy | Ratkaisu |
|-------|-----|----------|
| Ultraplan ei käynnisty | Claude Code versio vanha | `claude update` → v2.1.91+ |
| GitHub-virhe | Repo ei yhdistetty | Yhdistä `claude auth github` |
| Plan ei näy selaimessa | Session-linkki vanhentunut | `/tasks` → hae uusi linkki |
| Liian laaja tehtävä | Plan epämääräinen | Rajaa tehtävä tarkemmin |
