@echo off
REM ============================================================
REM push_to_github.bat
REM
REM Pushes this project folder to:
REM   https://github.com/dondonedmond82/worldhealthorganization.git
REM
REM USAGE:
REM   1. Place this script in the ROOT of your project folder
REM      (the folder containing health_analysis.ipynb, data\, README.md,
REM      requirements.txt, etc.)
REM   2. Double-click it, or run from Command Prompt / PowerShell:
REM        push_to_github.bat
REM      Optionally pass a custom commit message:
REM        push_to_github.bat "My commit message"
REM   3. When prompted, authenticate with GitHub:
REM        - Username: your GitHub username
REM        - Password: a GitHub Personal Access Token (PAT), NOT your account
REM          password (create one at https://github.com/settings/tokens
REM          with "repo" scope)
REM      Alternatively, run `gh auth login` once beforehand (GitHub CLI) and
REM      Git will reuse those credentials automatically.
REM
REM REQUIREMENTS: Git for Windows must be installed and on PATH.
REM   https://git-scm.com/download/win
REM
REM NOTE: The GitHub repository (worldhealthorganization) must already
REM   exist under your account before running this script. Create it at
REM   https://github.com/new if you haven't already (leave it empty -
REM   no README/.gitignore/license - to avoid merge conflicts).
REM ============================================================

setlocal enabledelayedexpansion

set "REPO_URL=https://github.com/dondonedmond82/worldhealthorganization.git"
set "BRANCH=main"

set "COMMIT_MSG=%~1"
if "%COMMIT_MSG%"=="" set "COMMIT_MSG=Add health campaign analysis notebook and data"

echo ============================================================
echo  Pushing project to %REPO_URL%
echo ============================================================

REM --- Check that git is installed ---
where git >nul 2>nul
if errorlevel 1 (
    echo ERROR: Git is not installed or not on PATH.
    echo Download it from https://git-scm.com/download/win
    exit /b 1
)

REM --- 0. Make sure we're running from the project folder ---
echo Current folder: %cd%
echo (This should be your project root - press Ctrl+C now if it is not.)
echo.

REM --- 1. Initialize git repo if not already one ---
if not exist ".git" (
    echo Initializing new git repository...
    git init
    git branch -M %BRANCH%
) else (
    echo Existing git repository found.
)

REM --- 2. Add or fix the remote ---
git remote get-url origin >nul 2>nul
if errorlevel 1 (
    echo Adding remote 'origin' -^> %REPO_URL%
    git remote add origin %REPO_URL%
) else (
    echo Remote 'origin' already configured. Verifying URL...
    git remote set-url origin %REPO_URL%
)

REM --- 3. Create a .gitignore if one doesn't exist ---
if not exist ".gitignore" (
    (
        echo # Jupyter
        echo .ipynb_checkpoints/
        echo.
        echo # Python
        echo __pycache__/
        echo *.pyc
        echo .venv/
        echo venv/
        echo.
        echo # OS
        echo Thumbs.db
        echo desktop.ini
    ) > .gitignore
    echo Created .gitignore
)

REM --- 4. Stage and commit ---
git add -A

git diff --cached --quiet
if errorlevel 1 (
    echo Committing changes...
    git commit -m "%COMMIT_MSG%"
) else (
    echo Nothing to commit - working tree already matches last commit.
)

REM --- 5. Pull any existing remote history first (avoids push rejection) ---
echo Checking remote for existing history...
git ls-remote --exit-code %REPO_URL% >nul 2>nul
if not errorlevel 1 (
    echo Pulling existing remote history...
    git pull origin %BRANCH% --allow-unrelated-histories --no-edit
)

REM --- 6. Push ---
echo Pushing to %REPO_URL% (%BRANCH%)...
git push -u origin %BRANCH%

if errorlevel 1 (
    echo.
    echo ERROR: Push failed. Common causes:
    echo   - Repository does not exist yet on GitHub ^(create it first^)
    echo   - Authentication failed ^(use a Personal Access Token, not password^)
    echo   - Branch protection rules on 'main'
    exit /b 1
)

echo.
echo ============================================================
echo  Done. View your repo at:
echo  https://github.com/dondonedmond82/worldhealthorganization
echo ============================================================

endlocal