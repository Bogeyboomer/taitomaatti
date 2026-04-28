---
name: managed-agents
description: "Rakenna ja deployaa Claude Managed Agents (huhtikuu 2026). Käytä: managed agents, luo agentti, build agent, deploy agent, multi-agent, koordinaattori-agentti, Claude API agentti, agent session, agentti tuotantoon."
---

# Claude Managed Agents — Tuotantoagentit

Anthropicin huhtikuussa 2026 julkaisema pilvipalvelu autonomisille agenteille: tilalliset sessiot, pysyvä filesystem, pitkäkestoiset prosessit.

## Milloin käyttää

- Autonominen agentti ilman jatkuvaa valvontaa
- Useiden rinnakkaisten agenttien koordinointi
- Pitkäkestoiset prosessit (tuntia/päivää)
- Agentti tuotantosovellukseen API:n kautta
- Tila säilyy sessioiden välillä

## Arkkitehtuuri

```
Agent (pysyvä)
├── model, system_prompt, tools, skills
└── Session
    ├── status: RUNNING | COMPLETED | FAILED
    ├── event_history (server-side)
    └── /workspace/ filesystem
```

## API-rakenne

```python
import anthropic
client = anthropic.Anthropic()

# 1. Luo agentti kerran
agent = client.beta.managed_agents.create(
    name="data-analyst",
    model="claude-opus-4-7",
    system_prompt="Olet data-analyytikko...",
    tools=["bash", "files", "web_search"],
    skills=["data-analyysi"],
    beta_header="managed-agents-2026-04-01"
)
agent_id = agent.id  # tallenna

# 2. Käynnistä sessio
session = client.beta.managed_agents.sessions.create(agent_id=agent_id)

# 3. Stream
with client.beta.managed_agents.sessions.stream(
    session_id=session.id,
    message="Analysoi CSV..."
) as stream:
    for event in stream: print(event)
```

## Prosessi

### 1. Agenttimäärittely

| Valinta | Ohje |
|---------|------|
| Malli | Opus kompleksiin, Sonnet nopeampaan, Haiku yksinkertaiseen |
| System prompt | 800–2 000 tok. — rooli + rajoitteet + output |
| Työkalut | `bash`, `files`, `web_search`, MCP-serverit |
| Taidot | Max 20 per sessio |

### 2. Sessio

```python
# Tila
session = client.beta.managed_agents.sessions.get(session_id)
print(session.status)

# Event-historia (rajoita!)
events = client.beta.managed_agents.sessions.events.list(session_id, limit=50)
```

### 3. Multi-agent

```python
coordinator_prompt = """
Olet koordinaattori. Käynnistä subagentit tarvittaessa:
- research-agent: tiedonhaku
- writer-agent: sisältö
- reviewer-agent: laatu
Hallinnoi rinnakkaiset tehtävät.
"""
```

## System prompt -rakenne

```
ROOLI:             kuka agentti on
TEHTÄVÄT:          mitä tekee
RAJOITTEET:        mitä EI tee
OUTPUT:            miten raportoi
VIRHEENKÄSITTELY:  ongelmatilanteet
```

## Parhaat käytännöt

- **Tallenna `agent_id`** — luo kerran, käytä uudelleen
- **Tarkista `session.status`** ennen uusia viestejä
- **Käsittele SSE-stream** asynkronisesti
- **Workspace:** käytä aina `/workspace/`-etuliitettä
- **Kustannus:** Haiku kun Opus liioittelua; rajoita context-ikkunaa; aseta timeout

## Esimerkit — lyhyesti

```python
# 1. Data-analyysi
tools=["bash", "files"], skills=["data-analyysi"], model="claude-sonnet-4-6"

# 2. Multi-agent tutkimus
# Koordinaattori jakaa: research → writer → reviewer rinnakkain

# 3. CI/CD-integraatio
# PR-webhook → agentti analysoi + testaa → GitHub-kommentti MCP:n kautta
```

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| `401 beta header missing` | Lisää `managed-agents-2026-04-01` header |
| Session jumiutuu | Tarkista `status`, lähetä uusi viesti |
| Context overflow | `events.list(limit=N)` |
| Tiedosto katoaa | Aina `/workspace/`-etuliite |
| Korkeat kustannukset | Käytä Haiku/Sonnet kun Opusta ei tarvita |

## Resurssit

- [Managed Agents overview](https://platform.claude.com/docs/en/managed-agents/overview)
- [Agent SDK Skills](https://platform.claude.com/docs/en/agent-sdk/skills)
- [The AI Corner guide 2026](https://www.the-ai-corner.com/p/claude-managed-agents-guide-2026)
