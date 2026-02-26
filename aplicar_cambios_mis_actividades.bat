@echo off
chcp 65001 > nul
echo.
echo ═══════════════════════════════════════════════════════════
echo   APLICAR CAMBIOS - Mis Actividades
echo ═══════════════════════════════════════════════════════════
echo.
echo Este script aplicará los cambios realizados:
echo   ✓ Botón Nueva Actividad eliminado
echo   ✓ Botón Inicio mejorado
echo   ✓ Botón Editar reemplazado por Cambiar Estado
echo.
echo ═══════════════════════════════════════════════════════════
echo.

REM Ruta de Tomcat (ajusta según tu instalación)
set TOMCAT_WEBAPPS=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\SistemaGestionTareas

REM Verificar si existe el directorio de Tomcat
if not exist "%TOMCAT_WEBAPPS%" (
    echo ⚠️  No se encontró el directorio de Tomcat en:
    echo    %TOMCAT_WEBAPPS%
    echo.
    echo Por favor, edita este script y ajusta la ruta TOMCAT_WEBAPPS
    echo o compila desde IntelliJ IDEA:
    echo    1. Build ^> Rebuild Project
    echo    2. Build ^> Build Artifacts ^> Rebuild
    echo    3. Redeploy en Tomcat
    echo.
    pause
    exit /b 1
)

echo [1/2] Copiando mis-actividades.jsp actualizado...
copy /Y "src\main\webapp\mis-actividades.jsp" "%TOMCAT_WEBAPPS%\mis-actividades.jsp" > nul
if %errorlevel% equ 0 (
    echo ✓ mis-actividades.jsp copiado correctamente
) else (
    echo ✗ Error al copiar mis-actividades.jsp
    pause
    exit /b 1
)

echo.
echo [2/2] Para aplicar los cambios en ActividadServlet.java:
echo    Necesitas recompilar el proyecto desde IntelliJ IDEA:
echo    1. Build ^> Rebuild Project
echo    2. Redeploy en Tomcat
echo.
echo ═══════════════════════════════════════════════════════════
echo   ✓ CAMBIOS APLICADOS
echo ═══════════════════════════════════════════════════════════
echo.
echo Los cambios visuales ya están disponibles.
echo Para que funcione el botón "Cambiar Estado", necesitas
echo recompilar el servlet desde IntelliJ.
echo.
pause

