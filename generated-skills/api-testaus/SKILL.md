---
name: api-testaus
description: "REST API -testaus ja validointi Python requests + pytest -stackilla. Käytä: testaa API, test API, API testing, endpoint, HTTP request, REST test, rajapinta, contract test, integraatiotesti."
---

# API-testaus — Python requests + pytest

REST-rajapintojen testaus ja validointi. Automaattiset testit löytävät regression ennen tuotantoa.

## Milloin käyttää

- Backend-API tarvitsee regressiotestit
- Rajapinta muuttuu usein → varmistettava taaksepäin yhteensopivuus
- Integraatiotesti frontend-backend -rajapinnalle
- CI:n pitää läpäistä API-testit ennen mergeä

## Asennus

```bash
pip install requests pytest pytest-cov python-dotenv jsonschema
```

```python
# conftest.py
import pytest, requests, os
from dotenv import load_dotenv

load_dotenv()

@pytest.fixture(scope="session")
def api():
    base = os.getenv("API_BASE_URL", "http://localhost:8000")
    session = requests.Session()
    session.headers.update({"Authorization": f"Bearer {os.getenv('API_TOKEN')}"})
    return (base, session)
```

## Perusmalli — endpoint-testit

```python
def test_get_events_200(api):
    base, s = api
    r = s.get(f"{base}/events")
    assert r.status_code == 200
    assert isinstance(r.json(), list)

def test_post_event_201(api):
    base, s = api
    payload = {"name": "Treenit", "date": "2026-04-20"}
    r = s.post(f"{base}/events", json=payload)
    assert r.status_code == 201
    assert r.json()["id"]

def test_unauthorized_401(api):
    base, _ = api
    r = requests.get(f"{base}/events")  # ei tokenia
    assert r.status_code == 401
```

## Skeemavalidointi (jsonschema)

```python
from jsonschema import validate

event_schema = {
    "type": "object",
    "required": ["id", "name", "date"],
    "properties": {
        "id": {"type": "string"},
        "name": {"type": "string", "minLength": 1},
        "date": {"type": "string", "format": "date"},
    },
}

def test_event_schema(api):
    base, s = api
    r = s.get(f"{base}/events/123")
    validate(r.json(), event_schema)
```

## Testikategoriat — kattavuus

| Kategoria | Mitä testataan |
|-----------|---------------|
| Happy path | 2xx oikeilla syötteillä |
| Validointi | 400 virheellisillä syötteillä |
| Auth | 401 ilman tokenia, 403 väärällä roolilla |
| Not found | 404 olemattomilla ID:illä |
| Rate limit | 429 kun kiintiö ylittyy |
| Idempotenssi | PUT/DELETE sama tulos toistettuna |
| Paginointi | Rajat (limit, offset, cursor) |
| Suorituskyky | `elapsed` < SLA (esim. 500 ms) |

## Parametrisointi

```python
import pytest

@pytest.mark.parametrize("payload,code", [
    ({"name": ""}, 400),
    ({"date": "virheellinen"}, 400),
    ({}, 400),
    ({"name": "OK", "date": "2026-04-20"}, 201),
])
def test_create_validation(api, payload, code):
    base, s = api
    assert s.post(f"{base}/events", json=payload).status_code == code
```

## Contract testing (schemathesis)

```bash
pip install schemathesis
schemathesis run http://localhost:8000/openapi.json
```

Generoi automaattisesti testitapaukset OpenAPI-spekseistä.

## Parhaat käytännöt

- **Itsenäiset testit** — jokainen testi luo + siivoaa datansa (fixture teardown)
- **Älä testaa tuotantoa** — omistettu test-ympäristö
- **Seed-data fixtureissa** — `@pytest.fixture` luo testikäyttäjän, siivoaa lopuksi
- **Mock ulkoiset riippuvuudet** — `responses`-kirjasto kolmannen osapuolen API:lle
- **CI**: `pytest --cov=api --cov-fail-under=80`

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| Flaky testit | Poista tilariippuvuudet, käytä `pytest-randomly` |
| Hidas CI | Rinnakkaista `pytest-xdist` — `pytest -n auto` |
| Token vuotanut | `.env` + `.gitignore`, älä koskaan commitoi |
| 404 CI:ssä mutta ei lokaalisti | Väärä `API_BASE_URL` env-muuttuja |

## Pukkari-sovellukseen

```
1. Backend API (Supabase tai oma) → endpointit: /events, /rsvps, /players
2. Testit: happy path + validointi + auth per endpoint
3. conftest.py: api-fixture + test-user-fixture teardownilla
4. GitHub Actions: pytest --cov ennen mergeä (ks. git-tyonkulut)
```
