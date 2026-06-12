# Taitomaatti UI — Järjestelmätiedot-teema

Sci-fi/HUD-tyylisen "Järjestelmätiedot"-dashboardin visuaalinen ilme
purettuna uudelleenkäytettäväksi teemapaketiksi Electron-sovellukseen.

## Visuaalinen analyysi (lähdekuvasta)

| Osa-alue | Toteutus |
|---|---|
| Tausta | Lähes musta (`#060403`), lämmin pronssihehku ylä-/alareunassa, vinjetointi |
| Paneelit | Tummat läpikuultavat kortit, 1px pronssireuna, kirkkaat L-kulmamerkit, hehkuvarjo |
| Pääaksentti | Meripihka/oranssi (`#f2b04e` … `#ff8c2e`) — otsikot, mittarit, korostepalkit |
| Datavari | Kirkas sininen (`#5aa9ff`) — palkit, linkit, lukuarvot |
| Status | Vihreä `#49d68a`, punainen `#ff5d3a` |
| Typografia | Condensed sans (Bahnschrift/Saira), versaaliotsikot harvennuksella, monospace lokeissa |
| Erikoisuudet | Viistetty otsikkoplakaatti, oranssit gradienttiotsikot korostepaneeleissa ("+ uusi") |

## Tiedostot

```
taitomaatti-ui/
├── main.js                      # Electron-pääprosessi (demoa varten)
├── package.json
└── renderer/
    ├── index.html               # demo: kaikki komponentit käytössä
    ├── chart-theme.js           # Chart.js-paletti ja -oletukset
    └── styles/
        ├── tokens.css           # design-tokenit (värit, fontit, mitat)
        ├── base.css             # nollaus, tausta, typografia, scrollbarit
        └── components.css       # paneelit, mittarit, taulukot, napit jne.
```

## Demon ajo

```bash
cd taitomaatti-ui
npm install
npm start
```

## Liittäminen olemassa olevaan Electron-sovellukseen

1. Kopioi `renderer/styles/` ja lataa CSS:t tässä järjestyksessä:
   ```html
   <link rel="stylesheet" href="styles/tokens.css" />
   <link rel="stylesheet" href="styles/base.css" />
   <link rel="stylesheet" href="styles/components.css" />
   ```
2. Aseta `BrowserWindow`-ikkunalle `backgroundColor: "#060403"`, jotta
   käynnistyksessä ei vilahda valkoista.
3. Jos käytät Chart.js:ää, kutsu `applyChartTheme(Chart)` tiedostosta
   `chart-theme.js` — kaaviot saavat saman paletin kuin muu UI.
4. Kaikki värit ja mitat ovat CSS-muuttujia (`tokens.css`), joten koko
   ilmeen voi säätää yhdestä paikasta.

## Keskeiset komponenttiluokat

- `.app`, `.titlebar`, `.plaque` — sovelluksen runko ja viistetty otsikkokilpi
  (varoitusraidat ja koristelinjat tulevat `.titlebar`-pseudoelementeistä)
- `.sidebar` + `.sidebar__pill` + `.nav-item` — kelluva pyöristetty
  navigaatiokapseli, ikonit omissa kehyksissään
- `.board` + `.col` — tiheä monisarakkeinen dashboard-ruudukko
- `.panel`, `.panel--accent` — viistekulmainen paneeli kultaisella
  gradienttireunalla (clip-path + kaksi pseudoelementtikerrosta);
  accent-versiossa oranssi gradienttiotsikko
- `.subhead` — paneelin sisäiset alaotsikot
- `.stat`, `.stat__value(--amber|--blue|--sm)`, `.stat-row` — tunnusluvut
- `.badge(--amber|--green|--outline)`, `.status-dot(--warn|--err)`
- `.inset` — ruudukkotaustainen kaaviopohja
- `.bars`, `.bars--3d`, `.bars--spark` + `.bars__bar(--blue)` —
  pylväskaaviot; `--3d` lisää kuutiomaisen ylä- ja kylkipinnan
- `.chart-line` — hehkutyylit SVG-viivakaavioille
- `.hbar-list` — top-listat vaakapalkeilla
- `.donut` (`--s1/--s2/--s3` tai `--d`) — donitsikaavio conic-gradientilla
- `.ring-gauge` + `.ring` (`--p`, `--c`, `--i`) — monirenkainen
  Terveyspisteet-mittari asteikkoviivoineen (`.ring--ticks`)
- `.bubbles` + `.bubble(--amber)` — kuplakaavio
- `.progress`, `.terminal`, `.loglist`, `.table`, `.kv`, `.feed`,
  `.btn(--primary)`, `.legend`

3D-konehuonetausta (perspektiivinen katto ja lattia) piirretään
`body::before/::after`-kerroksilla (`base.css`); sisältö on niiden
yläpuolella (`.app { z-index: 1 }`).
