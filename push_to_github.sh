#!/usr/bin/env bash
#
# push_to_github.sh
#
# Pushes this project folder to:
#   https://github.com/dondonedmond82/worldhealthorganization.git
#
# USAGE:
#   1. Place this script in the root of your project folder
#      (alongside health_analysis.ipynb, data/, README.md, requirements.txt).
#   2. Run:  bash push_to_github.sh
#   3. When prompted, authenticate with GitHub:
#        - Username: your GitHub username
#        - Password: a GitHub Personal Access Token (PAT), NOT your account password
#          (create one at https://github.com/settings/tokens with "repo" scope)
#      Alternatively, set up SSH access or the GitHub CLI (`gh auth login`)
#      beforehand and this script will use your existing credentials.
#
set -euo pipefail

REPO_URL="https://github.com/dondonedmond82/worldhealthorganization.git"
BRANCH="main"
COMMIT_MSG="${1:-Add health campaign analysis notebook and data}"

echo "== Pushing project to $REPO_URL =="

# 1. Initialize git repo if not already one
if [ ! -d ".git" ]; then
    echo "Initializing new git repository..."
    git init
    git branch -M "$BRANCH"
fi

# 2. Add the remote if it doesn't already exist
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "Adding remote 'origin' -> $REPO_URL"
    git remote add origin "$REPO_URL"
else
    echo "Remote 'origin' already set to: $(git remote get-url origin)"
fi

# 3. Create a .gitignore if one doesn't exist
if [ ! -f ".gitignore" ]; then
    cat > .gitignore <<'EOF'
# Jupyter
.ipynb_checkpoints/

# Python
__pycache__/
*.pyc
.venv/
venv/

# OS
.DS_Store
EOF
    echo "Created .gitignore"
fi

# 4. Stage, commit, and push
git add .

if git diff --cached --quiet; then
    echo "Nothing to commit — working tree already matches last commit."
else
    git commit -m "$COMMIT_MSG"
fi

# 5. Pull any existing remote history first (in case the repo isn't empty)
echo "Fetching from remote (if it already has commits)..."
if git ls-remote --exit-code "$REPO_URL" >/dev/null 2>&1; then
    git pull origin "$BRANCH" --allow-unrelated-histories --no-edit || true
fi

echo "Pushing to $REPO_URL ($BRANCH)..."
git push -u origin "$BRANCH"

echo "== Done. View your repo at: https://github.com/dondonedmond82/worldhealthorganization =="
