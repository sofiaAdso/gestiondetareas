@echo off
echo ========================================
echo SOLUCION DE ERRORES DE COMPILACION
echo ========================================
echo.

cd /d "%~dp0"

echo Configurando Java...
set JAVA_HOME=C:\Program Files\Java\jdk-25.0.2
set PATH=%JAVA_HOME%\bin;%PATH%

echo.
echo Limpiando proyecto anterior...
if exist target rmdir /s /q target

echo.
echo Descargando dependencias de Maven...
echo (Esto puede tardar 2-3 minutos la primera vez)
echo.
call mvnw.cmd dependency:resolve -U

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ ERROR: No se pudieron descargar las dependencias
    echo.
    echo Intenta lo siguiente:
    echo 1. Verifica tu conexión a Internet
    echo 2. Ejecuta este comando manualmente:
    echo    mvnw.cmd dependency:resolve -U
    echo.
    pause
    exit /b 1
)

echo.
echo Compilando el proyecto...
call mvnw.cmd clean compile

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ ERROR: La compilación falló
    echo.
    echo Por favor:
    echo 1. Abre IntelliJ IDEA
    echo 2. Presiona Ctrl + Shift + O para recargar Maven
    echo 3. Espera a que descargue las dependencias
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo ✅ COMPILACIÓN EXITOSA
echo ========================================
echo.
echo Las dependencias se descargaron correctamente.
echo.
echo AHORA DEBES:
echo 1. Abrir IntelliJ IDEA
echo 2. Presionar Ctrl + Shift + O (recargar Maven)
echo 3. Esperar a que termine la indexación
echo 4. Los errores rojos desaparecerán
echo.
echo Después puedes ejecutar el proyecto con:
echo - INICIAR_PROYECTO.bat
echo - O desde IntelliJ: Run 'TomcatStarter.main()'
echo.
pause

