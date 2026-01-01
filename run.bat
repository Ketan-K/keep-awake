@echo off
REM This batch file runs the mouse mover application
REM It automatically changes to the directory where this .bat file is located
REM You can create a shortcut to this file and place it anywhere (desktop, startup folder, etc.)

cd /d "%~dp0"
node index.js
pause
