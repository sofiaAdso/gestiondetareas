-- ============================================================
-- SCRIPT DE INICIALIZACIÓN - SISTEMA GESTIÓN DE TAREAS (SENA)
-- Base de datos: Gestiondetareas
-- Motor: PostgreSQL
-- ============================================================

SET search_path TO public;

-- ============================================================
-- 1. TABLA: usuarios
-- ============================================================
CREATE TABLE IF NOT EXISTS usuarios (
                                        id                SERIAL          PRIMARY KEY,
                                        username          VARCHAR(100)    NOT NULL UNIQUE,
    email             VARCHAR(150)    NOT NULL UNIQUE,
    password          VARCHAR(255)    NOT NULL,
    rol               VARCHAR(50)     NOT NULL DEFAULT 'Usuario',
    fecha_inicio      DATE,
    fecha_vencimiento DATE,
    fecha_creacion    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
    );

CREATE INDEX IF NOT EXISTS idx_usuarios_username ON usuarios(username);
CREATE INDEX IF NOT EXISTS idx_usuarios_email    ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_usuarios_rol      ON usuarios(rol);

-- ============================================================
-- 2. TABLA: categorias
--    ✅ CORREGIDO: Agregado UNIQUE en nombre para soportar ON CONFLICT
-- ============================================================
CREATE TABLE IF NOT EXISTS categorias (
                                          id             SERIAL          PRIMARY KEY,
                                          nombre         VARCHAR(100)    NOT NULL UNIQUE,   -- 👈 UNIQUE agregado
    descripcion    TEXT,
    activo         BOOLEAN         NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
    );

CREATE INDEX IF NOT EXISTS idx_categorias_activo ON categorias(activo);

-- ============================================================
-- 3. TABLA: actividades
-- ============================================================
CREATE TABLE IF NOT EXISTS actividades (
                                           id                  SERIAL          PRIMARY KEY,
                                           usuario_id          INTEGER         NOT NULL,
                                           titulo              VARCHAR(255)    NOT NULL,
    descripcion         TEXT,
    fecha_inicio        DATE,
    fecha_fin           DATE,
    prioridad           VARCHAR(50)     DEFAULT 'Media',
    estado              VARCHAR(50)     DEFAULT 'Pendiente',
    color               VARCHAR(7),
    fecha_creacion      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_actividades_usuario
    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id)
    ON DELETE CASCADE
    );

CREATE INDEX IF NOT EXISTS idx_actividades_usuario_id ON actividades(usuario_id);
CREATE INDEX IF NOT EXISTS idx_actividades_estado     ON actividades(estado);
CREATE INDEX IF NOT EXISTS idx_actividades_fecha_fin  ON actividades(fecha_fin);

-- ============================================================
-- 4. TABLA: tareas
-- ============================================================
CREATE TABLE IF NOT EXISTS tareas (
                                      id                SERIAL          PRIMARY KEY,
                                      titulo            VARCHAR(255)    NOT NULL,
    descripcion       TEXT,
    prioridad         VARCHAR(50)     DEFAULT 'Media',
    estado            VARCHAR(50)     DEFAULT 'Pendiente',
    fecha_inicio      DATE,
    fecha_vencimiento DATE,
    actividad_id      INTEGER,
    usuario_id        INTEGER,
    categoria_id      INTEGER,
    completada        BOOLEAN         DEFAULT FALSE,
    notas             TEXT,
    fecha_creacion    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tareas_actividad
    FOREIGN KEY (actividad_id)
    REFERENCES actividades(id)
    ON DELETE SET NULL,

    CONSTRAINT fk_tareas_usuario
    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id)
    ON DELETE SET NULL,

    CONSTRAINT fk_tareas_categoria
    FOREIGN KEY (categoria_id)
    REFERENCES categorias(id)
    ON DELETE SET NULL
    );

CREATE INDEX IF NOT EXISTS idx_tareas_actividad_id ON tareas(actividad_id);
CREATE INDEX IF NOT EXISTS idx_tareas_usuario_id   ON tareas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_tareas_categoria_id ON tareas(categoria_id);
CREATE INDEX IF NOT EXISTS idx_tareas_estado       ON tareas(estado);
CREATE INDEX IF NOT EXISTS idx_tareas_completada   ON tareas(completada);

-- ============================================================
-- 5. TABLA: subtareas
-- ============================================================
CREATE TABLE IF NOT EXISTS subtareas (
                                         id             SERIAL          PRIMARY KEY,
                                         tarea_id       INTEGER         NOT NULL,
                                         titulo         VARCHAR(255)    NOT NULL,
    descripcion    TEXT,
    completada     BOOLEAN         DEFAULT FALSE,
    fecha_creacion TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_subtareas_tarea
    FOREIGN KEY (tarea_id)
    REFERENCES tareas(id)
    ON DELETE CASCADE
    );

CREATE INDEX IF NOT EXISTS idx_subtareas_tarea_id   ON subtareas(tarea_id);
CREATE INDEX IF NOT EXISTS idx_subtareas_completada ON subtareas(completada);

-- ============================================================
-- 6. TABLA: novedades
-- ============================================================
CREATE TABLE IF NOT EXISTS novedades (
                                         id                  SERIAL          PRIMARY KEY,
                                         regional            VARCHAR(150),
    centro_formacion    VARCHAR(200),
    programa_formacion  VARCHAR(200),
    codigo_programa     VARCHAR(50),
    ambiente            VARCHAR(100),
    localizacion        VARCHAR(150),
    denominacion        VARCHAR(200),
    tipo_ambiente       VARCHAR(50),
    tipo_novedad        VARCHAR(50),
    detalle_novedad     TEXT,
    viabilidad          VARCHAR(20),
    nombre_instructor   VARCHAR(150),
    nombre_coordinador  VARCHAR(150),
    fecha_reporte       DATE            DEFAULT CURRENT_DATE,
    usuario_id          INTEGER,

    CONSTRAINT fk_novedades_usuario
    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id)
    ON DELETE SET NULL
    );

CREATE INDEX IF NOT EXISTS idx_novedades_usuario_id    ON novedades(usuario_id);
CREATE INDEX IF NOT EXISTS idx_novedades_fecha_reporte ON novedades(fecha_reporte);
CREATE INDEX IF NOT EXISTS idx_novedades_tipo_novedad  ON novedades(tipo_novedad);
CREATE INDEX IF NOT EXISTS idx_novedades_viabilidad    ON novedades(viabilidad);

-- ============================================================
-- DATOS INICIALES (SEED)
-- ============================================================

-- Usuario administrador
INSERT INTO usuarios (username, email, password, rol)
SELECT 'admin', 'admin@sena.edu.co', 'admin123', 'Administrador'
    WHERE NOT EXISTS (
    SELECT 1 FROM usuarios WHERE username = 'admin'
);

-- Categorías base
-- ✅ CORREGIDO: ON CONFLICT ahora especifica la columna 'nombre'
INSERT INTO categorias (nombre, descripcion) VALUES
                                                 ('General',        'Tareas de uso general'),
                                                 ('Formación',      'Actividades relacionadas con programas de formación'),
                                                 ('Mantenimiento',  'Tareas de mantenimiento de equipos y ambientes'),
                                                 ('Administrativo', 'Gestión administrativa y documental')
    ON CONFLICT (nombre) DO NOTHING;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================