-- Script para verificar la estructura REAL de tu base de datos

-- 1. Ver todas las tablas que existen
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2. Ver estructura de la tabla actividades (si existe)
\d actividades

-- 3. Ver estructura de la tabla tareas (si existe)
\d tareas

-- 4. Ver estructura de la tabla usuarios (si existe)
\d usuarios

-- 5. Ver estructura de la tabla categorias (si existe)
\d categorias

-- 6. Mostrar las primeras filas de cada tabla
SELECT 'USUARIOS:' as tabla;
SELECT * FROM usuarios LIMIT 3;

SELECT 'CATEGORIAS:' as tabla;
SELECT * FROM categorias LIMIT 3;

SELECT 'TAREAS:' as tabla;
SELECT * FROM tareas LIMIT 3;

SELECT 'ACTIVIDADES:' as tabla;
SELECT * FROM actividades LIMIT 3;

