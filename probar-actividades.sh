#!/bin/bash
# Script de prueba para verificar la creación de actividades

echo "========================================="
echo "PRUEBA: Sistema de Actividades"
echo "========================================="
echo ""

# Variables
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="Gestiondetareas"
DB_USER="postgres"

echo "1. Verificando conexión a PostgreSQL..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✓ Conexión exitosa"
else
    echo "   ✗ Error: No se pudo conectar a la base de datos"
    exit 1
fi

echo ""
echo "2. Verificando tabla 'actividades'..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\dt actividades" | grep actividades > /dev/null

if [ $? -eq 0 ]; then
    echo "   ✓ Tabla 'actividades' existe"
else
    echo "   ✗ Error: Tabla 'actividades' no existe"
    echo "   → Ejecuta: crear-tabla-actividades.bat"
    exit 1
fi

echo ""
echo "3. Contando registros en 'actividades'..."
COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM actividades;")
echo "   → Registros: $COUNT"

echo ""
echo "4. Estructura de la tabla 'actividades'..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\d actividades"

echo ""
echo "========================================="
echo "PRUEBA COMPLETADA"
echo "========================================="
echo ""
echo "Próximos pasos:"
echo "1. Compila el proyecto: mvn clean package"
echo "2. Inicia Tomcat: ./start-tomcat.bat"
echo "3. Accede a: http://localhost:8080/SistemaGestionTareas/"
echo "4. Inicia sesión y ve a: ActividadServlet?accion=nuevo"

