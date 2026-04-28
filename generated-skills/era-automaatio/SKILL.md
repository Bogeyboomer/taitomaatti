---
name: era-automaatio
description: "Eräajo ja joukkotoiminnot tiedostoille. Käytä: käsittele kaikki, batch, bulk, joukkotoiminto, eräajo, muunna kaikki, rename all, organize files, siivoa, järjestä tiedostot, konvertoi, mass update, find and replace all."
---

# Eräautomaatio — Joukkotoiminnot tiedostoille

Useiden tiedostojen käsittely, muuntaminen, uudelleennimeäminen ja organisointi turvallisesti.

## Milloin käyttää

- Formaattimuunnos (PNG → WebP, CSV → XLSX)
- Joukkouudelleennimeäminen säännöillä
- Kansiorakenteen organisointi
- Sisällön joukkopäivitys
- Duplikaattien tunnistus ja poisto

## Turvallisuusperiaatteet

1. **Dry run aina ensin** — näytä mitä tapahtuisi ennen toteutusta
2. **Pyydä vahvistus** — listaa muutokset, kysy lupa
3. **Varmuuskopio** — suurissa operaatioissa
4. **Peruutettavuus** — suosi kopio > poisto

## Prosessi

### 1. Kartoitus

```python
from pathlib import Path
from collections import Counter

def scan(path):
    files = [f for f in Path(path).rglob('*') if f.is_file()]
    ext = Counter(f.suffix.lower() for f in files)
    size = sum(f.stat().st_size for f in files)
    print(f"{len(files)} tiedostoa, {size/1024/1024:.1f} MB, {dict(ext)}")
    return files
```

### 2. Dry run

```python
def dry_run_rename(files, pattern):
    changes = [(f.name, apply_pattern(f, pattern)) for f in files]
    changes = [(o, n) for o, n in changes if o != n]
    print(f"Muutoksia: {len(changes)}/{len(files)}")
    for o, n in changes[:10]: print(f"  {o} → {n}")
    if len(changes) > 10: print(f"  ... +{len(changes)-10} muuta")
    return changes
```

### 3. Toteutus + lokitus

```python
def execute(changes, op):
    log = []
    for item in changes:
        try:
            log.append({"item": str(item), "status": "ok", "result": op(item)})
        except Exception as e:
            log.append({"item": str(item), "status": "error", "error": str(e)})
    ok = sum(1 for l in log if l["status"] == "ok")
    print(f"Valmis: {ok} ok, {len(log)-ok} virhettä")
    return log
```

## Yleiset operaatiot

### Uudelleennimeäminen — kaavat

- Päivämäärä eteen: `2026-04-13_file.txt`
- Juokseva numero: `kuva_001.jpg`
- Pienet kirjaimet: `MyFile.TXT` → `myfile.txt`
- Välilyönnit: `My File.txt` → `my-file.txt`
- Regex-korvaus monimutkaisiin

### Formaattimuunnos

| Tyyppi | Työkalu |
|--------|---------|
| Kuvat | Pillow (PNG↔JPG↔WebP, resize, optimize) |
| Dokumentit | pandoc, python-docx |
| Taulukot | pandas (CSV↔XLSX↔JSON↔Parquet) |
| Video/audio | ffmpeg |

### Find & replace

```python
def batch_replace(dir, pattern, find, replace, dry_run=True):
    changes = []
    for f in Path(dir).rglob(pattern):
        content = f.read_text(encoding='utf-8')
        if find in content:
            changes.append((f, content.count(find)))
            if not dry_run:
                f.write_text(content.replace(find, replace), encoding='utf-8')
    return changes
```

### Duplikaatit (hash-vertailu)

```python
import hashlib
def find_duplicates(dir):
    hashes, dups = {}, []
    for f in Path(dir).rglob('*'):
        if f.is_file():
            h = hashlib.md5(f.read_bytes()).hexdigest()
            if h in hashes: dups.append((f, hashes[h]))
            else: hashes[h] = f
    return dups
```

## Raportointi

Jokaisen eräajon jälkeen:
- Kuinka monta käsitelty
- Kuinka monta ok / virhe
- Mitä virheitä
- Mitä ei käsitelty ja miksi
