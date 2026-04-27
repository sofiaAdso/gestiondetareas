@echo off
setlocal enabledelayedexpansion

REM Establecer JAVA_HOME
set JAVA_HOME=C:\Users\sofsh\.jdks\ms-17.0.18

REM Establecer CATALINA_HOME (ruta correcta del proyecto)
set CATALINA_HOME=C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas\apache-tomcat-9.0.115

REM Establecer CATALINA_BASE
set CATALINA_BASE=%CATALINA_HOME%

REM Ir al directorio de Tomcat
cd /d "%CATALINA_HOME%\bin"

echo ========================================
echo Iniciando Apache Tomcat 9.0.115
echo JAVA_HOME: %JAVA_HOME%
echo CATALINA_HOME: %CATALINA_HOME%
echo CATALINA_BASE: %CATALINA_BASE%
echo ========================================
echo.

REM Ejecutar Tomcat
call catalina.bat run

pause

