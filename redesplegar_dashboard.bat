@echo off
echo ========================================
echo REDESPLIEGUE DEL DASHBOARD ACTUALIZADO
echo ========================================
echo.

REM Detectar Tomcat
set TOMCAT_PATH=
if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps" (
    set TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat 9.0
) else if exist "C:\apache-tomcat-9.0\webapps" (
    set TOMCAT_PATH=C:\apache-tomcat-9.0
) else if exist "C:\tomcat\webapps" (
    set TOMCAT_PATH=C:\tomcat
) else if exist "C:\apache-tomcat\webapps" (
    set TOMCAT_PATH=C:\apache-tomcat
)

if "%TOMCAT_PATH%"=="" (
    echo [ERROR] No se encontro Tomcat instalado
    echo Por favor, especifica la ruta manualmente editando este archivo
    pause
    exit /b 1
)

echo [INFO] Tomcat encontrado en: %TOMCAT_PATH%
echo.

REM Detener Tomcat (opcional, comentado por defecto)
REM echo [1] Deteniendo Tomcat...
REM call "%TOMCAT_PATH%\bin\shutdown.bat"
REM timeout /t 5 /nobreak > nul

echo [1] Eliminando aplicacion antigua...
if exist "%TOMCAT_PATH%\webapps\SistemaGestionTareas.war" (
    del /F /Q "%TOMCAT_PATH%\webapps\SistemaGestionTareas.war"
    echo     - WAR eliminado
)
if exist "%TOMCAT_PATH%\webapps\SistemaGestionTareas" (
    rmdir /S /Q "%TOMCAT_PATH%\webapps\SistemaGestionTareas"
    echo     - Carpeta eliminada
)
echo.

echo [2] Copiando nuevo WAR...
copy /Y "target\SistemaGestionTareas.war" "%TOMCAT_PATH%\webapps\"
if %ERRORLEVEL% EQU 0 (
    echo     - WAR copiado exitosamente
) else (
    echo     [ERROR] No se pudo copiar el WAR
    pause
    exit /b 1
)
echo.

echo [3] Limpiando cache de trabajo de Tomcat...
if exist "%TOMCAT_PATH%\work\Catalina\localhost\SistemaGestionTareas" (
    rmdir /S /Q "%TOMCAT_PATH%\work\Catalina\localhost\SistemaGestionTareas"
    echo     - Cache limpiado
)
echo.

REM Iniciar Tomcat (opcional, comentado por defecto)
REM echo [4] Iniciando Tomcat...
REM call "%TOMCAT_PATH%\bin\startup.bat"

echo ========================================
echo DESPLIEGUE COMPLETADO
echo ========================================
echo.
echo PASOS SIGUIENTES:
echo 1. Si Tomcat esta corriendo, espera 10-15 segundos para que despliegue
echo 2. Si NO esta corriendo, inicia Tomcat manualmente
echo 3. Accede a: http://localhost:8080/SistemaGestionTareas/
echo 4. Limpia cache del navegador (Ctrl + F5)
echo.
echo Si el error persiste, verifica los logs de Tomcat en:
echo %TOMCAT_PATH%\logs\catalina.out
echo.
pause

