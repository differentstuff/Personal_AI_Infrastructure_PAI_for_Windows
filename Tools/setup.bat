@echo off
:: PAI - Personal AI Infrastructure Setup Launcher
:: Double-click to start installation

pwsh.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0Install-PAI.ps1"
pause
