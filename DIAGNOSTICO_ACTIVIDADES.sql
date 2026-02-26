-- ========================================
-- DIAGNÓSTICO COMPLETO DE ACTIVIDADES
-- ========================================

-- 1. Verificar que la tabla actividades existe
SELECT
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name = 'actividades';

-- 2. Verificar estructura de la tabla actividades
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'actividades'
ORDER BY ordinal_position;

-- 3. Verificar que hay usuarios en la base de datos
SELECT
    id,
    username,
    rol
FROM usuarios
ORDER BY id;

-- 4. Contar actividades por usuario
SELECT
    u.id,
    u.username,
    u.rol,
    COUNT(a.id) as total_actividades
FROM usuarios u
LEFT JOIN actividades a ON u.id = a.usuario_id
GROUP BY u.id, u.username, u.rol
ORDER BY u.id;

-- 5. Ver todas las actividades con información detallada
SELECT
    a.id,
    a.usuario_id,
    u.username,
    a.titulo,
    a.descripcion,
    a.fecha_inicio,
    a.fecha_fin,
    a.prioridad,
    a.estado,
    a.color,
    a.fecha_creacion,
    COUNT(t.id) as total_tareas,
    COUNT(CASE WHEN t.estado = 'Completada' THEN 1 END) as tareas_completadas
FROM actividades a
LEFT JOIN usuarios u ON a.usuario_id = u.id
LEFT JOIN tareas t ON a.id = t.actividad_id
GROUP BY a.id, a.usuario_id, u.username, a.titulo, a.descripcion,
         a.fecha_inicio, a.fecha_fin, a.prioridad, a.estado, a.color, a.fecha_creacion
ORDER BY a.fecha_creacion DESC;

-- 6. Verificar restricciones y claves foráneas
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
WHERE tc.table_name = 'actividades'
AND tc.table_schema = 'public';

-- 7. Si no hay actividades, crear actividades de prueba para cada usuario
-- DESCOMENTA ESTAS LÍNEAS SI NO HAY ACTIVIDADES Y QUIERES CREAR DATOS DE PRUEBA:
/*
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
SELECT
    u.id,
    'Actividad de prueba para ' || u.username,
    'Esta es una actividad de prueba creada automáticamente',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '7 days',
    'Media',
    'Pendiente',
    '#667eea'
FROM usuarios u
WHERE NOT EXISTS (
    SELECT 1 FROM actividades a WHERE a.usuario_id = u.id
);
*/

-- 8. Verificar la tabla tareas relacionada
SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name = 'tareas';

-- 9. Ver relación entre actividades y tareas
SELECT
    a.id as actividad_id,
    a.titulo as actividad_titulo,
    a.estado as actividad_estado,
    COUNT(t.id) as cantidad_tareas,
    STRING_AGG(t.titulo, ', ') as tareas_listado
FROM actividades a
LEFT JOIN tareas t ON a.id = t.actividad_id
GROUP BY a.id, a.titulo, a.estado
ORDER BY a.id;

-- ========================================
-- RESULTADO ESPERADO:
-- ========================================
-- Todas las consultas deben devolver resultados sin errores
-- Debe haber al menos 1 usuario en la tabla usuarios
-- La tabla actividades debe existir con todas las columnas necesarias
-- Si hay actividades, deben estar vinculadas a usuarios existentes

