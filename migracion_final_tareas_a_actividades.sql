-- ============================================================================
-- SCRIPT: Migración Definitiva - Tareas → Actividades con Tareas Hijas
-- Descripción:
--   1. Elimina la tabla actividades actual (si existe)
--   2. Renombra tabla 'tareas' actual a 'actividades'
--   3. Crea nueva tabla 'tareas' que depende obligatoriamente de actividades
-- Fecha: 19/02/2026
-- ============================================================================

-- IMPORTANTE: Hacer BACKUP antes de ejecutar
-- pg_dump -U postgres -d gestion_tareas -f backup_antes_migracion_final.sql

BEGIN;

-- ============================================================================
-- PASO 1: Eliminar tabla actividades antigua (si existe)
-- ============================================================================

DROP TABLE IF EXISTS actividades CASCADE;
RAISE NOTICE 'Paso 1: Tabla actividades antigua eliminada';

-- ============================================================================
-- PASO 2: Renombrar la tabla 'tareas' actual a 'actividades'
-- ============================================================================

-- 2.1 Renombrar la tabla
ALTER TABLE tareas RENAME TO actividades;

-- 2.2 Renombrar la secuencia del ID
ALTER SEQUENCE tareas_id_seq RENAME TO actividades_id_seq;

-- 2.3 Eliminar la columna actividad_id de la nueva tabla actividades (ya no se necesita)
ALTER TABLE actividades DROP COLUMN IF EXISTS actividad_id;

-- 2.4 Renombrar índices si existen
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tareas_usuario_id') THEN
        ALTER INDEX idx_tareas_usuario_id RENAME TO idx_actividades_usuario_id;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tareas_categoria_id') THEN
        ALTER INDEX idx_tareas_categoria_id RENAME TO idx_actividades_categoria_id;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tareas_estado') THEN
        ALTER INDEX idx_tareas_estado RENAME TO idx_actividades_estado;
    END IF;
END $$;

-- 2.5 Agregar campos adicionales a actividades si no existen
DO $$
BEGIN
    -- Agregar campo color si no existe
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'actividades' AND column_name = 'color'
    ) THEN
        ALTER TABLE actividades ADD COLUMN color VARCHAR(7) DEFAULT '#3498db';
    END IF;

    -- Agregar campo fecha_creacion si no existe
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'actividades' AND column_name = 'fecha_creacion'
    ) THEN
        ALTER TABLE actividades ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    END IF;

    -- Renombrar fecha_vencimiento a fecha_fin si existe
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'actividades' AND column_name = 'fecha_vencimiento'
    ) THEN
        ALTER TABLE actividades RENAME COLUMN fecha_vencimiento TO fecha_fin;
    END IF;
END $$;

RAISE NOTICE 'Paso 2: Tabla tareas renombrada a actividades';

-- ============================================================================
-- PASO 3: Crear la nueva tabla 'tareas' que depende de actividades
-- ============================================================================

CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    prioridad VARCHAR(20) DEFAULT 'Media',
    estado VARCHAR(20) DEFAULT 'Pendiente',
    fecha_inicio DATE DEFAULT CURRENT_DATE,
    fecha_vencimiento DATE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actividad_id INTEGER NOT NULL,  -- OBLIGATORIO: cada tarea pertenece a una actividad
    completada BOOLEAN DEFAULT FALSE,
    notas TEXT,

    -- Llave foránea a actividades
    CONSTRAINT fk_tarea_actividad
        FOREIGN KEY (actividad_id)
        REFERENCES actividades(id)
        ON DELETE CASCADE,  -- Si se elimina la actividad, se eliminan sus tareas

    -- Validaciones
    CONSTRAINT chk_tarea_prioridad CHECK (prioridad IN ('Baja', 'Media', 'Alta')),
    CONSTRAINT chk_tarea_estado CHECK (estado IN ('Pendiente', 'En Proceso', 'En Progreso', 'Completada')),
    CONSTRAINT chk_tarea_fechas CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_inicio)
);

-- Crear índices para mejor rendimiento
CREATE INDEX idx_tareas_actividad_id ON tareas(actividad_id);
CREATE INDEX idx_tareas_estado ON tareas(estado);
CREATE INDEX idx_tareas_fecha_vencimiento ON tareas(fecha_vencimiento);
CREATE INDEX idx_tareas_completada ON tareas(completada);

-- Comentarios en la tabla
COMMENT ON TABLE tareas IS 'Tareas individuales que pertenecen a actividades';
COMMENT ON COLUMN tareas.id IS 'Identificador único de la tarea';
COMMENT ON COLUMN tareas.actividad_id IS 'ID de la actividad padre (obligatorio)';
COMMENT ON COLUMN tareas.completada IS 'Indica si la tarea está completada';

RAISE NOTICE 'Paso 3: Nueva tabla tareas creada';

-- ============================================================================
-- PASO 4: Migrar subtareas existentes a la nueva tabla tareas (si existen)
-- ============================================================================

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'subtareas') THEN

        -- Insertar subtareas como tareas normales
        INSERT INTO tareas (
            titulo,
            descripcion,
            fecha_inicio,
            fecha_vencimiento,
            actividad_id,
            completada,
            estado,
            fecha_creacion
        )
        SELECT
            titulo,
            descripcion,
            COALESCE(fecha_creacion::DATE, CURRENT_DATE),
            NULL,
            tarea_id,  -- tarea_id de subtareas se convierte en actividad_id
            completada,
            CASE
                WHEN completada THEN 'Completada'
                ELSE 'Pendiente'
            END,
            COALESCE(fecha_creacion, CURRENT_TIMESTAMP)
        FROM subtareas;

        RAISE NOTICE 'Subtareas migradas a la nueva tabla tareas';

        -- Opcional: Renombrar tabla subtareas antigua
        ALTER TABLE subtareas RENAME TO subtareas_old_backup;
        RAISE NOTICE 'Tabla subtareas renombrada a subtareas_old_backup';
    END IF;
END $$;

-- ============================================================================
-- PASO 5: Crear vistas útiles
-- ============================================================================

-- Vista para ver actividades con su progreso
CREATE OR REPLACE VIEW vista_actividades_progreso AS
SELECT
    a.id,
    a.titulo,
    a.descripcion,
    a.estado,
    a.prioridad,
    a.fecha_inicio,
    a.fecha_fin,
    a.color,
    a.fecha_creacion,
    u.username as responsable,
    c.nombre as categoria,
    COUNT(t.id) as total_tareas,
    COUNT(t.id) FILTER (WHERE t.completada = TRUE) as tareas_completadas,
    CASE
        WHEN COUNT(t.id) = 0 THEN 0
        ELSE ROUND((COUNT(t.id) FILTER (WHERE t.completada = TRUE)::DECIMAL / COUNT(t.id)) * 100, 2)
    END as porcentaje_completado
FROM actividades a
LEFT JOIN tareas t ON t.actividad_id = a.id
LEFT JOIN usuarios u ON a.usuario_id = u.id
LEFT JOIN categorias c ON a.categoria_id = c.id
GROUP BY a.id, a.titulo, a.descripcion, a.estado, a.prioridad,
         a.fecha_inicio, a.fecha_fin, a.color, a.fecha_creacion, u.username, c.nombre;

COMMENT ON VIEW vista_actividades_progreso IS 'Vista con actividades y su progreso basado en tareas';

RAISE NOTICE 'Paso 5: Vista vista_actividades_progreso creada';

-- ============================================================================
-- PASO 6: Verificación de resultados
-- ============================================================================

-- Ver resumen de la migración
SELECT
    'Actividades (antes tareas)' as tabla,
    COUNT(*) as cantidad
FROM actividades

UNION ALL

SELECT
    'Tareas nuevas (migradas desde subtareas)' as tabla,
    COUNT(*) as cantidad
FROM tareas;

-- Ver estructura de relación
SELECT
    a.id as actividad_id,
    a.titulo as actividad,
    COUNT(t.id) as cantidad_tareas,
    a.usuario_id,
    u.username
FROM actividades a
LEFT JOIN tareas t ON t.actividad_id = a.id
LEFT JOIN usuarios u ON a.usuario_id = u.id
GROUP BY a.id, a.titulo, a.usuario_id, u.username
ORDER BY a.id
LIMIT 10;

RAISE NOTICE '========================================';
RAISE NOTICE 'MIGRACIÓN COMPLETADA EXITOSAMENTE';
RAISE NOTICE '========================================';
RAISE NOTICE 'Tabla ACTIVIDADES: antigua tabla tareas';
RAISE NOTICE 'Tabla TAREAS: nuevas tareas hijas de actividades';
RAISE NOTICE 'Cada tarea DEBE pertenecer a una actividad';
RAISE NOTICE '========================================';

COMMIT;

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT 'MIGRACIÓN COMPLETADA' as resultado;

-- Mostrar estadísticas
SELECT
    'Total Actividades' as metrica,
    COUNT(*)::TEXT as valor
FROM actividades

UNION ALL

SELECT
    'Total Tareas' as metrica,
    COUNT(*)::TEXT as valor
FROM tareas;

-- ============================================================================
-- NOTAS POST-MIGRACIÓN
-- ============================================================================

/*
ESTRUCTURA FINAL:

1. ACTIVIDADES (antes tareas):
   - Contiene todas las antiguas tareas
   - Campos: id, titulo, descripcion, prioridad, estado, fecha_inicio, fecha_fin,
             usuario_id, categoria_id, color, fecha_creacion

2. TAREAS (nueva):
   - Tareas hijas que pertenecen a actividades
   - Campos: id, titulo, descripcion, prioridad, estado, fecha_inicio,
             fecha_vencimiento, actividad_id (obligatorio), completada, notas

RELACIONES:
   Usuario → Actividad → Tarea (jerárquica)

CAMBIOS EN CÓDIGO JAVA:
   - TareaDao: Actualizar queries para trabajar con la nueva estructura
   - Modelo Tarea: Hacer actividad_id obligatorio, agregar campo completada
   - Vistas JSP: Actualizar para requerir selección de actividad al crear tareas
*/

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================

