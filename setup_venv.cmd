@echo off
setlocal

set "VENV_DIR=.venv"

where py >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set "PY_CMD=py"
) else (
    set "PY_CMD=python"
)

REM Crea il venv se non esiste
if not exist "%VENV_DIR%\Scripts\python.exe" (
    echo Creazione del virtual environment in %VENV_DIR%...
    %PY_CMD% -m venv "%VENV_DIR%"
    if errorlevel 1 (
        echo Errore durante la creazione del venv.
        pause
        exit /b 1
    )
)

REM Attiva il venv
call "%VENV_DIR%\Scripts\activate.bat"

REM Aggiorna pip
python -m pip install --upgrade pip
if errorlevel 1 (
    echo Errore durante l'aggiornamento di pip.
    pause
    exit /b 1
)

REM Installa il pacchetto in modalita' editable con tutti gli extra (com, pdf, office)
python -m pip install -e ".[full]"
if errorlevel 1 (
    echo Errore durante l'installazione dei pacchetti.
    pause
    exit /b 1
)

echo.
echo Ambiente pronto.
echo Venv: %VENV_DIR%

echo Attivazione del virtual environment e avvio di package.cmd...
call "%VENV_DIR%\Scripts\activate.bat"
if errorlevel 1 (
    echo Errore durante l'attivazione del venv.
    pause
    exit /b 1
)

pyinstaller --onefile --name=CADmcp server.py

echo.
pause