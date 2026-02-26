-- Script para MOSTRAR LA ESTRUCTURA EXACTA de tu base de datos

-- Ver todas las columnas de la tabla 'usuarios'
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'usuarios'
ORDER BY ordinal_position;

-- Ver todas las columnas de la tabla 'actividades'
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'actividades'
ORDER BY ordinal_position;

-- Ver todas las columnas de la tabla 'tareas'
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'tareas'
ORDER BY ordinal_position;

-- Ver todas las columnas de la tabla 'categorias'
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'categorias'
ORDER BY ordinal_position;

-- Intentar crear una actividad de prueba
DO $$
DECLARE
    v_usuario_id INTEGER;
BEGIN
    -- Obtener el primer usuario
    SELECT id INTO v_usuario_id FROM usuarios LIMIT 1;

    IF v_usuario_id IS NULL THEN
        RAISE NOTICE 'ERROR: No hay usuarios en la tabla usuarios';
    ELSE
        RAISE NOTICE 'Usuario encontrado con ID: %', v_usuario_id;

        -- Intentar insertar una actividad de prueba
        BEGIN
            INSERT INTO actividades
            (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
            VALUES
            (v_usuario_id, 'PRUEBA SQL', 'Esta es una prueba directa desde SQL',
             CURRENT_DATE, CURRENT_DATE + 30, 'Media', 'En Progreso', '#3498db')
            RETURNING id INTO v_usuario_id;

            RAISE NOTICE '¡ÉXITO! Actividad creada con ID: %', v_usuario_id;

            -- Eliminar la prueba
            DELETE FROM actividades WHERE titulo = 'PRUEBA SQL';
            RAISE NOTICE 'Actividad de prueba eliminada';

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'ERROR al crear actividad: %', SQLERRM;
        END;
    END IF;
END $$;

