@echo off
chcp 65001 >nul
color 0A
echo ========================================
echo   DESPLIEGUE AUTOMÁTICO - SENA
echo   Sistema de Gestión de Tareas
echo ========================================
echo.

:: Compilar el proyecto
echo [1/3] 📦 Compilando proyecto con Maven...
call mvnw.cmd clean package -DskipTests
if %errorlevel% neq 0 (
    echo ❌ ERROR: Falló la compilación
    pause
    exit /b 1
)
echo ✅ Compilación exitosa
echo.

:: Verificar que existe el archivo WAR
if not exist "target\SistemaGestionTareas.war" (
    echo ❌ ERROR: No se generó el archivo WAR
    pause
    exit /b 1
)
echo ✅ Archivo WAR encontrado
echo.

:: Buscar Tomcat en ubicaciones comunes
echo [2/3] 🔍 Buscando instalación de Tomcat...

set TOMCAT_PATH=
set SEARCH_PATHS=C:\apache-tomcat-9.0.84 C:\Program Files\Apache Software Foundation\Tomcat 9.0 %USERPROFILE%\Desktop\apache-tomcat-9.0.84 C:\tomcat C:\apache-tomcat

for %%P in (%SEARCH_PATHS%) do (
    if exist "%%P\webapps" (
        set TOMCAT_PATH=%%P
        goto :found
    )
)

echo.
echo ⚠️  NO SE ENCONTRÓ TOMCAT INSTALADO
echo.
echo 📋 OPCIONES:
echo    1. Usa IntelliJ IDEA con Smart Tomcat (recomendado para desarrollo)
echo    2. Descarga Tomcat desde: https://tomcat.apache.org/download-90.cgi
echo    3. Extrae Tomcat y vuelve a ejecutar este script
echo.
echo 💡 Para IntelliJ IDEA:
echo    - Click derecho en el proyecto ^> Add Framework Support ^> Tomcat
echo    - O usa Run ^> Edit Configurations ^> + ^> Smart Tomcat
echo.
pause
exit /b 1

:found
echo ✅ Tomcat encontrado en: %TOMCAT_PATH%
echo.

:: Copiar el WAR
echo [3/3] 🚀 Desplegando aplicación...
copy /Y "target\SistemaGestionTareas.war" "%TOMCAT_PATH%\webapps\"
if %errorlevel% neq 0 (
    echo ❌ ERROR: No se pudo copiar el archivo
    pause
    exit /b 1
)

echo ✅ Aplicación desplegada exitosamente
echo.
echo ========================================
echo   ✨ DESPLIEGUE COMPLETADO
echo ========================================
echo.
echo 📍 Ubicación: %TOMCAT_PATH%\webapps\
echo 🌐 URL: http://localhost:8080/SistemaGestionTareas
echo.
echo 💡 Inicia Tomcat con:
echo    %TOMCAT_PATH%\bin\startup.bat
echo.
pause

