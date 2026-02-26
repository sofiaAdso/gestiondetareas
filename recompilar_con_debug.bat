@echo off
echo ============================================
echo   RECOMPILANDO Y DESPLEGANDO LA APLICACION
echo ============================================
echo.

cd /d "%~dp0"

echo [1/3] Limpiando y compilando con Maven...
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: La compilacion fallo
    pause
    exit /b 1
)

echo.
echo [2/3] Compilacion exitosa!
echo.

set TOMCAT_WEBAPPS=C:\apache-tomcat-9.0.XX\webapps
echo NOTA: Verifica la ruta de Tomcat en este script
echo       Ruta actual configurada: %TOMCAT_WEBAPPS%
echo.
echo Para copiar el WAR manualmente:
echo   1. Detener Tomcat
echo   2. Eliminar: %TOMCAT_WEBAPPS%\SistemaGestionTareas
echo   3. Copiar: target\SistemaGestionTareas.war a %TOMCAT_WEBAPPS%\
echo   4. Iniciar Tomcat
echo.

echo [3/3] El archivo WAR esta listo en: target\SistemaGestionTareas.war
echo.

echo ============================================
echo   COMPILACION COMPLETADA
echo ============================================
echo.
echo Ahora puedes:
echo  1. Copiar el WAR a Tomcat y reiniciar
echo  2. Acceder a: http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=test
echo     (Esta es la pagina de diagnostico simplificada)
echo  3. Revisar los logs de Tomcat para ver los mensajes de depuracion
echo.
pause

