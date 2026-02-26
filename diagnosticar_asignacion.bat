@echo off
chcp 65001 >nul
COLOR 0A

echo.
echo ═══════════════════════════════════════════════════════════
echo   DIAGNÓSTICO Y CORRECCIÓN DE ASIGNACIÓN DE ACTIVIDADES
echo ═══════════════════════════════════════════════════════════
echo.

REM Configuración de conexión a PostgreSQL
REM Modifica estos valores según tu configuración

set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=gestion_tareas
set PGUSER=postgres
set PGPASSWORD=tu_password

echo [INFO] Conectando a la base de datos...
echo        Host: %PGHOST%
echo        Puerto: %PGPORT%
echo        Base de datos: %PGDATABASE%
echo        Usuario: %PGUSER%
echo.

:menu
echo ═══════════════════════════════════════════════════════════
echo   MENÚ DE OPCIONES
echo ═══════════════════════════════════════════════════════════
echo.
echo   1. Diagnóstico completo (verificar asignaciones)
echo   2. Corregir actividades sin usuario
echo   3. Resumen por usuario
echo   4. Ver todas las actividades con usuarios
echo   5. Ejecutar script personalizado
echo   6. Salir
echo.
set /p opcion="Selecciona una opción [1-6]: "

if "%opcion%"=="1" goto diagnostico
if "%opcion%"=="2" goto corregir
if "%opcion%"=="3" goto resumen
if "%opcion%"=="4" goto ver_todas
if "%opcion%"=="5" goto personalizado
if "%opcion%"=="6" goto fin
goto menu

:diagnostico
echo.
echo [1/3] Ejecutando diagnóstico completo...
echo ═══════════════════════════════════════════════════════════
psql -h %PGHOST% -p %PGPORT% -d %PGDATABASE% -U %PGUSER% -f verificar_asignacion_actividades.sql
if errorlevel 1 (
    echo.
    echo ✗ Error al ejecutar el diagnóstico
    echo   Verifica que PostgreSQL esté instalado y configurado
    echo   Verifica que las credenciales sean correctas
) else (
    echo.
    echo ✓ Diagnóstico completado
)
echo.
pause
goto menu

:corregir
echo.
echo [2/3] Corrigiendo actividades sin usuario...
echo ═══════════════════════════════════════════════════════════
echo.
echo ⚠️  ADVERTENCIA: Esta operación modificará la base de datos
echo.
set /p confirmar="¿Estás seguro? (S/N): "
if /i not "%confirmar%"=="S" (
    echo Operación cancelada
    pause
    goto menu
)

echo.
echo Ejecutando corrección...
psql -h %PGHOST% -p %PGPORT% -d %PGDATABASE% -U %PGUSER% -c "UPDATE actividades SET usuario_id = (SELECT MIN(id) FROM usuarios) WHERE usuario_id IS NULL; SELECT 'Actividades corregidas: ' || COUNT(*) as resultado FROM actividades WHERE usuario_id IS NOT NULL;"

if errorlevel 1 (
    echo ✗ Error al corregir actividades
) else (
    echo ✓ Corrección completada
)
echo.
pause
goto menu

:resumen
echo.
echo [3/3] Resumen de actividades por usuario...
echo ═══════════════════════════════════════════════════════════
psql -h %PGHOST% -p %PGPORT% -d %PGDATABASE% -U %PGUSER% -c "SELECT u.id, u.username, u.rol, COUNT(a.id) as total_actividades, COUNT(CASE WHEN a.estado = 'Completada' THEN 1 END) as completadas, COUNT(CASE WHEN a.estado = 'En Progreso' THEN 1 END) as en_progreso FROM usuarios u LEFT JOIN actividades a ON u.id = a.usuario_id GROUP BY u.id, u.username, u.rol ORDER BY total_actividades DESC;"

if errorlevel 1 (
    echo ✗ Error al obtener resumen
) else (
    echo ✓ Resumen generado
)
echo.
pause
goto menu

:ver_todas
echo.
echo [4/3] Listado completo de actividades...
echo ═══════════════════════════════════════════════════════════
psql -h %PGHOST% -p %PGPORT% -d %PGDATABASE% -U %PGUSER% -c "SELECT a.id, a.titulo, a.usuario_id, u.username, a.estado, a.fecha_creacion FROM actividades a LEFT JOIN usuarios u ON a.usuario_id = u.id ORDER BY a.fecha_creacion DESC;"

if errorlevel 1 (
    echo ✗ Error al listar actividades
) else (
    echo ✓ Listado completado
)
echo.
pause
goto menu

:personalizado
echo.
echo [5/3] Ejecutar script personalizado...
echo ═══════════════════════════════════════════════════════════
echo.
set /p archivo="Ingresa el nombre del archivo SQL: "
if not exist "%archivo%" (
    echo ✗ El archivo no existe: %archivo%
    pause
    goto menu
)

echo Ejecutando %archivo%...
psql -h %PGHOST% -p %PGPORT% -d %PGDATABASE% -U %PGUSER% -f "%archivo%"

if errorlevel 1 (
    echo ✗ Error al ejecutar el script
) else (
    echo ✓ Script ejecutado correctamente
)
echo.
pause
goto menu

:fin
echo.
echo ═══════════════════════════════════════════════════════════
echo   Saliendo...
echo ═══════════════════════════════════════════════════════════
echo.
exit /b 0

