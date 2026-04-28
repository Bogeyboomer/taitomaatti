#!/bin/bash

TAITOMAATTI_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Taitomaatti"
CLAUDE_SKILLS_DIR="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/45dbf687-9614-43b6-ac04-9b5887fc8084/b7ee5153-d812-4a95-bea7-50cf9d8a3ced/skills"

cd "$TAITOMAATTI_DIR" || exit 1

echo ""
echo "=== Taitomaatti Sync ==="
echo ""

# Step 0: Scan sessions and push to GitHub first
echo "Skannataan sessiot..."
bash "$TAITOMAATTI_DIR/skannaa-sessiot.sh"

# Pull from GitHub
echo "Haetaan muutokset GitHubista..."
git fetch origin main --quiet

CHANGES=$(git diff --name-only HEAD origin/main 2>/dev/null)

if [ -z "$CHANGES" ]; then
  echo "Ei muutoksia. Taidot ovat ajan tasalla."
  echo ""
  exit 0
fi

# Show what changed
echo "Muutokset:"
echo ""

NEW_SKILLS=()
UPDATED_SKILLS=()

while IFS= read -r file; do
  if [[ "$file" == generated-skills/* ]]; then
    skill_name=$(echo "$file" | cut -d'/' -f2)
    if git show HEAD:"$file" &>/dev/null; then
      UPDATED_SKILLS+=("$skill_name")
    else
      NEW_SKILLS+=("$skill_name")
    fi
  fi
done <<< "$CHANGES"

# Deduplicate
mapfile -t NEW_SKILLS < <(printf '%s\n' "${NEW_SKILLS[@]}" | sort -u)
mapfile -t UPDATED_SKILLS < <(printf '%s\n' "${UPDATED_SKILLS[@]}" | sort -u)

if [ ${#NEW_SKILLS[@]} -gt 0 ]; then
  echo "  Uudet taidot (${#NEW_SKILLS[@]} kpl):"
  for s in "${NEW_SKILLS[@]}"; do echo "    + $s"; done
  echo ""
fi

if [ ${#UPDATED_SKILLS[@]} -gt 0 ]; then
  echo "  Päivitetyt taidot (${#UPDATED_SKILLS[@]} kpl):"
  for s in "${UPDATED_SKILLS[@]}"; do echo "    ~ $s"; done
  echo ""
fi

# Confirm
read -r -p "Asennetaanko muutokset? (k/e): " CONFIRM
echo ""

if [[ "$CONFIRM" != "k" && "$CONFIRM" != "K" ]]; then
  echo "Peruttu. Ei muutoksia asennettu."
  echo ""
  exit 0
fi

# Pull and install
git pull origin main --quiet

cp -r "$TAITOMAATTI_DIR/generated-skills/". "$CLAUDE_SKILLS_DIR/"

echo "Asennettu!"
echo ""
echo "Muista käynnistää Claude uudelleen jotta uudet taidot latautuvat."
echo ""
