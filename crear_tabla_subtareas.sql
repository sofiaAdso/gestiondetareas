-- Script para crear la tabla de subtareas
-- Base de datos PostgreSQL

CREATE TABLE IF NOT EXISTS subtareas (
    id SERIAL PRIMARY KEY,
    tarea_id INTEGER NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    completada BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tarea
        FOREIGN KEY (tarea_id)
        REFERENCES tareas(id)
        ON DELETE CASCADE
);

-- Crear índice para mejorar el rendimiento de las consultas
CREATE INDEX IF NOT EXISTS idx_subtareas_tarea_id ON subtareas(tarea_id);

-- Comentarios para documentación
COMMENT ON TABLE subtareas IS 'Tabla de subtareas asociadas a las tareas principales';
COMMENT ON COLUMN subtareas.id IS 'Identificador único de la subtarea';
COMMENT ON COLUMN subtareas.tarea_id IS 'ID de la tarea padre';
COMMENT ON COLUMN subtareas.titulo IS 'Título de la subtarea';
COMMENT ON COLUMN subtareas.descripcion IS 'Descripción detallada de la subtarea';
COMMENT ON COLUMN subtareas.completada IS 'Estado de completitud de la subtarea';
COMMENT ON COLUMN subtareas.fecha_creacion IS 'Fecha y hora de creación de la subtarea';

