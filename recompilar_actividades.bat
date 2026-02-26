@echo off
echo ====================================
echo RECOMPILANDO PROYECTO CON LOGS DEBUG
echo ====================================
echo.

REM Limpiar compilaciones antiguas
echo [1/4] Limpiando directorio target...
if exist target\classes\com\sena\gestion\controller\ActividadServlet.class (
    del /Q target\classes\com\sena\gestion\controller\ActividadServlet.class
    echo   - ActividadServlet.class eliminado
)
if exist target\classes\com\sena\gestion\repository\ActividadDao.class (
    del /Q target\classes\com\sena\gestion\repository\ActividadDao.class
    echo   - ActividadDao.class eliminado
)

echo.
echo [2/4] Copiando archivos JSP actualizados...
xcopy /Y src\main\webapp\listar-actividades.jsp target\SistemaGestionTareas\ 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   - listar-actividades.jsp copiado
) else (
    echo   - Advertencia: No se pudo copiar JSP automaticamente
    echo   - Asegurate de desplegar desde el IDE
)

echo.
echo [3/4] INSTRUCCIONES DE RECOMPILACION:
echo.
echo   Para IntelliJ IDEA:
echo   1. Click derecho en el proyecto
echo   2. Build Module 'SistemaGestionTareas'
echo   3. O presiona Ctrl+F9
echo.
echo   Para Eclipse:
echo   1. Click derecho en el proyecto
echo   2. Build Project
echo   3. O presiona Ctrl+B
echo.
echo   Para NetBeans:
echo   1. Click derecho en el proyecto
echo   2. Clean and Build
echo   3. O presiona Shift+F11
echo.

pause
echo.
echo [4/4] Verificando compilacion...
if exist target\classes\com\sena\gestion\controller\ActividadServlet.class (
    echo   [OK] ActividadServlet.class encontrado
) else (
    echo   [ERROR] ActividadServlet.class NO encontrado
    echo   Por favor compila desde el IDE antes de continuar
)

if exist target\classes\com\sena\gestion\repository\ActividadDao.class (
    echo   [OK] ActividadDao.class encontrado
) else (
    echo   [ERROR] ActividadDao.class NO encontrado
    echo   Por favor compila desde el IDE antes de continuar
)

echo.
echo ====================================
echo SIGUIENTE PASO:
echo ====================================
echo 1. Reinicia tu servidor (Tomcat/WildFly)
echo 2. Accede a: http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar
echo 3. Revisa los logs del servidor en consola
echo.
echo LOGS A BUSCAR:
echo - "=== PROCESANDO LISTADO DE ACTIVIDADES ==="
echo - "Usuario: [nombre]"
echo - "Total de actividades encontradas: [numero]"
echo.
pause

