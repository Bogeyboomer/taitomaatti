---
name: react-deploy
description: "Deployaa React+Vite-sovellus Vercel tai Netlify -alustalle. Käytä: deploy, julkaise, Vercel, Netlify, production build, env-muuttujat, preview deploy, tuotantoon, hosting."
---

# React-deploy — Vercel / Netlify + Vite

Vercel ja Netlify ovat 2026 standardivalinnat React+Vite-deployille: Git-pohjainen CI/CD, preview-deployt jokaisesta PR:stä, ilmainen tier riittää pienille projekteille.

## Milloin käyttää

- Sovellus ajetaan vain lokaalisti (`npm run dev`)
- Jako muille vaatii demolinkin
- Tarvitaan preview-URL per PR
- Custom domain halutaan käyttöön

## Valinta: Vercel vai Netlify?

| Tekijä | Vercel | Netlify |
|--------|--------|---------|
| React+Vite | ⭐ Natiivi tuki | ⭐ Natiivi tuki |
| Edge Functions | ⭐ Paremmat | OK |
| Lomakkeet | — | ⭐ Built-in Forms |
| Build-minuutit (ilmainen) | 6000/kk | 300/kk |
| Bandwidth (ilmainen) | 100 GB | 100 GB |

**Sääntö:** Next.js → Vercel. Plain React+Vite → kumpi vain; Netlify jos tarvitset lomakkeiden käsittelyä ilman backendiä.

## Prosessi

### 1. Valmistele tuotantobuild

```bash
# Testaa että build toimii paikallisesti ensin
npm run build
npm run preview  # tarkista dist-kansio http://localhost:4173
```

### 2a. Vercel — 2 tapaa

```bash
# Tapa 1: CLI
npm i -g vercel
vercel           # seuraa promptteja
vercel --prod    # tuotantoon
```

```
# Tapa 2: Dashboard (suositeltu)
vercel.com → New Project → Import GitHub repo
Framework preset: Vite  (tunnistetaan automaattisesti)
Build command:   npm run build
Output dir:      dist
→ Deploy
```

### 2b. Netlify — 2 tapaa

```bash
# Tapa 1: CLI
npm i -g netlify-cli
netlify deploy              # preview
netlify deploy --prod       # tuotantoon
```

```
# Tapa 2: Dashboard
app.netlify.com → Add new site → Import from Git
Build command:   npm run build
Publish dir:     dist
→ Deploy
```

### 3. SPA-reititys (TÄRKEÄ)

React Router -reitit 404:ttaavat ilman konfiguraatiota:

```toml
# netlify.toml (projektin juuri)
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

```json
// vercel.json (projektin juuri)
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```

### 4. Env-muuttujat

```bash
# .env.local — vain paikallisesti (gitignore!)
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```

**Vite-sääntö:** Vain `VITE_`-alkuiset muuttujat paljastetaan frontille.

```
Vercel:  Project Settings → Environment Variables
Netlify: Site settings → Environment variables
```

Lisää sama muuttujasetti kolmeen ympäristöön: **Production / Preview / Development**.

### 5. Custom domain

```
1. Osta domain (Namecheap, Cloudflare)
2. Alustalla: Settings → Domains → Add
3. Aseta DNS: CNAME → cname.vercel-dns.com tai xxx.netlify.app
4. SSL myönnetään automaattisesti (Let's Encrypt)
```

### 6. Preview-deployt

Automaattisesti: **jokainen PR saa oman URL:n**.
- Vercel: `pukkari-git-feat-rsvp-username.vercel.app`
- Netlify: `deploy-preview-42--pukkari.netlify.app`

Jaa PR-kuvauksessa → katselmoija testaa selaimessa.

## Parhaat käytännöt

- **Älä commitaa `.env`-tiedostoja** — lisää `.gitignore`:en
- **Aseta env-muuttujat ennen ensimmäistä deployta** — muuten build kaatuu
- **Tarkista `dist`-koko** — jos > 1 MB, käytä `vite-plugin-compression` + code splitting
- **Security headers:** `netlify.toml` tai `vercel.json` → CSP, X-Frame-Options
- **Lighthouse CI** deploy-tarkistukseen (Performance ≥ 90, Accessibility ≥ 95)

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| 404 reiteillä | Lisää SPA-rewrite (`netlify.toml` / `vercel.json`) |
| `process.env.X` undefined | Vitessä käytä `import.meta.env.VITE_X` |
| Build ok paikallisesti, kaatuu pilvessä | Node-versio eroaa — lisää `"engines": { "node": "20" }` package.jsoniin |
| Env-muuttujat eivät päivity | Uusi deploy tarvitaan — env-muutos ei triggeröi sitä automaattisesti |

## Pukkari-sovellukseen

```
1. Varmista: npm run build toimii
2. Lisää vercel.json tai netlify.toml SPA-rewrite
3. Push GitHubiin → Import Vercel/Netlify-dashboardiin
4. Lisää VITE_SUPABASE_URL + VITE_SUPABASE_ANON_KEY
5. Custom domain: pukkari.fi → DNS-konfigurointi
6. PR → automaattinen preview → jaa joukkueelle testattavaksi
```
