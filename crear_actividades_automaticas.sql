-- ============================================================================
-- SCRIPT: Crear Actividades Automáticamente a Partir de Tareas Existentes
-- Descripción: Este script analiza las tareas actuales y crea actividades
--              agrupándolas por usuario y categoría.
-- Fecha: 19/02/2026
-- ============================================================================

-- PASO 1: Ver el estado actual de las tareas sin actividad
-- =========================================================
SELECT
    COUNT(*) as total_tareas_sin_actividad,
    COUNT(DISTINCT usuario_id) as usuarios_afectados
FROM tareas
WHERE actividad_id IS NULL OR actividad_id = 0;

-- PASO 2: Ver agrupación de tareas por usuario y categoría
-- =========================================================
SELECT
    u.username,
    c.nombre as categoria,
    COUNT(*) as cantidad_tareas,
    MIN(t.fecha_inicio) as primera_fecha,
    MAX(t.fecha_vencimiento) as ultima_fecha
FROM tareas t
LEFT JOIN usuarios u ON t.usuario_id = u.id
LEFT JOIN categorias c ON t.categoria_id = c.id
WHERE t.actividad_id IS NULL OR t.actividad_id = 0
GROUP BY u.username, c.nombre, t.usuario_id, t.categoria_id
ORDER BY u.username, cantidad_tareas DESC;

-- PASO 3: Crear actividades automáticamente por usuario y categoría
-- ===================================================================
-- Se crearán actividades con el formato: "Actividad - [Categoría]"
-- para cada combinación de usuario-categoría que tenga tareas

DO $$
DECLARE
    v_usuario_id INT;
    v_usuario_nombre VARCHAR;
    v_categoria_id INT;
    v_categoria_nombre VARCHAR;
    v_cantidad_tareas INT;
    v_fecha_inicio DATE;
    v_fecha_fin DATE;
    v_actividad_id INT;
    v_contador INT := 0;
BEGIN
    -- Iterar sobre cada combinación usuario-categoría
    FOR v_usuario_id, v_usuario_nombre, v_categoria_id, v_categoria_nombre,
        v_cantidad_tareas, v_fecha_inicio, v_fecha_fin IN

    SELECT
        t.usuario_id,
        u.username,
        t.categoria_id,
        c.nombre,
        COUNT(*) as cantidad,
        MIN(t.fecha_inicio) as fecha_ini,
        MAX(t.fecha_vencimiento) as fecha_ven
    FROM tareas t
    LEFT JOIN usuarios u ON t.usuario_id = u.id
    LEFT JOIN categorias c ON t.categoria_id = c.id
    WHERE t.actividad_id IS NULL OR t.actividad_id = 0
    GROUP BY t.usuario_id, u.username, t.categoria_id, c.nombre

    LOOP
        -- Crear actividad para esta combinación
        INSERT INTO actividades
        (
            titulo,
            descripcion,
            usuario_id,
            fecha_inicio,
            fecha_fin,
            prioridad,
            estado,
            color
        )
        VALUES
        (
            'Actividad - ' || v_categoria_nombre,
            'Actividad creada automáticamente para agrupar ' || v_cantidad_tareas || ' tareas de la categoría ' || v_categoria_nombre,
            v_usuario_id,
            COALESCE(v_fecha_inicio, CURRENT_DATE),
            COALESCE(v_fecha_fin, CURRENT_DATE + INTERVAL '30 days'),
            'Media',
            'En Progreso',
            CASE
                WHEN v_categoria_nombre ILIKE '%trabajo%' THEN '#3498db'
                WHEN v_categoria_nombre ILIKE '%personal%' THEN '#e74c3c'
                WHEN v_categoria_nombre ILIKE '%estudio%' THEN '#9b59b6'
                ELSE '#2ecc71'
            END
        )
        RETURNING id INTO v_actividad_id;

        -- Asignar las tareas a esta actividad
        UPDATE tareas
        SET actividad_id = v_actividad_id
        WHERE usuario_id = v_usuario_id
          AND categoria_id = v_categoria_id
          AND (actividad_id IS NULL OR actividad_id = 0);

        v_contador := v_contador + 1;

        RAISE NOTICE 'Actividad creada: % - Usuario: % - Tareas asignadas: %',
                     v_actividad_id, v_usuario_nombre, v_cantidad_tareas;
    END LOOP;

    RAISE NOTICE '=== PROCESO COMPLETADO ===';
    RAISE NOTICE 'Total de actividades creadas: %', v_contador;

END $$;

-- PASO 4: Verificar el resultado
-- ===============================
SELECT
    'Tareas sin actividad (deben ser 0)' as verificacion,
    COUNT(*) as cantidad
FROM tareas
WHERE actividad_id IS NULL OR actividad_id = 0

UNION ALL

SELECT
    'Total de actividades creadas' as verificacion,
    COUNT(*) as cantidad
FROM actividades
WHERE descripcion LIKE '%creada automáticamente%'

UNION ALL

SELECT
    'Total de tareas con actividad asignada' as verificacion,
    COUNT(*) as cantidad
FROM tareas
WHERE actividad_id IS NOT NULL AND actividad_id > 0;

-- PASO 5: Ver resumen de actividades creadas
-- ===========================================
SELECT
    a.id,
    a.titulo,
    a.descripcion,
    u.username as usuario,
    a.fecha_inicio,
    a.fecha_fin,
    COUNT(t.id) as cantidad_tareas,
    a.color
FROM actividades a
LEFT JOIN usuarios u ON a.usuario_id = u.id
LEFT JOIN tareas t ON t.actividad_id = a.id
WHERE a.descripcion LIKE '%creada automáticamente%'
GROUP BY a.id, a.titulo, a.descripcion, u.username, a.fecha_inicio, a.fecha_fin, a.color
ORDER BY u.username, a.id;

-- ============================================================================
-- NOTAS IMPORTANTES:
-- ============================================================================
-- 1. Este script crea una actividad por cada combinación de usuario-categoría
-- 2. Las tareas se agrupan automáticamente según su categoría
-- 3. Las fechas de la actividad se calculan a partir de las tareas
-- 4. Los colores se asignan según el nombre de la categoría
-- 5. Después de ejecutar, TODAS las tareas tendrán una actividad asignada
-- ============================================================================

-- ROLLBACK (Si algo sale mal, deshacer cambios)
-- ==============================================
-- Descomentar estas líneas solo si necesitas deshacer:
/*
DELETE FROM actividades
WHERE descripcion LIKE '%creada automáticamente%';

UPDATE tareas
SET actividad_id = NULL
WHERE actividad_id IN (
    SELECT id FROM actividades
    WHERE descripcion LIKE '%creada automáticamente%'
);
*/

