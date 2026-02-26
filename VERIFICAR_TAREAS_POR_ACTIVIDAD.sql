-- ============================================
-- SCRIPT DE VERIFICACIÓN Y DIAGNÓSTICO
-- Sistema de Gestión de Actividades y Tareas
-- ============================================

-- ============================================
-- PASO 1: VERIFICAR ESTRUCTURA DE TABLAS
-- ============================================

-- 1.1 Ver estructura de la tabla ACTIVIDADES
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'actividades'
ORDER BY ordinal_position;

-- 1.2 Ver estructura de la tabla TAREAS
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'tareas'
ORDER BY ordinal_position;

-- ============================================
-- PASO 2: VERIFICAR RELACIONES (FOREIGN KEYS)
-- ============================================

SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.table_name IN ('tareas', 'actividades')
AND tc.constraint_type = 'FOREIGN KEY';

-- ============================================
-- PASO 3: VERIFICAR DATOS EXISTENTES
-- ============================================

-- 3.1 Contar actividades por usuario
SELECT
    u.id AS usuario_id,
    u.username,
    COUNT(a.id) AS total_actividades
FROM usuarios u
LEFT JOIN actividades a ON u.id = a.usuario_id
GROUP BY u.id, u.username
ORDER BY total_actividades DESC;

-- 3.2 Contar tareas por actividad
SELECT
    a.id AS actividad_id,
    a.titulo AS actividad,
    a.estado AS estado_actividad,
    COUNT(t.id) AS total_tareas,
    COUNT(CASE WHEN t.estado = 'Completada' THEN 1 END) AS tareas_completadas,
    u.username AS usuario_asignado
FROM actividades a
LEFT JOIN tareas t ON a.id = t.actividad_id
LEFT JOIN usuarios u ON a.usuario_id = u.id
GROUP BY a.id, a.titulo, a.estado, u.username
ORDER BY a.id DESC;

-- 3.3 Ver tareas sin actividad asignada (ERROR)
SELECT
    t.id,
    t.titulo,
    t.actividad_id
FROM tareas t
WHERE t.actividad_id IS NULL;

-- Si hay tareas sin actividad, necesitas corregirlas

-- ============================================
-- PASO 4: DIAGNÓSTICO ESPECÍFICO
-- ============================================

-- 4.1 Ver todas las actividades con sus tareas
SELECT
    a.id AS actividad_id,
    a.titulo AS actividad,
    a.estado AS estado_act,
    a.prioridad AS prioridad_act,
    t.id AS tarea_id,
    t.titulo AS tarea,
    t.estado AS estado_tarea,
    t.prioridad AS prioridad_tarea,
    t.fecha_vencimiento
FROM actividades a
LEFT JOIN tareas t ON a.id = t.actividad_id
ORDER BY a.id DESC, t.id DESC;

-- 4.2 Actividades sin tareas (vacías)
SELECT
    a.id,
    a.titulo,
    a.estado,
    a.fecha_inicio,
    a.fecha_fin
FROM actividades a
LEFT JOIN tareas t ON a.id = t.actividad_id
WHERE t.id IS NULL
ORDER BY a.id DESC;

-- ============================================
-- PASO 5: PRUEBAS DE CONSULTA (COMO EN EL CÓDIGO)
-- ============================================

-- Simular la consulta que hace TareaDao.listarPorActividad()
-- Reemplaza el '1' con el ID de una actividad real
SELECT
    t.*,
    a.titulo AS nombre_act
FROM tareas t
INNER JOIN actividades a ON t.actividad_id = a.id
WHERE t.actividad_id = 1  -- Cambia este número por un ID de actividad real
ORDER BY t.id DESC;

-- ============================================
-- PASO 6: DATOS DE PRUEBA (SI NO TIENES DATOS)
-- ============================================

-- 6.1 Verificar si tienes usuarios
SELECT COUNT(*) AS total_usuarios FROM usuarios;

-- 6.2 Verificar si tienes actividades
SELECT COUNT(*) AS total_actividades FROM actividades;

-- 6.3 Verificar si tienes tareas
SELECT COUNT(*) AS total_tareas FROM tareas;

-- ============================================
-- SOLUCIÓN 1: Si NO existe la columna actividad_id en tareas
-- ============================================

-- Verificar si existe la columna
SELECT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_name = 'tareas'
    AND column_name = 'actividad_id'
) AS columna_existe;

-- Si NO existe, ejecuta esto:
/*
ALTER TABLE tareas ADD COLUMN actividad_id INTEGER;

-- Agregar foreign key
ALTER TABLE tareas
ADD CONSTRAINT fk_tarea_actividad
FOREIGN KEY (actividad_id)
REFERENCES actividades(id)
ON DELETE CASCADE;

-- Crear índice para mejorar rendimiento
CREATE INDEX idx_tareas_actividad ON tareas(actividad_id);
*/

-- ============================================
-- SOLUCIÓN 2: Si tienes tareas sin actividad_id
-- ============================================

-- Opción A: Crear una actividad "General" para cada usuario y asignar sus tareas
/*
DO $$
DECLARE
    usuario_rec RECORD;
    actividad_general_id INT;
BEGIN
    FOR usuario_rec IN
        SELECT DISTINCT u.id, u.username
        FROM usuarios u
        WHERE EXISTS (
            SELECT 1 FROM tareas t
            WHERE t.usuario_id = u.id
            AND t.actividad_id IS NULL
        )
    LOOP
        -- Verificar si ya existe una actividad "Tareas Generales" para este usuario
        SELECT id INTO actividad_general_id
        FROM actividades
        WHERE usuario_id = usuario_rec.id
        AND titulo = 'Tareas Generales'
        LIMIT 1;

        -- Si no existe, crearla
        IF actividad_general_id IS NULL THEN
            INSERT INTO actividades (
                usuario_id,
                titulo,
                descripcion,
                fecha_inicio,
                fecha_fin,
                prioridad,
                estado,
                color
            ) VALUES (
                usuario_rec.id,
                'Tareas Generales',
                'Actividad general para tareas sin categorizar',
                CURRENT_DATE,
                CURRENT_DATE + INTERVAL '30 days',
                'Media',
                'En Progreso',
                '#6c757d'
            ) RETURNING id INTO actividad_general_id;

            RAISE NOTICE 'Actividad General creada para usuario %: ID %',
                usuario_rec.username, actividad_general_id;
        END IF;

        -- Asignar tareas sin actividad a esta actividad general
        UPDATE tareas
        SET actividad_id = actividad_general_id
        WHERE usuario_id = usuario_rec.id
        AND actividad_id IS NULL;

        RAISE NOTICE 'Tareas asignadas a actividad % para usuario %',
            actividad_general_id, usuario_rec.username;
    END LOOP;
END $$;
*/

-- ============================================
-- SOLUCIÓN 3: Crear datos de prueba completos
-- ============================================

/*
-- Paso 1: Crear una actividad de prueba (ajusta el usuario_id)
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
VALUES (
    1,  -- Cambia esto por tu ID de usuario
    'Proyecto de Arquitectura',
    'Proyecto para diseñar la arquitectura del sistema',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '60 days',
    'Alta',
    'En Progreso',
    '#667eea'
) RETURNING id;  -- Anota el ID que retorna

-- Paso 2: Crear tareas para esa actividad (usa el ID que obtuviste arriba)
INSERT INTO tareas (titulo, descripcion, prioridad, estado, fecha_inicio, fecha_vencimiento, actividad_id, usuario_id, categoria_id, completada, notas)
VALUES
(
    'Diseñar diagrama de clases',
    'Crear el diagrama de clases completo del sistema',
    'Alta',
    'En Progreso',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '7 days',
    1,  -- Reemplaza con el ID de la actividad creada
    1,  -- Reemplaza con tu ID de usuario
    1,  -- Reemplaza con un ID de categoría válido
    false,
    'Usar UML para el diagrama'
),
(
    'Documentar API REST',
    'Documentar todos los endpoints de la API',
    'Media',
    'Pendiente',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '10 days',
    1,  -- Reemplaza con el ID de la actividad creada
    1,  -- Reemplaza con tu ID de usuario
    1,  -- Reemplaza con un ID de categoría válido
    false,
    'Usar Swagger para documentación'
);
*/

-- ============================================
-- VERIFICACIÓN FINAL
-- ============================================

-- Resumen completo del sistema
SELECT
    'Usuarios' AS entidad,
    COUNT(*) AS cantidad
FROM usuarios
UNION ALL
SELECT
    'Actividades' AS entidad,
    COUNT(*) AS cantidad
FROM actividades
UNION ALL
SELECT
    'Tareas' AS entidad,
    COUNT(*) AS cantidad
FROM tareas
UNION ALL
SELECT
    'Tareas SIN Actividad (ERROR)' AS entidad,
    COUNT(*) AS cantidad
FROM tareas
WHERE actividad_id IS NULL;

-- ============================================
-- NOTAS IMPORTANTES
-- ============================================

/*
✅ PARA QUE EL SISTEMA FUNCIONE CORRECTAMENTE:

1. La tabla 'actividades' debe existir con estructura correcta
2. La tabla 'tareas' debe tener la columna 'actividad_id' (INTEGER, NOT NULL)
3. Debe existir FK entre tareas.actividad_id → actividades.id
4. TODAS las tareas deben tener un actividad_id válido (no NULL)
5. El código Java ya está implementado correctamente:
   - ActividadServlet.manejarVerDetalle() obtiene la actividad
   - TareaDao.listarPorActividad() obtiene las tareas
   - ver-actividad.jsp muestra las tareas

📋 FLUJO DE DATOS:
   Usuario hace clic en "Ver" actividad
   → ActividadServlet recibe accion=ver&id=X
   → Llama a actividadDao.obtenerPorId(X)
   → Llama a tareaDao.listarPorActividad(X)
   → Asigna las tareas a la actividad con setTareas()
   → Envía al JSP ver-actividad.jsp
   → JSP muestra la actividad y sus tareas

🔧 SI NO VES TAREAS:
   1. Verifica que las tareas tengan actividad_id correcto
   2. Verifica que la actividad existe en la BD
   3. Revisa los logs del servidor (System.out en TareaDao)
   4. Ejecuta la consulta manual de PASO 5
*/

