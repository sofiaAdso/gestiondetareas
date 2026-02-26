@echo off
chcp 65001 > nul
echo.
echo ═══════════════════════════════════════════════════════════
echo   RECOMPILAR Y REDESPLEGAR - Sistema de Gestión de Tareas
echo ═══════════════════════════════════════════════════════════
echo.
echo IMPORTANTE: Este script requiere que IntelliJ IDEA esté configurado
echo            con Maven en el PATH o que uses la terminal de IntelliJ.
echo.
echo ═══════════════════════════════════════════════════════════
echo   OPCIONES DISPONIBLES
echo ═══════════════════════════════════════════════════════════
echo.
echo 1. Recompilar desde IntelliJ IDEA
echo    - Build ^> Rebuild Project
echo    - Build ^> Build Artifacts ^> SistemaGestionTareas:war ^> Rebuild
echo.
echo 2. Copiar archivos actualizados manualmente
echo    (Si no puedes recompilar con Maven)
echo.
echo 3. Verificar/Crear tareas en la base de datos
echo.
echo 4. Ver instrucciones completas
echo.
echo 5. Salir
echo.
echo ═══════════════════════════════════════════════════════════

choice /c 12345 /n /m "Selecciona una opción (1-5): "
set opcion=%errorlevel%

if %opcion%==1 goto intellij
if %opcion%==2 goto copiar
if %opcion%==3 goto database
if %opcion%==4 goto instrucciones
if %opcion%==5 goto fin

:intellij
echo.
echo ═══════════════════════════════════════════════════════════
echo   RECOMPILAR DESDE INTELLIJ
echo ═══════════════════════════════════════════════════════════
echo.
echo Abre IntelliJ IDEA y sigue estos pasos:
echo.
echo 1. Ve a: Build ^> Rebuild Project
echo    (Espera a que termine la compilación)
echo.
echo 2. Ve a: Build ^> Build Artifacts
echo    - Busca: SistemaGestionTareas:war
echo    - Selecciona: Rebuild
echo.
echo 3. Si tienes Tomcat configurado en IntelliJ:
echo    - Ve a: Run ^> Run (Shift+F10)
echo    - O haz clic en el botón verde de Play
echo.
echo 4. Si NO tienes Tomcat configurado:
echo    - Copia: target\SistemaGestionTareas.war
echo    - A: [TOMCAT_HOME]\webapps\
echo    - Reinicia Tomcat
echo.
pause
goto menu

:copiar
echo.
echo ═══════════════════════════════════════════════════════════
echo   COPIAR ARCHIVOS ACTUALIZADOS
echo ═══════════════════════════════════════════════════════════
echo.
echo ADVERTENCIA: Esta opción solo copia el JSP actualizado.
echo            Las clases Java necesitan recompilación.
echo.
echo ¿Deseas continuar? (S/N)
choice /c SN /n /m ""
if %errorlevel%==2 goto menu

echo.
echo Copiando listar-actividades.jsp...
copy /Y "src\main\webapp\listar-actividades.jsp" "target\SistemaGestionTareas\listar-actividades.jsp" > nul
if %errorlevel%==0 (
    echo ✓ Archivo JSP copiado exitosamente
    echo.
    echo AHORA DEBES:
    echo 1. Encontrar donde está desplegada tu aplicación en Tomcat
    echo 2. Copiar el JSP también allí:
    echo    Destino: [TOMCAT]\webapps\SistemaGestionTareas\listar-actividades.jsp
    echo.
    echo 3. Para las clases Java, DEBES recompilar con opción 1
) else (
    echo ✗ Error al copiar archivo
)
echo.
pause
goto menu

:database
echo.
echo ═══════════════════════════════════════════════════════════
echo   VERIFICAR/CREAR TAREAS EN LA BASE DE DATOS
echo ═══════════════════════════════════════════════════════════
echo.
echo Opciones para ejecutar el script SQL:
echo.
echo OPCIÓN A - pgAdmin:
echo 1. Abre pgAdmin
echo 2. Conecta a tu servidor PostgreSQL
echo 3. Abre la base de datos "Gestiondetareas"
echo 4. Abre el archivo: verificar_y_crear_tareas_actividades.sql
echo 5. Ejecuta el script (F5)
echo.
echo OPCIÓN B - Línea de comandos:
echo psql -U postgres -d Gestiondetareas -f verificar_y_crear_tareas_actividades.sql
echo.
echo OPCIÓN C - DBeaver u otro cliente:
echo 1. Conecta a PostgreSQL
echo 2. Abre la base de datos "Gestiondetareas"
echo 3. Abre y ejecuta: verificar_y_crear_tareas_actividades.sql
echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo ¿Intentar ejecutar con psql ahora? (S/N)
choice /c SN /n /m ""
if %errorlevel%==1 (
    echo.
    echo Intentando conectar a PostgreSQL...
    psql -U postgres -d Gestiondetareas -f verificar_y_crear_tareas_actividades.sql
    if %errorlevel%==0 (
        echo.
        echo ✓ Script ejecutado exitosamente
    ) else (
        echo.
        echo ✗ Error al ejecutar script
        echo   Usa pgAdmin o DBeaver en su lugar
    )
)
echo.
pause
goto menu

:instrucciones
echo.
echo ═══════════════════════════════════════════════════════════
echo   INSTRUCCIONES COMPLETAS
echo ═══════════════════════════════════════════════════════════
echo.
echo Abriendo archivo de instrucciones...
start INSTRUCCIONES_RECOMPILAR.md
start RESUMEN_CAMBIOS_TAREAS.md
echo.
echo Se han abierto los archivos de documentación.
echo.
pause
goto menu

:menu
echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo ¿Deseas realizar otra acción? (S/N)
choice /c SN /n /m ""
if %errorlevel%==1 (
    cls
    goto inicio
)
goto fin

:inicio
echo.
echo ═══════════════════════════════════════════════════════════
echo   OPCIONES DISPONIBLES
echo ═══════════════════════════════════════════════════════════
echo.
echo 1. Recompilar desde IntelliJ IDEA
echo 2. Copiar archivos actualizados manualmente
echo 3. Verificar/Crear tareas en la base de datos
echo 4. Ver instrucciones completas
echo 5. Salir
echo.
echo ═══════════════════════════════════════════════════════════

choice /c 12345 /n /m "Selecciona una opción (1-5): "
set opcion=%errorlevel%

if %opcion%==1 goto intellij
if %opcion%==2 goto copiar
if %opcion%==3 goto database
if %opcion%==4 goto instrucciones
if %opcion%==5 goto fin

:fin
echo.
echo ═══════════════════════════════════════════════════════════
echo   CAMBIOS REALIZADOS
echo ═══════════════════════════════════════════════════════════
echo.
echo ✓ Corregido error de compilación en listar-actividades.jsp
echo ✓ Agregada lógica para calcular estadísticas de tareas
echo ✓ Implementado contador de tareas por actividad
echo ✓ Agregado cálculo de porcentaje de completado
echo.
echo RECUERDA:
echo - Recompilar el proyecto (Build ^> Rebuild)
echo - Redesplegar en Tomcat
echo - Verificar que haya tareas en la BD asociadas a actividades
echo.
echo ═══════════════════════════════════════════════════════════
echo.
pause

