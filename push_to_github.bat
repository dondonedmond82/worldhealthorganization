@echo off
title Push World Health Organization Project to GitHub
color 0A

echo ============================================
echo     PUSH TO GITHUB - WHO PROJECT
echo ============================================
echo.

REM Change to your project directory
cd /d "C:\Users\DONDON\Documents\notebook\worldhealthorganization\jupyter"

REM Verify Git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Git is not installed or not in your PATH.
    pause
    exit /b
)

echo Current Project:
echo %CD%
echo.

REM Check if this is a Git repository
if not exist ".git" (
    echo ERROR: This folder is not a Git repository.
    pause
    exit /b
)

REM Display repository status
echo Checking repository status...
git status

echo.
set /p COMMIT_MSG=Enter commit message: 

echo.
echo Adding all files...
git add .

echo.
echo Creating commit...
git commit -m "%COMMIT_MSG%"

echo.
echo Pushing to GitHub...
git push origin main

if errorlevel 1 (
    echo.
    echo Push failed.
    echo.
    echo If your branch is 'master' instead of 'main', run:
    echo git push origin master
)

echo.
echo ============================================
echo         DONE!
echo ============================================
pause