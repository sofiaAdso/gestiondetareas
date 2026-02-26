-- Script para organizar tareas existentes en actividades
-- Este script crea actividades automáticamente basadas en categorías o usuarios
-- y asocia las tareas existentes a estas actividades

-- OPCIÓN 1: Crear actividades por categoría y asociar tareas
-- Esto agrupa todas las tareas de la misma categoría en una actividad

DO $$
DECLARE
    categoria_rec RECORD;
    actividad_id_nueva INT;
BEGIN
    -- Para cada categoría existente
    FOR categoria_rec IN
        SELECT DISTINCT c.id, c.nombre, t.usuario_id
        FROM categorias c
        INNER JOIN tareas t ON c.id = t.categoria_id
        WHERE t.actividad_id IS NULL
        GROUP BY c.id, c.nombre, t.usuario_id
    LOOP
        -- Crear una actividad para esta categoría y usuario
        INSERT INTO actividades (
            usuario_id,
            titulo,
            descripcion,
            fecha_inicio,
            fecha_fin,
            prioridad,
            estado,
            color
        ) VALUES (
            categoria_rec.usuario_id,
            'Proyecto: ' || categoria_rec.nombre,
            'Agrupación automática de tareas de categoría ' || categoria_rec.nombre,
            CURRENT_DATE,
            CURRENT_DATE + INTERVAL '30 days',
            'Media',
            'En Progreso',
            '#3498db'
        ) RETURNING id INTO actividad_id_nueva;

        -- Asociar todas las tareas de esta categoría a la actividad
        UPDATE tareas
        SET actividad_id = actividad_id_nueva
        WHERE categoria_id = categoria_rec.id
          AND usuario_id = categoria_rec.usuario_id
          AND actividad_id IS NULL;

        RAISE NOTICE 'Actividad creada: % (ID: %) con tareas de categoría %',
            'Proyecto: ' || categoria_rec.nombre,
            actividad_id_nueva,
            categoria_rec.nombre;
    END LOOP;
END $$;

-- OPCIÓN 2: Crear una actividad general por usuario para tareas sin agrupar
-- Esto crea una actividad "Tareas Generales" para cada usuario

DO $$
DECLARE
    usuario_rec RECORD;
    actividad_general_id INT;
BEGIN
    FOR usuario_rec IN
        SELECT DISTINCT usuario_id
        FROM tareas
        WHERE actividad_id IS NULL
    LOOP
        -- Crear actividad general
        INSERT INTO actividades (
            usuario_id,
            titulo,
            descripcion,
            fecha_inicio,
            fecha_fin,
            prioridad,
            estado,
            color
        ) VALUES (
            usuario_rec.usuario_id,
            'Tareas Generales',
            'Tareas sin categoría específica',
            CURRENT_DATE,
            CURRENT_DATE + INTERVAL '60 days',
            'Media',
            'En Progreso',
            '#95a5a6'
        ) RETURNING id INTO actividad_general_id;

        -- Asociar tareas sin actividad
        UPDATE tareas
        SET actividad_id = actividad_general_id
        WHERE usuario_id = usuario_rec.usuario_id
          AND actividad_id IS NULL;

        RAISE NOTICE 'Actividad General creada para usuario ID: %', usuario_rec.usuario_id;
    END LOOP;
END $$;

-- Verificar resultados
SELECT
    a.id as actividad_id,
    a.titulo as actividad,
    a.color,
    COUNT(t.id) as total_tareas,
    COUNT(CASE WHEN t.estado = 'Completada' THEN 1 END) as tareas_completadas,
    u.username as propietario
FROM actividades a
LEFT JOIN tareas t ON a.id = t.actividad_id
LEFT JOIN usuarios u ON a.usuario_id = u.id
GROUP BY a.id, a.titulo, a.color, u.username
ORDER BY a.fecha_creacion DESC;

-- Ver tareas que aún no tienen actividad (si hay alguna)
SELECT
    t.id,
    t.titulo,
    t.estado,
    c.nombre as categoria,
    u.username as usuario
FROM tareas t
LEFT JOIN categorias c ON t.categoria_id = c.id
LEFT JOIN usuarios u ON t.usuario_id = u.id
WHERE t.actividad_id IS NULL;

-- Comentario final
COMMENT ON SCRIPT IS 'Script ejecutado para organizar tareas existentes en actividades automáticamente';

