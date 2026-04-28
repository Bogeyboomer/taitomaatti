#!/bin/bash

# Skannaa Claude-sessiot ja kirjoittaa sessioanalyysi.json Taitomaatti-repoon

SESSIONS_DIR="$HOME/.claude/projects"
TAITOMAATTI_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Taitomaatti"
OUTPUT="$TAITOMAATTI_DIR/sessioanalyysi.json"
DAYS=30

echo ""
echo "=== Sessioanalyysi ==="
echo ""
echo "Skannataan sessiot viimeiseltä ${DAYS} päivältä..."

# Extract user messages from all JSONL files modified in last N days
python3 << PYEOF
import json, os, glob, sys, re
from datetime import datetime, timezone, timedelta

sessions_dir = os.path.expanduser("$SESSIONS_DIR")
cutoff = datetime.now(timezone.utc) - timedelta(days=$DAYS)

# Patterns that look like secrets — redact these
SECRET_PATTERNS = [
    r'ghp_[A-Za-z0-9]{36,}',
    r'github_pat_[A-Za-z0-9_]{80,}',
    r'gho_[A-Za-z0-9]{36,}',
    r'sk-[A-Za-z0-9]{40,}',
    r'sk-ant-[A-Za-z0-9\-_]{80,}',
    r'Bearer\s+[A-Za-z0-9\-_\.]{20,}',
    r'[A-Za-z0-9+/]{40,}={0,2}',  # base64-looking long strings
    r'eyJ[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+',  # JWT
]
SECRET_RE = re.compile('|'.join(SECRET_PATTERNS))

def redact(text):
    return SECRET_RE.sub('[REDACTED]', text)

def looks_like_secret(text):
    # Skip messages that are purely a secret token
    stripped = text.strip()
    if SECRET_RE.fullmatch(stripped):
        return True
    return False

projects = {}
total_messages = 0

jsonl_files = glob.glob(f"{sessions_dir}/**/*.jsonl", recursive=True)

for filepath in jsonl_files:
    mtime = os.path.getmtime(filepath)
    if datetime.fromtimestamp(mtime, tz=timezone.utc) < cutoff:
        continue

    # Extract project name from path
    parts = filepath.replace(sessions_dir + "/", "").split("/")
    project_raw = parts[0] if parts else "unknown"
    # Convert path encoding to readable name
    project_name = project_raw.replace("-Users-janimannisto-Library-Mobile-Documents-com-apple-CloudDocs-", "").replace("-", " ").strip()
    if not project_name:
        project_name = "home"

    messages = []
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    obj = json.loads(line)
                    if obj.get("type") == "user" and obj.get("message", {}).get("role") == "user":
                        content = obj["message"].get("content", "")
                        if isinstance(content, str) and len(content.strip()) > 5:
                            text = content.strip()
                            if looks_like_secret(text):
                                continue
                            ts = obj.get("timestamp", "")
                            messages.append({
                                "ts": ts,
                                "msg": redact(text)[:300]
                            })
                        elif isinstance(content, list):
                            for block in content:
                                if isinstance(block, dict) and block.get("type") == "text":
                                    text = block.get("text", "").strip()
                                    if len(text) > 5 and not looks_like_secret(text):
                                        messages.append({
                                            "ts": obj.get("timestamp", ""),
                                            "msg": redact(text)[:300]
                                        })
                except:
                    continue
    except:
        continue

    if messages:
        if project_name not in projects:
            projects[project_name] = []
        projects[project_name].extend(messages)
        total_messages += len(messages)

# Sort messages by timestamp per project
for proj in projects:
    projects[proj] = sorted(projects[proj], key=lambda x: x["ts"], reverse=True)[:50]

output = {
    "generated_at": datetime.now(timezone.utc).isoformat(),
    "period_days": $DAYS,
    "total_messages": total_messages,
    "projects": projects
}

output_path = "$OUTPUT"
with open(output_path, "w", encoding="utf-8") as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

print(f"  Projekteja: {len(projects)}")
print(f"  Viestejä yhteensä: {total_messages}")
for proj, msgs in projects.items():
    print(f"    {proj}: {len(msgs)} viestiä")
PYEOF

if [ $? -ne 0 ]; then
    echo "Virhe session skannauksessa."
    exit 1
fi

echo ""
echo "Pushataan GitHubiin..."

cd "$TAITOMAATTI_DIR" || exit 1
git add sessioanalyysi.json
git commit -m "chore: päivitä sessioanalyysi [$(date +%Y-%m-%d)]" --quiet 2>/dev/null || echo "  Ei muutoksia sessioanalyysiin."
git push origin main --quiet 2>/dev/null && echo "  Valmis." || echo "  Push epäonnistui — tarkista GitHub-yhteys."

echo ""
