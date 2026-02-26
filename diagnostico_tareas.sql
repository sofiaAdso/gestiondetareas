-- ============================================
-- SCRIPT DE DIAGNÓSTICO Y SOLUCIÓN
-- Sistema de Gestión de Tareas
-- ============================================

-- 1. VERIFICAR TAREAS EXISTENTES
SELECT
    t.id,
    t.titulo,
    t.estado,
    t.activo,
    t.usuario_id,
    u.username as usuario,
    c.nombre as categoria
FROM tareas t
LEFT JOIN usuarios u ON t.usuario_id = u.id
LEFT JOIN categorias c ON t.categoria_id = c.id
ORDER BY t.id DESC;

-- 2. CONTAR TAREAS ACTIVAS
SELECT COUNT(*) as total_tareas_activas
FROM tareas
WHERE activo = true;

-- 3. CONTAR TAREAS INACTIVAS
SELECT COUNT(*) as total_tareas_inactivas
FROM tareas
WHERE activo = false;

-- 4. VER USUARIOS DEL SISTEMA
SELECT id, username, rol FROM usuarios ORDER BY id;

-- 5. VER CATEGORÍAS DISPONIBLES
SELECT id, nombre FROM categorias ORDER BY id;

-- ============================================
-- SOLUCIONES COMUNES
-- ============================================

-- SI NO HAY TAREAS: Insertar tarea de ejemplo
-- NOTA: Ajusta usuario_id (1) según tu ID de usuario
INSERT INTO tareas (titulo, descripcion, prioridad, estado, fecha_inicio, fecha_vencimiento, usuario_id, categoria_id, activo)
VALUES (
    'Tarea de Ejemplo',
    'Esta es una tarea de prueba creada para verificar el sistema',
    'Media',
    'Pendiente',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '7 days',
    1,  -- Cambia este ID por el de tu usuario
    1,  -- Cambia este ID por el de una categoría existente
    true
);

-- SI LAS TAREAS ESTÁN INACTIVAS: Activar todas las tareas
-- Ejecuta esto solo si confirmas que tus tareas tienen activo = false
-- UPDATE tareas SET activo = true;

-- Activar una tarea específica por ID
-- UPDATE tareas SET activo = true WHERE id = 1;

-- ============================================
-- VERIFICACIÓN FINAL
-- ============================================

-- Después de hacer cambios, ejecuta esto para verificar:
SELECT
    'Tareas Activas' as tipo,
    COUNT(*) as cantidad
FROM tareas
WHERE activo = true
UNION ALL
SELECT
    'Tareas Inactivas' as tipo,
    COUNT(*) as cantidad
FROM tareas
WHERE activo = false
UNION ALL
SELECT
    'Total Tareas' as tipo,
    COUNT(*) as cantidad
FROM tareas;

-- Ver las últimas 5 tareas activas con todos sus detalles
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.prioridad,
    t.estado,
    t.fecha_inicio,
    t.fecha_vencimiento,
    u.username as usuario,
    u.rol,
    c.nombre as categoria,
    t.activo
FROM tareas t
LEFT JOIN usuarios u ON t.usuario_id = u.id
LEFT JOIN categorias c ON t.categoria_id = c.id
WHERE t.activo = true
ORDER BY t.id DESC
LIMIT 5;

