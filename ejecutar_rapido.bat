@echo off
chcp 65001 >nul
color 0B
echo ========================================
echo   🚀 EJECUCIÓN RÁPIDA - TOMCAT EMBEBIDO
echo   Sistema de Gestión de Tareas - SENA
echo ========================================
echo.
echo Esta opción ejecuta tu aplicación SIN necesidad
echo de instalar Tomcat externamente.
echo.
echo Perfecto para pruebas y desarrollo rápido.
echo.
pause

echo [1/3] 📥 Descargando dependencias...
call mvnw.cmd dependency:resolve
if %errorlevel% neq 0 (
    echo.
    echo ⚠️  Advertencia: Algunas dependencias no se descargaron
    echo    Continuando de todas formas...
    echo.
)

echo [2/3] 📦 Compilando proyecto...
call mvnw.cmd clean compile
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERROR: Falló la compilación
    pause
    exit /b 1
)
echo ✅ Compilación exitosa
echo.

echo [3/3] 🚀 Iniciando servidor Tomcat embebido...
echo.
echo ═══════════════════════════════════════
echo   La aplicación se está iniciando...
echo ═══════════════════════════════════════
echo.
echo 🌐 URL: http://localhost:8080/SistemaGestionTareas
echo.
echo 💡 NOTA: El servidor se ejecutará en esta ventana.
echo    NO la cierres mientras uses la aplicación.
echo.
echo ⏹️  Para detener el servidor: Presiona Ctrl+C
echo.
echo ───────────────────────────────────────
echo   Iniciando en 3 segundos...
echo ───────────────────────────────────────
timeout /t 3 >nul

call mvnw.cmd tomcat7:run

