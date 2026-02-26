-- Script para verificar y corregir la asignación de actividades a usuarios
-- Base de datos PostgreSQL

-- 1. Verificar si existen actividades sin usuario asignado
SELECT
    'Actividades sin usuario asignado:' as tipo,
    COUNT(*) as cantidad
FROM actividades
WHERE usuario_id IS NULL;

-- 2. Mostrar todas las actividades con su usuario asignado
SELECT
    a.id,
    a.titulo,
    a.usuario_id,
    u.username as nombre_usuario,
    a.estado,
    a.fecha_creacion
FROM actividades a
LEFT JOIN usuarios u ON a.usuario_id = u.id
ORDER BY a.fecha_creacion DESC;

-- 3. Verificar usuarios existentes en el sistema
SELECT
    'Usuarios en el sistema:' as tipo,
    COUNT(*) as cantidad
FROM usuarios;

SELECT
    id,
    username,
    email,
    rol
FROM usuarios
ORDER BY id;

-- 4. Contar actividades por usuario
SELECT
    u.id,
    u.username,
    u.rol,
    COUNT(a.id) as total_actividades,
    COUNT(CASE WHEN a.estado = 'Completada' THEN 1 END) as actividades_completadas,
    COUNT(CASE WHEN a.estado = 'En Progreso' THEN 1 END) as actividades_en_progreso
FROM usuarios u
LEFT JOIN actividades a ON u.id = a.usuario_id
GROUP BY u.id, u.username, u.rol
ORDER BY u.id;

-- 5. SI HAY ACTIVIDADES SIN USUARIO: Asignar al primer usuario disponible (descomentar si es necesario)
/*
UPDATE actividades
SET usuario_id = (SELECT MIN(id) FROM usuarios)
WHERE usuario_id IS NULL;
*/

-- 6. Verificar que todas las actividades tienen usuario_id válido
SELECT
    CASE
        WHEN COUNT(*) = 0 THEN '✓ TODAS las actividades tienen usuario asignado correctamente'
        ELSE '✗ HAY ' || COUNT(*) || ' actividades con usuario_id inválido'
    END as estado
FROM actividades a
WHERE NOT EXISTS (SELECT 1 FROM usuarios u WHERE u.id = a.usuario_id);

