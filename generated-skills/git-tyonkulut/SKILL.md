---
name: git-tyonkulut
description: "Git-työnkulut, PR-prosessit, conventional commits ja GitHub Actions CI. Käytä: git workflow, luo PR, pull request, commit-viesti, conventional commits, GitHub Actions, CI, branch strategy, koodikatselmointi."
---

# Git-työnkulut — Branch, PR, CI 2026

Trunk-based development + pienet PR:t + automaattinen CI on 2026 standardi. Long-lived feature branchit ovat tekninen velka.

## Milloin käyttää

- Projekti ei ole Git-hallinnassa tai käytössä on vain `main`
- Committit ovat epäjohdonmukaisia (`"fix"`, `"update"`)
- Ei PR-prosessia tai koodikatselmointia
- CI puuttuu — rikkinäinen koodi pääsee mainiin

## Prosessi

### 1. Branch-strategia — trunk-based

```
main                  ← aina deployattavissa, suojattu
  └─ feat/rsvp-ui     ← lyhytikäinen (< 2 pv), 1 PR
  └─ fix/login-error  ← bug fix
  └─ chore/deps       ← riippuvuudet, config
```

**Nimeäminen:** `<type>/<lyhyt-kuvaus>` — `feat/`, `fix/`, `chore/`, `docs/`, `refactor/`, `test/`

### 2. Conventional commits

```
<type>(<scope>): <lyhyt kuvaus>

[optional body]

[optional footer]
```

| Type | Käyttö |
|------|--------|
| `feat` | Uusi ominaisuus |
| `fix` | Bugikorjaus |
| `refactor` | Uudelleenkirjoitus ilman toiminnallisuusmuutosta |
| `test` | Testit |
| `docs` | Dokumentaatio |
| `chore` | Build, deps, config |
| `perf` | Suorituskykyparannus |

**Esimerkki:**
```
feat(rsvp): lisää pelaajan vahvistus-nappi

- Tallentaa vastauksen Supabaseen
- Optimistinen UI-päivitys

Closes #42
```

Breaking change: `feat!:` tai footer `BREAKING CHANGE: ...`

### 3. PR-työnkulku

```bash
git checkout main && git pull
git checkout -b feat/rsvp-ui
# ...työskentele, commita pieniä pätkiä...
git push -u origin feat/rsvp-ui
gh pr create --fill
```

**PR-koon rajat:**
- ≤ 400 riviä muutoksia → nopea katselmointi
- ≤ 10 tiedostoa → yksi looginen muutos
- Jos suurempi → pilko osiin

**PR-kuvaus:**
```markdown
## Mitä
Lisää RSVP-nappi tapahtumakortille.

## Miksi
Pelaajat tarvitsevat tavan vahvistaa osallistumisen.

## Testaus
- [ ] Yksikkötestit kattavat onnistumisen + virheen
- [ ] Manuaalinen kokeilu mobiilissa

Closes #42
```

### 4. GitHub Actions CI

```yaml
# .github/workflows/ci.yml
name: CI
on:
  pull_request:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run test:run
      - run: npm run build
```

### 5. Branch protection (GitHub Settings → Branches)

```
main:
  ✅ Require PR before merge
  ✅ Require status checks (CI must pass)
  ✅ Require 1 approval
  ✅ Dismiss stale approvals on new commits
  ✅ Require linear history (squash merge)
```

## Parhaat käytännöt

- **Squash-merge** PR-yhdistämisessä → siisti main-historia
- **Pienet committit** featurebranchissa OK — squash hoitaa lopun
- `git rebase main` ennen PR:n avausta — ei merge-committeja
- Älä committaa salasanoja — käytä `.gitignore` + `git-secrets` tai `gitleaks`
- Pre-commit hook (`husky` + `lint-staged`): aja linter ja formatoija automaattisesti

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| Merge conflict isossa PR:ssä | Rebaseaa main aikaisin ja usein |
| `git push --force` mainiin | Älä koskaan — käytä `--force-with-lease` omassa branchissa |
| Unohtunut `.env` commitissa | `git rm --cached .env`, lisää `.gitignore`, rotate avain |
| CI rikki PR:ssä | Aja `npm run test:run` paikallisesti ennen pushia |

## Pukkari-sovellukseen

```
1. git init + .gitignore (node_modules, dist, .env)
2. gh repo create + push main
3. Setup: husky + lint-staged pre-commit hookiin
4. .github/workflows/ci.yml: lint + test + build
5. Branch protection mainille
```
