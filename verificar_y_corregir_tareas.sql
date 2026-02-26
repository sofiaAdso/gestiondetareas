-- ============================================
-- SCRIPT DE VERIFICACIÓN Y CORRECCIÓN
-- Para solucionar el problema de tareas no visibles
-- ============================================

-- PASO 1: Verificar si la columna 'activo' existe
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'tareas' AND column_name = 'activo';

-- Si la consulta anterior NO devuelve resultados, ejecuta esto:
-- ALTER TABLE tareas ADD COLUMN activo BOOLEAN DEFAULT true;

-- PASO 2: Ver todas las tareas y su estado de 'activo'
SELECT
    id,
    titulo,
    estado,
    activo,
    usuario_id
FROM tareas
ORDER BY id DESC;

-- PASO 3: Contar tareas por estado de 'activo'
SELECT
    COALESCE(activo::TEXT, 'NULL') as estado_activo,
    COUNT(*) as cantidad
FROM tareas
GROUP BY activo;

-- PASO 4: Si tienes tareas con activo = false o NULL, actívalas
UPDATE tareas SET activo = true WHERE activo IS NULL OR activo = false;

-- PASO 5: Verificar el resultado
SELECT
    id,
    titulo,
    estado,
    activo,
    usuario_id,
    fecha_inicio,
    fecha_vencimiento
FROM tareas
WHERE activo = true OR activo IS NULL
ORDER BY id DESC;

-- PASO 6: Ver tareas con JOIN (igual que la consulta de la aplicación)
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.activo,
    u.username as usuario,
    c.nombre as categoria
FROM tareas t
LEFT JOIN usuarios u ON t.usuario_id = u.id
LEFT JOIN categorias c ON t.categoria_id = c.id
WHERE (t.activo = true OR t.activo IS NULL)
ORDER BY t.id DESC;

-- ============================================
-- PASO 7: Si NO ves ninguna tarea, inserta una de prueba
-- ============================================
INSERT INTO tareas (
    titulo,
    descripcion,
    prioridad,
    estado,
    fecha_inicio,
    fecha_vencimiento,
    usuario_id,
    categoria_id,
    activo
)
VALUES (
    'Tarea de Prueba Dashboard',
    'Esta tarea es para verificar que el dashboard funcione correctamente',
    'Alta',
    'Pendiente',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '7 days',
    1,  -- CAMBIA ESTO por tu ID de usuario
    1,  -- CAMBIA ESTO por un ID de categoría válido
    true
);

-- Verificar que se insertó correctamente
SELECT * FROM tareas WHERE titulo = 'Tarea de Prueba Dashboard';

