-- ============================================================================
-- SCRIPT: Migración de Estructura - Tareas → Actividades con Tareas Hijas
-- Descripción: Renombra la tabla actual 'tareas' a 'actividades' y crea
--              una nueva tabla 'tareas' que depende de actividades
-- Fecha: 19/02/2026
-- ============================================================================

-- IMPORTANTE: Hacer BACKUP antes de ejecutar
-- pg_dump -U postgres gestion_tareas > backup_antes_migracion.sql

BEGIN;

-- ============================================================================
-- PASO 1: Renombrar la tabla actual 'tareas' a 'actividades'
-- ============================================================================

-- 1.1 Renombrar la tabla
ALTER TABLE tareas RENAME TO actividades;

-- 1.2 Renombrar la secuencia del ID
ALTER SEQUENCE tareas_id_seq RENAME TO actividades_id_seq;

-- 1.3 Renombrar índices si existen
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tareas_usuario_id') THEN
        ALTER INDEX idx_tareas_usuario_id RENAME TO idx_actividades_usuario_id;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tareas_categoria_id') THEN
        ALTER INDEX idx_tareas_categoria_id RENAME TO idx_actividades_categoria_id;
    END IF;
END $$;

-- 1.4 Eliminar la columna actividad_id de la nueva tabla actividades (ya no se usa)
ALTER TABLE actividades DROP COLUMN IF EXISTS actividad_id;

RAISE NOTICE 'Paso 1 completado: Tabla tareas renombrada a actividades';

-- ============================================================================
-- PASO 2: Crear la nueva tabla 'tareas' que depende de actividades
-- ============================================================================

CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
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
    CONSTRAINT chk_prioridad CHECK (prioridad IN ('Baja', 'Media', 'Alta')),
    CONSTRAINT chk_estado CHECK (estado IN ('Pendiente', 'En Proceso', 'Completada')),
    CONSTRAINT chk_fechas CHECK (fecha_vencimiento >= fecha_inicio)
);

-- Crear índices para mejor rendimiento
CREATE INDEX idx_tareas_actividad_id ON tareas(actividad_id);
CREATE INDEX idx_tareas_estado ON tareas(estado);
CREATE INDEX idx_tareas_fecha_vencimiento ON tareas(fecha_vencimiento);

-- Comentarios en la tabla
COMMENT ON TABLE tareas IS 'Tareas individuales que pertenecen a actividades';
COMMENT ON COLUMN tareas.actividad_id IS 'ID de la actividad padre (obligatorio)';

RAISE NOTICE 'Paso 2 completado: Nueva tabla tareas creada';

-- ============================================================================
-- PASO 3: Migrar datos - Crear una tarea por cada actividad antigua
-- ============================================================================

-- Para cada actividad (antigua tarea), crear una tarea principal con el mismo contenido
INSERT INTO tareas (
    titulo,
    descripcion,
    prioridad,
    estado,
    fecha_inicio,
    fecha_vencimiento,
    actividad_id,
    completada,
    fecha_creacion
)
SELECT
    titulo,
    descripcion,
    prioridad,
    estado,
    fecha_inicio,
    fecha_vencimiento,
    id,  -- La actividad es padre de su propia tarea principal
    CASE WHEN estado = 'Completada' THEN TRUE ELSE FALSE END,
    COALESCE(fecha_creacion, CURRENT_TIMESTAMP)
FROM actividades;

RAISE NOTICE 'Paso 3 completado: Tareas principales creadas desde actividades';

-- ============================================================================
-- PASO 4: Migrar subtareas existentes (si existen)
-- ============================================================================

-- Si ya existía una tabla de subtareas, migrarlas a la nueva tabla tareas
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
            estado
        )
        SELECT
            titulo,
            descripcion,
            fecha_creacion,
            fecha_vencimiento,
            tarea_id,  -- tarea_id de subtareas se convierte en actividad_id
            completada,
            CASE
                WHEN completada THEN 'Completada'
                ELSE 'Pendiente'
            END
        FROM subtareas;

        RAISE NOTICE 'Subtareas migradas a la nueva tabla tareas';

        -- Opcional: Eliminar tabla subtareas antigua
        -- DROP TABLE subtareas;
    END IF;
END $$;

-- ============================================================================
-- PASO 5: Actualizar nombres de columnas en actividades para claridad
-- ============================================================================

-- Renombrar usuario_id a encargado_id (opcional, para mejor semántica)
-- ALTER TABLE actividades RENAME COLUMN usuario_id TO encargado_id;

RAISE NOTICE 'Paso 5 completado: Estructura actualizada';

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
    'Tareas nuevas (incluye principales + antiguas subtareas)' as tabla,
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
RAISE NOTICE '========================================';

-- ============================================================================
-- PASO 7: Crear vistas útiles (opcional)
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
    a.fecha_vencimiento,
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
         a.fecha_inicio, a.fecha_vencimiento, u.username, c.nombre;

COMMENT ON VIEW vista_actividades_progreso IS 'Vista con actividades y su progreso basado en tareas';

RAISE NOTICE 'Vista vista_actividades_progreso creada';

COMMIT;

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT 'MIGRACIÓN COMPLETADA' as resultado;

-- Mostrar estadísticas
SELECT
    'Total Actividades' as metrica,
    COUNT(*) as valor
FROM actividades

UNION ALL

SELECT
    'Total Tareas' as metrica,
    COUNT(*) as valor
FROM tareas

UNION ALL

SELECT
    'Promedio Tareas por Actividad' as metrica,
    ROUND(AVG(cantidad_tareas), 2) as valor
FROM (
    SELECT actividad_id, COUNT(*) as cantidad_tareas
    FROM tareas
    GROUP BY actividad_id
) subconsulta;

-- ============================================================================
-- NOTAS IMPORTANTES POST-MIGRACIÓN
-- ============================================================================

/*
CAMBIOS EN EL CÓDIGO JAVA NECESARIOS:

1. ActividadDao y ActividadServlet:
   - Ya no necesitan buscar/crear tareas dentro de actividad
   - Se enfocan solo en gestión de actividades

2. TareaDao (NUEVO) y TareaServlet (NUEVO):
   - Crear DAO para la nueva tabla 'tareas'
   - Todas las operaciones de tareas ahora requieren actividad_id

3. Modelo Actividad:
   - Eliminar campo actividad_id (ya no existe)
   - Agregar métodos para obtener lista de tareas hijas

4. Modelo Tarea (NUEVO):
   - Crear modelo con actividad_id obligatorio
   - Campos: id, titulo, descripcion, prioridad, estado, fechas, actividad_id, completada

5. Vistas JSP:
   - Actualizar formulario de tareas para requerir selección de actividad
   - Mostrar tareas dentro de cada actividad
   - Vista de detalle de actividad con lista de tareas

6. Relaciones:
   - ANTES: Usuario → Tarea (directa)
   - DESPUÉS: Usuario → Actividad → Tarea (jerárquica)

ROLLBACK (Si algo sale mal):
   - Restaurar desde el backup
   - pg_dump backup_antes_migracion.sql

VENTAJAS:
   ✓ Mejor organización jerárquica
   ✓ Actividades agrupan múltiples tareas
   ✓ Separación clara de conceptos
   ✓ Más flexible para crecer
*/

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================

