-- Script para verificar y crear tareas de ejemplo asociadas a actividades
-- Ejecutar en PostgreSQL

-- 1. Verificar actividades existentes
SELECT id, titulo, usuario_id, estado
FROM actividades
ORDER BY id;

-- 2. Verificar tareas existentes y su asociación con actividades
SELECT
    t.id,
    t.titulo AS tarea,
    t.estado,
    t.completada,
    t.actividad_id,
    a.titulo AS actividad
FROM tareas t
LEFT JOIN actividades a ON t.actividad_id = a.id
ORDER BY t.actividad_id, t.id;

-- 3. Contar tareas por actividad
SELECT
    a.id,
    a.titulo AS actividad,
    COUNT(t.id) AS total_tareas,
    SUM(CASE WHEN t.estado = 'Completada' OR t.completada = true THEN 1 ELSE 0 END) AS tareas_completadas,
    ROUND(
        CASE
            WHEN COUNT(t.id) > 0 THEN
                (SUM(CASE WHEN t.estado = 'Completada' OR t.completada = true THEN 1 ELSE 0 END)::numeric / COUNT(t.id)::numeric) * 100
            ELSE 0
        END,
        2
    ) AS porcentaje_completado
FROM actividades a
LEFT JOIN tareas t ON t.actividad_id = a.id
GROUP BY a.id, a.titulo
ORDER BY a.id;

-- 4. Si no hay tareas, crear ejemplos para las actividades existentes
-- NOTA: Ejecuta esto solo si necesitas crear tareas de ejemplo

-- Para la actividad "bañarse" (ajusta el ID según tu base de datos)
DO $$
DECLARE
    v_actividad_id INTEGER;
    v_usuario_id INTEGER;
BEGIN
    -- Obtener el ID de la actividad "bañarse"
    SELECT id, usuario_id INTO v_actividad_id, v_usuario_id
    FROM actividades
    WHERE titulo ILIKE '%baña%'
    LIMIT 1;

    IF v_actividad_id IS NOT NULL THEN
        -- Verificar si ya tiene tareas
        IF NOT EXISTS (SELECT 1 FROM tareas WHERE actividad_id = v_actividad_id) THEN
            -- Crear tareas de ejemplo
            INSERT INTO tareas (titulo, descripcion, prioridad, estado, fecha_inicio, fecha_vencimiento, actividad_id, usuario_id, categoria_id, completada, notas)
            VALUES
            ('Preparar ropa limpia', 'Seleccionar y preparar la ropa para después del baño', 'Media', 'Completada', CURRENT_DATE, CURRENT_DATE + 1, v_actividad_id, v_usuario_id, 1, true, 'Ropa lista'),
            ('Calentar agua', 'Asegurarse de que el agua esté a temperatura adecuada', 'Alta', 'Completada', CURRENT_DATE, CURRENT_DATE + 1, v_actividad_id, v_usuario_id, 1, true, 'Agua caliente lista'),
            ('Lavarse el cabello', 'Usar champú y acondicionador', 'Media', 'En Progreso', CURRENT_DATE, CURRENT_DATE + 1, v_actividad_id, v_usuario_id, 1, false, 'Pendiente'),
            ('Secar y vestirse', 'Secarse completamente y ponerse la ropa', 'Alta', 'Pendiente', CURRENT_DATE, CURRENT_DATE + 1, v_actividad_id, v_usuario_id, 1, false, 'Por hacer');

            RAISE NOTICE 'Tareas creadas para actividad: bañarse (ID: %)', v_actividad_id;
        ELSE
            RAISE NOTICE 'La actividad "bañarse" ya tiene tareas';
        END IF;
    END IF;
END $$;

-- Para la actividad "desarrollo web" (ajusta el ID según tu base de datos)
DO $$
DECLARE
    v_actividad_id INTEGER;
    v_usuario_id INTEGER;
BEGIN
    -- Obtener el ID de la actividad "desarrollo web"
    SELECT id, usuario_id INTO v_actividad_id, v_usuario_id
    FROM actividades
    WHERE titulo ILIKE '%desarrollo%web%'
    LIMIT 1;

    IF v_actividad_id IS NOT NULL THEN
        -- Verificar si ya tiene tareas
        IF NOT EXISTS (SELECT 1 FROM tareas WHERE actividad_id = v_actividad_id) THEN
            -- Crear tareas de ejemplo
            INSERT INTO tareas (titulo, descripcion, prioridad, estado, fecha_inicio, fecha_vencimiento, actividad_id, usuario_id, categoria_id, completada, notas)
            VALUES
            ('Diseñar mockups', 'Crear diseños visuales del sitio web', 'Alta', 'Completada', '2026-02-19', '2026-02-27', v_actividad_id, v_usuario_id, 1, true, 'Diseños aprobados'),
            ('Implementar HTML/CSS', 'Maquetar las páginas principales', 'Alta', 'Completada', '2026-02-19', '2026-02-27', v_actividad_id, v_usuario_id, 1, true, 'Maquetación completa'),
            ('Añadir JavaScript', 'Implementar interactividad y validaciones', 'Media', 'En Progreso', '2026-02-19', '2026-02-27', v_actividad_id, v_usuario_id, 1, false, 'En desarrollo'),
            ('Configurar backend', 'Establecer servidor y base de datos', 'Alta', 'Pendiente', '2026-02-19', '2026-02-27', v_actividad_id, v_usuario_id, 1, false, 'Por iniciar'),
            ('Pruebas y deployment', 'Probar funcionalidad y desplegar', 'Alta', 'Pendiente', '2026-02-19', '2026-02-27', v_actividad_id, v_usuario_id, 1, false, 'Última fase');

            RAISE NOTICE 'Tareas creadas para actividad: desarrollo web (ID: %)', v_actividad_id;
        ELSE
            RAISE NOTICE 'La actividad "desarrollo web" ya tiene tareas';
        END IF;
    END IF;
END $$;

-- 5. Verificar el resultado final
SELECT
    a.titulo AS actividad,
    a.estado AS estado_actividad,
    COUNT(t.id) AS total_tareas,
    SUM(CASE WHEN t.estado = 'Completada' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN t.estado = 'En Progreso' THEN 1 ELSE 0 END) AS en_progreso,
    SUM(CASE WHEN t.estado = 'Pendiente' THEN 1 ELSE 0 END) AS pendientes
FROM actividades a
LEFT JOIN tareas t ON t.actividad_id = a.id
GROUP BY a.id, a.titulo, a.estado
ORDER BY a.id;

