









@echo off
echo ============================================================
echo MIGRACION FINAL: Tareas a Actividades
echo ============================================================
echo.
echo Este script ejecutara la migracion que:
echo 1. Renombra la tabla 'tareas' actual a 'actividades'
echo 2. Crea una nueva tabla 'tareas' que depende de actividades
echo 3. Migra las subtareas existentes a la nueva tabla tareas
echo.
echo ADVERTENCIA: Este proceso modificara la estructura de tu base de datos
echo.

set /p CONFIRM="Deseas continuar? (S/N): "
if /i not "%CONFIRM%"=="S" (
    echo Migracion cancelada.
    pause
    exit /b
)

echo.
echo Ejecutando migracion...
echo.

REM Configurar tus credenciales de PostgreSQL
set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=gestion_tareas
set PGUSER=postgres

REM Solicitar contraseña
set /p PGPASSWORD="Ingresa la contraseña de PostgreSQL: "

echo.
echo Creando backup antes de migrar...
pg_dump -U %PGUSER% -h %PGHOST% -p %PGPORT% %PGDATABASE% > backup_antes_migracion_final_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql

if errorlevel 1 (
    echo ERROR: No se pudo crear el backup
    pause
    exit /b 1
)

echo Backup creado exitosamente.
echo.
echo Ejecutando script de migracion...
psql -U %PGUSER% -h %PGHOST% -p %PGPORT% -d %PGDATABASE% -f migracion_final_tareas_a_actividades.sql

if errorlevel 1 (
    echo.
    echo ERROR: Hubo un problema durante la migracion
    echo Revisa el backup creado para restaurar si es necesario
    pause
    exit /b 1
)

echo.
echo ============================================================
echo MIGRACION COMPLETADA EXITOSAMENTE
echo ============================================================
echo.
echo Cambios realizados:
echo - Tabla 'tareas' renombrada a 'actividades'
echo - Nueva tabla 'tareas' creada (depende de actividades)
echo - Subtareas migradas a la nueva tabla tareas
echo.
echo Recuerda compilar y desplegar el proyecto actualizado
echo.
pause

