-- Script para crear la tabla de actividades y modificar tareas
-- Base de datos PostgreSQL

-- Crear tabla de actividades
CREATE TABLE IF NOT EXISTS actividades (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    prioridad VARCHAR(20) DEFAULT 'Media',
    estado VARCHAR(20) DEFAULT 'En Progreso',
    color VARCHAR(7) DEFAULT '#3498db',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_actividad_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE CASCADE
);

-- Agregar columna actividad_id a la tabla tareas si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'tareas' AND column_name = 'actividad_id'
    ) THEN
        ALTER TABLE tareas ADD COLUMN actividad_id INTEGER;
        ALTER TABLE tareas ADD CONSTRAINT fk_tarea_actividad
            FOREIGN KEY (actividad_id)
            REFERENCES actividades(id)
            ON DELETE SET NULL;
    END IF;
END $$;

-- Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_actividades_usuario ON actividades(usuario_id);
CREATE INDEX IF NOT EXISTS idx_tareas_actividad ON tareas(actividad_id);

-- Comentarios para documentación
COMMENT ON TABLE actividades IS 'Tabla de actividades que agrupan múltiples tareas';
COMMENT ON COLUMN actividades.id IS 'Identificador único de la actividad';
COMMENT ON COLUMN actividades.usuario_id IS 'ID del usuario propietario';
COMMENT ON COLUMN actividades.titulo IS 'Título de la actividad';
COMMENT ON COLUMN actividades.descripcion IS 'Descripción detallada de la actividad';
COMMENT ON COLUMN actividades.fecha_inicio IS 'Fecha de inicio de la actividad';
COMMENT ON COLUMN actividades.fecha_fin IS 'Fecha de finalización de la actividad';
COMMENT ON COLUMN actividades.prioridad IS 'Nivel de prioridad: Baja, Media, Alta';
COMMENT ON COLUMN actividades.estado IS 'Estado actual de la actividad';
COMMENT ON COLUMN actividades.color IS 'Color para identificar visualmente la actividad';
COMMENT ON COLUMN actividades.fecha_creacion IS 'Fecha y hora de creación';

