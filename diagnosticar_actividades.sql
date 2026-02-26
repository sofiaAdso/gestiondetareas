-- Script para diagnosticar problemas con la creación de actividades

-- 1. Verificar si existe la tabla actividades
SELECT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_name = 'actividades'
) AS tabla_actividades_existe;

-- 2. Ver la estructura de la tabla actividades
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'actividades'
ORDER BY ordinal_position;

-- 3. Verificar constraints y foreign keys
SELECT
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
LEFT JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.table_name = 'actividades';

-- 4. Verificar si hay usuarios en la tabla usuarios
SELECT COUNT(*) as total_usuarios FROM usuarios;

-- 5. Ver algunos usuarios de ejemplo
SELECT id, nombre, email, rol
FROM usuarios
LIMIT 5;

-- 6. Contar actividades existentes
SELECT COUNT(*) as total_actividades FROM actividades;

-- 7. Ver algunas actividades de ejemplo (si existen)
SELECT id, usuario_id, titulo, estado, fecha_creacion
FROM actividades
ORDER BY fecha_creacion DESC
LIMIT 5;

-- 8. Verificar permisos de la tabla actividades
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name='actividades';

