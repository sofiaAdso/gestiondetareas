-- =====================================================
-- SCRIPT: Verificar y Crear Tareas de Prueba
-- =====================================================

-- 1. Verificar cuántas tareas existen
SELECT
    '=== ESTADO ACTUAL DE LA BASE DE DATOS ===' as titulo;

SELECT
    'Total de Usuarios' as tipo,
    COUNT(*) as cantidad
FROM usuarios
UNION ALL
SELECT
    'Total de Actividades' as tipo,
    COUNT(*) as cantidad
FROM actividades
UNION ALL
SELECT
    'Total de Tareas' as tipo,
    COUNT(*) as cantidad
FROM tareas;

-- 2. Ver detalles de tareas existentes
SELECT
    '=== TAREAS EXISTENTES ===' as titulo;

SELECT
    t.id,
    t.titulo,
    t.actividad_id,
    a.titulo as nombre_actividad,
    t.usuario_id,
    u.username,
    t.estado,
    t.fecha_creacion
FROM tareas t
LEFT JOIN actividades a ON t.actividad_id = a.id
LEFT JOIN usuarios u ON t.usuario_id = u.id
ORDER BY t.fecha_creacion DESC
LIMIT 10;

-- 3. Verificar si hay tareas sin actividad o sin usuario
SELECT
    '=== PROBLEMAS DETECTADOS ===' as titulo;

SELECT
    'Tareas sin actividad_id' as problema,
    COUNT(*) as cantidad
FROM tareas
WHERE actividad_id IS NULL OR actividad_id = 0
UNION ALL
SELECT
    'Tareas sin usuario_id' as problema,
    COUNT(*) as cantidad
FROM tareas
WHERE usuario_id IS NULL OR usuario_id = 0
UNION ALL
SELECT
    'Actividades sin usuario_id' as problema,
    COUNT(*) as cantidad
FROM actividades
WHERE usuario_id IS NULL;

-- 4. Si no hay tareas, crear datos de prueba
DO $$
DECLARE
    v_usuario_id INT;
    v_actividad_id INT;
    v_categoria_id INT;
    v_total_tareas INT;
BEGIN
    -- Contar tareas existentes
    SELECT COUNT(*) INTO v_total_tareas FROM tareas;

    IF v_total_tareas = 0 THEN
        RAISE NOTICE 'No hay tareas. Creando datos de prueba...';

        -- Obtener el primer usuario
        SELECT id INTO v_usuario_id FROM usuarios ORDER BY id LIMIT 1;

        IF v_usuario_id IS NULL THEN
            RAISE EXCEPTION 'No hay usuarios en la base de datos. Crea un usuario primero.';
        END IF;

        -- Obtener la primera categoría
        SELECT id INTO v_categoria_id FROM categorias ORDER BY id LIMIT 1;

        -- Verificar si hay actividades para este usuario
        SELECT id INTO v_actividad_id
        FROM actividades
        WHERE usuario_id = v_usuario_id
        ORDER BY id LIMIT 1;

        -- Si no hay actividad, crear una
        IF v_actividad_id IS NULL THEN
            INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado)
            VALUES (
                v_usuario_id,
                'Actividad de Prueba',
                'Actividad creada automáticamente para pruebas',
                CURRENT_DATE,
                CURRENT_DATE + INTERVAL '7 days',
                'Media',
                'En Progreso'
            )
            RETURNING id INTO v_actividad_id;

            RAISE NOTICE 'Actividad creada con ID: %', v_actividad_id;
        END IF;

        -- Crear 5 tareas de prueba
        FOR i IN 1..5 LOOP
            INSERT INTO tareas (
                actividad_id,
                usuario_id,
                categoria_id,
                titulo,
                descripcion,
                fecha_inicio,
                fecha_vencimiento,
                prioridad,
                estado,
                completada
            )
            VALUES (
                v_actividad_id,
                v_usuario_id,
                v_categoria_id,
                'Tarea de Prueba ' || i,
                'Esta es una tarea de prueba número ' || i,
                CURRENT_DATE,
                CURRENT_DATE + INTERVAL '7 days',
                CASE WHEN i % 3 = 0 THEN 'Alta' WHEN i % 2 = 0 THEN 'Media' ELSE 'Baja' END,
                CASE WHEN i = 1 THEN 'Completada' WHEN i = 2 THEN 'En Progreso' ELSE 'Pendiente' END,
                CASE WHEN i = 1 THEN true ELSE false END
            );
        END LOOP;

        RAISE NOTICE '5 tareas de prueba creadas exitosamente';
    ELSE
        RAISE NOTICE 'Ya existen % tareas en la base de datos', v_total_tareas;
    END IF;
END $$;

-- 5. Mostrar el resultado final
SELECT
    '=== RESULTADO FINAL ===' as titulo;

SELECT
    t.id,
    t.titulo,
    a.titulo as actividad,
    u.username as usuario,
    c.nombre as categoria,
    t.estado,
    t.prioridad
FROM tareas t
INNER JOIN actividades a ON t.actividad_id = a.id
INNER JOIN usuarios u ON t.usuario_id = u.id
LEFT JOIN categorias c ON t.categoria_id = c.id
ORDER BY t.fecha_creacion DESC;

-- 6. Resumen
SELECT
    '=== RESUMEN ===' as titulo;

SELECT
    'Usuario' as tipo,
    u.username as nombre,
    COUNT(t.id) as total_tareas,
    COUNT(CASE WHEN t.estado = 'Completada' THEN 1 END) as completadas,
    COUNT(CASE WHEN t.estado = 'En Progreso' THEN 1 END) as en_progreso,
    COUNT(CASE WHEN t.estado = 'Pendiente' THEN 1 END) as pendientes
FROM usuarios u
LEFT JOIN tareas t ON u.id = t.usuario_id
GROUP BY u.id, u.username
ORDER BY total_tareas DESC;

