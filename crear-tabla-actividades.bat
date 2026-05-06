@echo off
REM =========================================
REM Script para crear la tabla de ACTIVIDADES
REM en PostgreSQL
REM =========================================

echo.
echo ========================================
echo  CREADOR DE TABLA - ACTIVIDADES
echo ========================================
echo.

REM Configuración de conexión
set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=Gestiondetareas
set PGUSER=postgres
set PGPASSWORD=Mia1924.

REM Ruta del archivo SQL (ajusta según sea necesario)
set SQL_FILE=%~dp0src\main\resources\sql\crear-actividades.sql

echo.
echo Datos de conexión:
echo - Host: %PGHOST%
echo - Puerto: %PGPORT%
echo - Base de datos: %PGDATABASE%
echo - Usuario: %PGUSER%
echo.

REM Verificar que el archivo SQL existe
if not exist "%SQL_FILE%" (
    echo ERROR: El archivo SQL no existe en:
    echo %SQL_FILE%
    echo.
    pause
    exit /b 1
)

echo Ejecutando script SQL...
echo.

REM Ejecutar psql con el script SQL
psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -f "%SQL_FILE%"

if errorlevel 1 (
    echo.
    echo ERROR: Ocurrió un problema ejecutando el script SQL.
    echo Por favor verifica:
    echo 1. Que PostgreSQL esté instalado y en el PATH
    echo 2. Que los datos de conexión sean correctos
    echo 3. Que el archivo SQL exista
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo ========================================
    echo  TABLA CREADA EXITOSAMENTE
    echo ========================================
    echo.
    echo La tabla 'actividades' ha sido creada con éxito.
    echo Puedes verificarla en pgAdmin o con:
    echo   psql -U postgres -d Gestiondetareas
    echo   \dt actividades
    echo.
    pause
)

