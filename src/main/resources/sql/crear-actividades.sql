-- ==========================================
-- SCRIPT DE CREACIÓN - TABLA ACTIVIDADES
-- ==========================================

-- Si la tabla ya existe, eliminarla (opcional - comentar si no deseas)
-- DROP TABLE IF EXISTS actividades CASCADE;

-- Crear tabla de actividades
CREATE TABLE IF NOT EXISTS actividades (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    prioridad VARCHAR(50) DEFAULT 'Media',
    estado VARCHAR(50) DEFAULT 'Pendiente',
    color VARCHAR(7),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Clave foránea hacia la tabla de usuarios (asume que existe)
    CONSTRAINT fk_actividades_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON DELETE CASCADE
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_actividades_usuario_id ON actividades(usuario_id);
CREATE INDEX IF NOT EXISTS idx_actividades_estado ON actividades(estado);
CREATE INDEX IF NOT EXISTS idx_actividades_fecha_fin ON actividades(fecha_fin);

-- Insertar algunas actividades de ejemplo (opcional)
-- INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
-- VALUES
-- (1, 'Mantenimiento de Servidores', 'Realizar mantenimiento preventivo de los servidores principales', '2026-05-05', '2026-05-10', 'Alta', 'Pendiente', '#FF6B6B'),
-- (1, 'Actualización de Base de Datos', 'Actualizar la versión de PostgreSQL a la última versión LTS', '2026-05-08', '2026-05-15', 'Media', 'Pendiente', '#4ECDC4'),
-- (1, 'Capacitación de Usuarios', 'Capacitar a los nuevos usuarios del sistema de gestión de tareas', '2026-05-10', '2026-05-20', 'Media', 'Pendiente', '#FFE66D');

