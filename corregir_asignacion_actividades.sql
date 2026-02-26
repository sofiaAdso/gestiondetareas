-- Script para corregir la asignación de actividades a usuarios
-- Ejecutar paso a paso según sea necesario

-- ==================================================
-- PASO 1: DIAGNÓSTICO INICIAL
-- ==================================================

-- Ver actividades sin usuario asignado
SELECT
    '🔍 ACTIVIDADES SIN USUARIO' as diagnostico,
    COUNT(*) as cantidad
FROM actividades
WHERE usuario_id IS NULL;

-- Ver todas las actividades con su usuario
SELECT
    a.id,
    a.titulo,
    a.usuario_id,
    u.username,
    a.estado,
    a.fecha_creacion
FROM actividades a
LEFT JOIN usuarios u ON a.usuario_id = u.id
ORDER BY a.fecha_creacion DESC;

-- ==================================================
-- PASO 2: CORREGIR ACTIVIDADES SIN USUARIO
-- ==================================================

-- Opción A: Asignar al primer usuario disponible
-- Descomenta las siguientes líneas si quieres ejecutarlo:
/*
UPDATE actividades
SET usuario_id = (SELECT MIN(id) FROM usuarios)
WHERE usuario_id IS NULL;

SELECT 'Actividades corregidas: ' || COUNT(*) as resultado
FROM actividades
WHERE usuario_id = (SELECT MIN(id) FROM usuarios);
*/

-- Opción B: Asignar a un usuario específico
-- Reemplaza [ID_USUARIO] con el ID del usuario deseado
/*
UPDATE actividades
SET usuario_id = [ID_USUARIO]
WHERE usuario_id IS NULL;
*/

-- ==================================================
-- PASO 3: REASIGNAR ACTIVIDAD ESPECÍFICA
-- ==================================================

-- Para reasignar UNA actividad a un usuario específico:
-- Reemplaza [ID_ACTIVIDAD] y [ID_USUARIO] con los valores correctos
/*
UPDATE actividades
SET usuario_id = [ID_USUARIO]
WHERE id = [ID_ACTIVIDAD];
*/

-- Ejemplo: Reasignar actividad 5 al usuario 2
/*
UPDATE actividades
SET usuario_id = 2
WHERE id = 5;
*/

-- ==================================================
-- PASO 4: CREAR ACTIVIDADES DE PRUEBA
-- ==================================================

-- Crear actividades de ejemplo para cada usuario
/*
-- Para el primer usuario
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
SELECT
    id as usuario_id,
    'Mi Primera Actividad - ' || username as titulo,
    'Esta es una actividad de ejemplo asignada a ' || username as descripcion,
    CURRENT_DATE as fecha_inicio,
    CURRENT_DATE + INTERVAL '7 days' as fecha_fin,
    'Media' as prioridad,
    'En Progreso' as estado,
    '#3498db' as color
FROM usuarios
WHERE NOT EXISTS (
    SELECT 1 FROM actividades WHERE usuario_id = usuarios.id
)
LIMIT 1;
*/

-- ==================================================
-- PASO 5: VERIFICACIÓN FINAL
-- ==================================================

-- Verificar que todas las actividades tienen usuario válido
SELECT
    CASE
        WHEN COUNT(*) = 0 THEN '✅ PERFECTO: Todas las actividades tienen usuario asignado'
        ELSE '❌ ERROR: ' || COUNT(*) || ' actividades con usuario inválido'
    END as estado_final
FROM actividades a
WHERE NOT EXISTS (SELECT 1 FROM usuarios u WHERE u.id = a.usuario_id);

-- Resumen por usuario
SELECT
    '📊 RESUMEN POR USUARIO' as reporte,
    u.id,
    u.username,
    u.rol,
    COUNT(a.id) as total_actividades,
    COUNT(CASE WHEN a.estado = 'Completada' THEN 1 END) as completadas,
    COUNT(CASE WHEN a.estado = 'En Progreso' THEN 1 END) as en_progreso,
    COUNT(CASE WHEN a.estado = 'Planificada' THEN 1 END) as planificadas,
    COUNT(CASE WHEN a.estado = 'Pausada' THEN 1 END) as pausadas
FROM usuarios u
LEFT JOIN actividades a ON u.id = a.usuario_id
GROUP BY u.id, u.username, u.rol
ORDER BY total_actividades DESC;

-- ==================================================
-- PASO 6: MIGRAR ACTIVIDADES DE UN USUARIO A OTRO
-- ==================================================

-- Si necesitas transferir TODAS las actividades de un usuario a otro:
-- Reemplaza [ID_USUARIO_ORIGEN] y [ID_USUARIO_DESTINO]
/*
UPDATE actividades
SET usuario_id = [ID_USUARIO_DESTINO]
WHERE usuario_id = [ID_USUARIO_ORIGEN];

SELECT 'Actividades transferidas: ' || COUNT(*) as resultado
FROM actividades
WHERE usuario_id = [ID_USUARIO_DESTINO];
*/

-- ==================================================
-- PASO 7: ELIMINAR ACTIVIDADES HUÉRFANAS
-- ==================================================

-- Ver actividades con usuario_id que no existe en la tabla usuarios
SELECT
    a.id,
    a.titulo,
    a.usuario_id as usuario_id_invalido
FROM actividades a
WHERE NOT EXISTS (SELECT 1 FROM usuarios u WHERE u.id = a.usuario_id);

-- Para eliminarlas (usar con precaución):
/*
DELETE FROM actividades
WHERE NOT EXISTS (SELECT 1 FROM usuarios u WHERE u.id = actividades.usuario_id);
*/

-- ==================================================
-- CONSULTAS ÚTILES
-- ==================================================

-- Ver actividades de un usuario específico (reemplaza [ID_USUARIO])
/*
SELECT * FROM actividades WHERE usuario_id = [ID_USUARIO];
*/

-- Ver actividades que NO están asignadas a un usuario específico
/*
SELECT * FROM actividades WHERE usuario_id != [ID_USUARIO];
*/

-- Contar actividades por estado y usuario
/*
SELECT
    u.username,
    a.estado,
    COUNT(*) as cantidad
FROM actividades a
JOIN usuarios u ON a.usuario_id = u.id
GROUP BY u.username, a.estado
ORDER BY u.username, a.estado;
*/

