@echo off
chcp 65001 > nul
echo.
echo ═══════════════════════════════════════════════════════════
echo   COMPILAR Y DESPLEGAR SISTEMA DE GESTIÓN DE TAREAS
echo ═══════════════════════════════════════════════════════════
echo.

echo [1/3] Limpiando proyecto...
call mvn clean
if %errorlevel% neq 0 (
    echo ✗ Error al limpiar el proyecto
    pause
    exit /b 1
)
echo ✓ Proyecto limpiado

echo.
echo [2/3] Compilando proyecto...
call mvn compile
if %errorlevel% neq 0 (
    echo ✗ Error al compilar el proyecto
    pause
    exit /b 1
)
echo ✓ Proyecto compilado

echo.
echo [3/3] Empaquetando WAR...
call mvn package
if %errorlevel% neq 0 (
    echo ✗ Error al empaquetar el proyecto
    pause
    exit /b 1
)
echo ✓ WAR generado exitosamente

echo.
echo ═══════════════════════════════════════════════════════════
echo   ✓ COMPILACIÓN EXITOSA
echo ═══════════════════════════════════════════════════════════
echo.
echo El archivo WAR está en: target\SistemaGestionTareas.war
echo.

:: Intentar desplegar automáticamente
echo [4/4] Intentando desplegar en Tomcat...
set TOMCAT_FOUND=0
set TOMCAT_PATH=

:: Buscar Tomcat en ubicaciones comunes
for %%P in ("C:\apache-tomcat-9.0.84" "C:\Program Files\Apache Software Foundation\Tomcat 9.0" "%USERPROFILE%\Desktop\apache-tomcat-9.0.84" "C:\tomcat" "C:\apache-tomcat") do (
    if exist "%%~P\webapps" (
        set TOMCAT_PATH=%%~P
        set TOMCAT_FOUND=1
        goto :deploy
    )
)

:no_tomcat
echo.
echo ⚠️  NO SE ENCONTRÓ TOMCAT INSTALADO
echo.
echo 📋 OPCIONES:
echo    1. Usa IntelliJ IDEA con Smart Tomcat (recomendado)
echo    2. Instala Tomcat manualmente (ver GUIA_INSTALACION_TOMCAT.md)
echo    3. Ejecuta: mvnw.cmd tomcat7:run (para pruebas rápidas)
echo.
echo 💡 Lee el archivo GUIA_INSTALACION_TOMCAT.md para más detalles
echo.
pause
exit /b 0

:deploy
echo ✓ Tomcat encontrado en: %TOMCAT_PATH%
copy /Y "target\SistemaGestionTareas.war" "%TOMCAT_PATH%\webapps\" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Aplicación desplegada exitosamente
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo   🚀 DESPLIEGUE COMPLETADO
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo 📍 Ubicación: %TOMCAT_PATH%\webapps\
    echo 🌐 URL: http://localhost:8080/SistemaGestionTareas
    echo.
    echo 💡 Inicia Tomcat con:
    echo    %TOMCAT_PATH%\bin\startup.bat
    echo.
) else (
    echo ✗ No se pudo copiar el archivo (puede necesitar permisos de administrador)
    echo.
    echo Copia manualmente:
    echo    copy target\SistemaGestionTareas.war "%TOMCAT_PATH%\webapps\"
    echo.
)
pause

