@echo off
REM Script para crear la tabla de subtareas en PostgreSQL
REM Asegurate de tener PostgreSQL instalado y en el PATH

echo ========================================
echo CREANDO TABLA DE SUBTAREAS
echo ========================================
echo.

REM Configuracion de la base de datos
set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=Gestiondetareas
set PGUSER=postgres
set PGPASSWORD=Mia1924.

echo Conectando a la base de datos: %PGDATABASE%
echo.

REM Ejecutar el script SQL
psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -f crear_tabla_subtareas.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo TABLA CREADA EXITOSAMENTE
    echo ========================================
    echo.

    REM Verificar que la tabla existe
    echo Verificando que la tabla existe...
    psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename = 'subtareas';"

    echo.
    echo La tabla 'subtareas' ha sido creada correctamente.
    echo Ahora puedes compilar y desplegar la aplicacion.
) else (
    echo.
    echo ========================================
    echo ERROR AL CREAR LA TABLA
    echo ========================================
    echo.
    echo Verifica:
    echo 1. Que PostgreSQL este instalado y corriendo
    echo 2. Que la base de datos 'Gestiondetareas' exista
    echo 3. Que las credenciales sean correctas
    echo.
)

pause

