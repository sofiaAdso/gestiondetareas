-- Script SQL para agregar borrado lógico a las tablas tareas y categorias
-- Este script agrega la columna 'activo' a las tablas para implementar el borrado lógico

-- 1. Agregar columna 'activo' a la tabla tareas
-- Por defecto, todos los registros existentes se marcarán como activos (true)
ALTER TABLE tareas
ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT true NOT NULL;

-- Asegurar que todos los registros existentes estén marcados como activos
UPDATE tareas SET activo = true WHERE activo IS NULL;

-- 2. Agregar columna 'activo' a la tabla categorias
-- Por defecto, todos los registros existentes se marcarán como activos (true)
ALTER TABLE categorias
ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT true NOT NULL;

-- Asegurar que todos los registros existentes estén marcados como activos
UPDATE categorias SET activo = true WHERE activo IS NULL;

-- 3. Crear índices para mejorar el rendimiento de las consultas con filtro de activo
CREATE INDEX IF NOT EXISTS idx_tareas_activo ON tareas(activo);
CREATE INDEX IF NOT EXISTS idx_categorias_activo ON categorias(activo);

-- NOTA: Los registros "eliminados" tendrán activo = false
-- pero permanecerán en la base de datos para mantener el historial

