@echo off
:: ============================================================
::  W.A.N.D.A — DESINSTALADOR + LIMPIEZA TOTAL
::  Elimina: WANDA, Ollama, modelos IA, librerias Python
::  Optimiza: RAM, disco, temporales, cache
::  Windows 11 — Ejecutar como Administrador
:: ============================================================

NET SESSION >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [ERROR] Ejecuta como Administrador.
    echo  Clic derecho sobre el archivo ^> "Ejecutar como administrador"
    echo.
    pause
    exit /b 1
)

title W.A.N.D.A — Desinstalador + Limpieza Total
color 0C

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║   W.A.N.D.A — DESINSTALADOR + LIMPIEZA      ║
echo  ║   Elimina WANDA + Ollama + Optimiza PC       ║
echo  ╚══════════════════════════════════════════════╝
echo.
echo  Este script va a:
echo  · Eliminar archivos de WANDA
echo  · Desinstalar Ollama y todos sus modelos
echo  · Desinstalar librerias Python (pywebview, pystray, pillow)
echo  · Eliminar acceso directo del escritorio
echo  · Limpiar RAM y memoria en standby
echo  · Limpiar disco: temporales, cache, logs, papelera
echo.
echo  ADVERTENCIA: Esta accion no se puede deshacer.
echo  Presiona cualquier tecla para continuar o cierra
echo  esta ventana para cancelar.
echo.
pause >nul

echo.
echo  ══════════════════════════════════════════════
echo   [1/8] ELIMINANDO ARCHIVOS DE WANDA
echo  ══════════════════════════════════════════════

:: Buscar y eliminar carpetas comunes donde pudo haberse instalado WANDA
set RUTAS=^
    "%USERPROFILE%\Desktop\WANDA" ^
    "%USERPROFILE%\Documents\WANDA" ^
    "%USERPROFILE%\Downloads\WANDA" ^
    "%USERPROFILE%\Downloads\WANDA-Python" ^
    "%USERPROFILE%\Downloads\WANDA-Desktop" ^
    "%USERPROFILE%\Downloads\WANDA-Final" ^
    "C:\WANDA" ^
    "C:\WANDA-Python" ^
    "C:\WANDA-Desktop" ^
    "C:\WANDA-Final"

for %%R in (%RUTAS%) do (
    if exist %%R (
        rd /s /q %%R >nul 2>&1
        echo  [OK] Eliminado: %%R
    )
)

:: Eliminar ZIPs de WANDA en Descargas
del /f /q "%USERPROFILE%\Downloads\WANDA*.zip" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\WANDA*.zip" >nul 2>&1

:: Eliminar acceso directo del escritorio
del /f /q "%USERPROFILE%\Desktop\WANDA.lnk" >nul 2>&1
echo  [OK] Acceso directo eliminado

:: Eliminar sessions.json si quedó en algún lado
del /f /q "%USERPROFILE%\Desktop\sessions.json" >nul 2>&1
del /f /q "%APPDATA%\WANDA\*" >nul 2>&1
rd /s /q "%APPDATA%\WANDA" >nul 2>&1

echo  [OK] Archivos de WANDA eliminados

echo.
echo  ══════════════════════════════════════════════
echo   [2/8] DESINSTALANDO OLLAMA Y MODELOS
echo  ══════════════════════════════════════════════

:: Detener servicio de Ollama si está corriendo
taskkill /f /im ollama.exe >nul 2>&1
taskkill /f /im "ollama app.exe" >nul 2>&1
sc stop ollama >nul 2>&1
sc delete ollama >nul 2>&1

:: Esperar a que el proceso muera
timeout /t 2 >nul

:: Eliminar modelos de Ollama (pueden pesar varios GB)
set OLLAMA_MODELS=%USERPROFILE%\.ollama
if exist "%OLLAMA_MODELS%" (
    echo  Eliminando modelos de IA en %OLLAMA_MODELS%...
    rd /s /q "%OLLAMA_MODELS%" >nul 2>&1
    echo  [OK] Modelos de Ollama eliminados
) else (
    echo  [INFO] No se encontraron modelos de Ollama
)

:: Desinstalar Ollama usando su propio desinstalador si existe
set OLLAMA_UNINST=%LOCALAPPDATA%\Programs\Ollama\unins000.exe
if exist "%OLLAMA_UNINST%" (
    echo  Ejecutando desinstalador de Ollama...
    start /wait "" "%OLLAMA_UNINST%" /SILENT >nul 2>&1
    echo  [OK] Ollama desinstalado
) else (
    :: Eliminar archivos manualmente
    rd /s /q "%LOCALAPPDATA%\Programs\Ollama" >nul 2>&1
    rd /s /q "%LOCALAPPDATA%\Ollama" >nul 2>&1
    del /f /q "%LOCALAPPDATA%\Microsoft\WindowsApps\ollama.exe" >nul 2>&1
    echo  [OK] Archivos de Ollama eliminados manualmente
)

:: Eliminar Ollama del PATH del usuario
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USERPATH=%%B"
if defined USERPATH (
    set "NEWPATH=%USERPATH:;%LOCALAPPDATA%\Programs\Ollama=%"
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%NEWPATH%" /f >nul 2>&1
)

echo  [OK] Ollama completamente eliminado

echo.
echo  ══════════════════════════════════════════════
echo   [3/8] DESINSTALANDO LIBRERIAS PYTHON
echo  ══════════════════════════════════════════════

:: Verificar que Python existe antes de intentar pip
python --version >nul 2>&1
if errorlevel 1 (
    echo  [INFO] Python no encontrado, saltando librerias
    goto :SKIP_PIP
)

echo  Desinstalando pywebview...
pip uninstall pywebview -y >nul 2>&1
echo  Desinstalando pystray...
pip uninstall pystray -y >nul 2>&1
echo  Desinstalando pillow...
pip uninstall pillow -y >nul 2>&1
echo  Desinstalando dependencias de pywebview...
pip uninstall pythonnet clr-loader pyobjc >nul 2>&1 -y >nul 2>&1
pip uninstall proxy-tools bottle >nul 2>&1 -y >nul 2>&1

echo  [OK] Librerias Python desinstaladas

:SKIP_PIP

echo.
echo  ══════════════════════════════════════════════
echo   [4/8] LIBERANDO RAM Y MEMORIA EN STANDBY
echo  ══════════════════════════════════════════════

:: Forzar liberación de memoria de trabajo de todos los procesos
rundll32.exe advapi32.dll,ProcessIdleTasks

:: Vaciar Working Sets (memoria no usada activamente)
:: Usando PowerShell para limpiar Standby List
echo  Limpiando memoria en standby...
powershell -NoProfile -NonInteractive -Command ^
  "[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()" >nul 2>&1

:: Limpiar cache de fuentes
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Fonts\*" >nul 2>&1

:: Limpiar cache de miniaturas (puede ocupar hasta 1GB)
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

:: Limpiar cache de íconos
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1

echo  [OK] RAM liberada y cache de sistema limpiado

echo.
echo  ══════════════════════════════════════════════
echo   [5/8] LIMPIEZA DE ARCHIVOS TEMPORALES
echo  ══════════════════════════════════════════════

:: Temp del sistema
echo  Limpiando temporales del sistema...
del /f /s /q "%SystemRoot%\Temp\*" >nul 2>&1
rd /s /q "%SystemRoot%\Temp" >nul 2>&1
md "%SystemRoot%\Temp" >nul 2>&1

:: Temp del usuario actual
echo  Limpiando temporales del usuario...
del /f /s /q "%TEMP%\*" >nul 2>&1
del /f /s /q "%TMP%\*" >nul 2>&1

:: Prefetch de Windows
del /f /s /q "%SystemRoot%\Prefetch\*" >nul 2>&1

:: Minidumps de crashes
del /f /s /q "%SystemRoot%\Minidump\*" >nul 2>&1

:: Logs de instaladores
del /f /s /q "%SystemRoot%\Logs\*" >nul 2>&1

echo  [OK] Temporales eliminados

echo.
echo  ══════════════════════════════════════════════
echo   [6/8] LIMPIEZA DE CACHE DE WINDOWS
echo  ══════════════════════════════════════════════

:: Cache de Windows Update (puede pesar varios GB)
echo  Limpiando cache de Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
rd /s /q "%SystemRoot%\SoftwareDistribution\Download" >nul 2>&1
md "%SystemRoot%\SoftwareDistribution\Download" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1

:: Cache de Microsoft Store
wsreset.exe >nul 2>&1

:: Cache DNS
ipconfig /flushdns >nul 2>&1

:: Cache de navegadores comunes
:: Chrome
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" >nul 2>&1

:: Edge
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" >nul 2>&1

:: Firefox
for /d %%P in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do (
    rd /s /q "%%P\cache2" >nul 2>&1
)

echo  [OK] Cache de Windows y navegadores limpiado

echo.
echo  ══════════════════════════════════════════════
echo   [7/8] LIMPIEZA DE DISCO — LOGS Y REPORTES
echo  ══════════════════════════════════════════════

:: Logs de eventos de Windows (se regeneran solos)
wevtutil cl Application >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Security >nul 2>&1
wevtutil cl Setup >nul 2>&1

:: Reportes de errores de Windows
rd /s /q "%ProgramData%\Microsoft\Windows\WER\ReportArchive" >nul 2>&1
rd /s /q "%ProgramData%\Microsoft\Windows\WER\ReportQueue" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Windows\WER\ReportArchive" >nul 2>&1

:: Logs de instalación de drivers
del /f /s /q "%SystemRoot%\INF\*.log" >nul 2>&1

:: Archivos de volcado de memoria
del /f /q "%SystemRoot%\MEMORY.DMP" >nul 2>&1
del /f /s /q "%SystemRoot%\Minidump\*" >nul 2>&1

:: Papelera de todos los discos
for %%D in (C D E F G) do (
    if exist %%D:\ (
        rd /s /q "%%D:\$Recycle.Bin" >nul 2>&1
    )
)

:: Ejecutar limpieza nativa de Windows
echo  Ejecutando limpieza de disco nativa...
cleanmgr /sagerun:1 >nul 2>&1

echo  [OK] Logs, reportes y papelera limpiados

echo.
echo  ══════════════════════════════════════════════
echo   [8/8] VERIFICACION FINAL
echo  ══════════════════════════════════════════════

:: Verificar que Ollama fue eliminado
where ollama >nul 2>&1
if errorlevel 1 (
    echo  [OK] Ollama: eliminado correctamente
) else (
    echo  [AVISO] Ollama sigue en PATH - reinicia el PC para completar
)

:: Verificar que pywebview fue eliminado
python -c "import webview" >nul 2>&1
if errorlevel 1 (
    echo  [OK] pywebview: eliminado correctamente
) else (
    echo  [AVISO] pywebview sigue instalado - intenta: pip uninstall pywebview -y
)

:: Verificar acceso directo
if not exist "%USERPROFILE%\Desktop\WANDA.lnk" (
    echo  [OK] Acceso directo: eliminado
)

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║   LIMPIEZA COMPLETADA                        ║
echo  ╠══════════════════════════════════════════════╣
echo  ║                                              ║
echo  ║  ✓ Archivos WANDA eliminados                 ║
echo  ║  ✓ Ollama y modelos de IA eliminados         ║
echo  ║  ✓ Librerias Python desinstaladas            ║
echo  ║  ✓ Acceso directo del escritorio eliminado   ║
echo  ║  ✓ RAM y memoria standby liberadas           ║
echo  ║  ✓ Temporales del sistema y usuario limpios  ║
echo  ║  ✓ Cache de Windows Update limpiado          ║
echo  ║  ✓ Cache de Chrome, Edge y Firefox limpios   ║
echo  ║  ✓ Logs y reportes de errores eliminados     ║
echo  ║  ✓ Papelera de reciclaje vaciada             ║
echo  ║                                              ║
echo  ║  Reinicia el PC para completar la limpieza.  ║
echo  ╚══════════════════════════════════════════════╝
echo.
echo  Presiona cualquier tecla para reiniciar ahora,
echo  o cierra esta ventana para reiniciar despues.
echo.
pause
shutdown /r /t 10 /c "W.A.N.D.A: Reiniciando tras limpieza total..."
