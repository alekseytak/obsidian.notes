#!/bin/bash
# sync_notes.sh — автоматическая синхронизация Obsidian-заметок с Git

REPO_DIR="/root/.openclaw/workspace/obsidian-notes"
cd "$REPO_DIR" || exit 1

# Получаем изменения
git fetch origin

# Попытка слияния (fast-forward или merge). Если конфликт — прерываем.
git merge origin/main --ff-only || {
  echo "WARNING: Merge conflict or diverged branches. Manual resolution required."
  exit 1
}

# Добавляем локальные изменения
git add .

# Делаем коммит, если есть что коммитить
if ! git diff-index --quiet HEAD --; then
  COMMIT_MSG="Auto-update: $(date '+%Y-%m-%d %H:%M UTC')"
  git commit -m "$COMMIT_MSG"

  # Пушим, если есть origin
  if git remote | grep -q origin; then
    git push origin main
  else
    echo "No remote 'origin' configured. Skipping push."
  fi
fi

exit 0