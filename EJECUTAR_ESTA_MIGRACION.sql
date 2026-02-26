-- ============================================================================
-- EJECUTAR ESTE SCRIPT EN TU GESTOR DE BASE DE DATOS (pgAdmin, DBeaver, etc)
-- O desde la línea de comandos con:
-- psql -U postgres -d gestion_tareas -f EJECUTAR_ESTA_MIGRACION.sql
-- ============================================================================

-- PASO 1: Verificar estado actual
SELECT 'ANTES DE MIGRACIÓN - Tablas existentes:' as info;
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- ============================================================================
-- MIGRACIÓN COMIENZA AQUÍ
-- ============================================================================

BEGIN;

-- PASO 2: Eliminar tabla actividades si existe (de migraciones anteriores)
DROP TABLE IF EXISTS actividades CASCADE;

-- PASO 3: Renombrar tabla 'tareas' a 'actividades'
ALTER TABLE tareas RENAME TO actividades;

-- PASO 4: Renombrar la secuencia
ALTER SEQUENCE tareas_id_seq RENAME TO actividades_id_seq;

-- PASO 5: Eliminar columna actividad_id de la nueva tabla actividades (no se necesita)
ALTER TABLE actividades DROP COLUMN IF EXISTS actividad_id;

-- PASO 6: Renombrar índices
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tareas_usuario_id') THEN
        ALTER INDEX idx_tareas_usuario_id RENAME TO idx_actividades_usuario_id;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tareas_categoria_id') THEN
        ALTER INDEX idx_tareas_categoria_id RENAME TO idx_actividades_categoria_id;
    END IF;
END $$;

-- PASO 7: Agregar campos adicionales a actividades si no existen
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'actividades' AND column_name = 'color') THEN
        ALTER TABLE actividades ADD COLUMN color VARCHAR(7) DEFAULT '#3498db';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'actividades' AND column_name = 'fecha_creacion') THEN
        ALTER TABLE actividades ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'actividades' AND column_name = 'fecha_vencimiento') THEN
        ALTER TABLE actividades RENAME COLUMN fecha_vencimiento TO fecha_fin;
    END IF;
END $$;

-- PASO 8: Crear la nueva tabla 'tareas' que depende de actividades
CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    prioridad VARCHAR(20) DEFAULT 'Media',
    estado VARCHAR(20) DEFAULT 'Pendiente',
    fecha_inicio DATE DEFAULT CURRENT_DATE,
    fecha_vencimiento DATE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actividad_id INTEGER NOT NULL,
    completada BOOLEAN DEFAULT FALSE,
    notas TEXT,
    CONSTRAINT fk_tarea_actividad FOREIGN KEY (actividad_id) REFERENCES actividades(id) ON DELETE CASCADE,
    CONSTRAINT chk_tarea_prioridad CHECK (prioridad IN ('Baja', 'Media', 'Alta')),
    CONSTRAINT chk_tarea_estado CHECK (estado IN ('Pendiente', 'En Proceso', 'En Progreso', 'Completada')),
    CONSTRAINT chk_tarea_fechas CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_inicio)
);

-- PASO 9: Crear índices
CREATE INDEX idx_tareas_actividad_id ON tareas(actividad_id);
CREATE INDEX idx_tareas_estado ON tareas(estado);
CREATE INDEX idx_tareas_fecha_vencimiento ON tareas(fecha_vencimiento);
CREATE INDEX idx_tareas_completada ON tareas(completada);

-- PASO 10: Migrar subtareas a la nueva tabla tareas (si existen)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'subtareas') THEN
        INSERT INTO tareas (titulo, descripcion, fecha_inicio, fecha_vencimiento, actividad_id, completada, estado, fecha_creacion)
        SELECT titulo, descripcion, COALESCE(fecha_creacion::DATE, CURRENT_DATE), NULL, tarea_id, completada,
               CASE WHEN completada THEN 'Completada' ELSE 'Pendiente' END, COALESCE(fecha_creacion, CURRENT_TIMESTAMP)
        FROM subtareas;

        ALTER TABLE subtareas RENAME TO subtareas_old_backup;
    END IF;
END $$;

-- PASO 11: Crear vista de progreso
CREATE OR REPLACE VIEW vista_actividades_progreso AS
SELECT a.id, a.titulo, a.descripcion, a.estado, a.prioridad, a.fecha_inicio, a.fecha_fin, a.color, a.fecha_creacion,
       u.username as responsable, c.nombre as categoria,
       COUNT(t.id) as total_tareas,
       COUNT(t.id) FILTER (WHERE t.completada = TRUE) as tareas_completadas,
       CASE WHEN COUNT(t.id) = 0 THEN 0
            ELSE ROUND((COUNT(t.id) FILTER (WHERE t.completada = TRUE)::DECIMAL / COUNT(t.id)) * 100, 2)
       END as porcentaje_completado
FROM actividades a
LEFT JOIN tareas t ON t.actividad_id = a.id
LEFT JOIN usuarios u ON a.usuario_id = u.id
LEFT JOIN categorias c ON a.categoria_id = c.id
GROUP BY a.id, a.titulo, a.descripcion, a.estado, a.prioridad, a.fecha_inicio, a.fecha_fin, a.color, a.fecha_creacion, u.username, c.nombre;

COMMIT;

-- ============================================================================
-- VERIFICACIÓN
-- ============================================================================

SELECT 'DESPUÉS DE MIGRACIÓN - Tablas existentes:' as info;
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

SELECT 'Total Actividades' as metrica, COUNT(*)::TEXT as valor FROM actividades
UNION ALL
SELECT 'Total Tareas' as metrica, COUNT(*)::TEXT as valor FROM tareas;

SELECT '¡MIGRACIÓN COMPLETADA EXITOSAMENTE!' as resultado;

