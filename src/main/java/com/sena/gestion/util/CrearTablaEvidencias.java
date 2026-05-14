package com.sena.gestion.util;

import com.sena.gestion.config.Conexion;
import java.sql.*;
import java.util.logging.Logger;

public class CrearTablaEvidencias {
    private static final Logger LOGGER = Logger.getLogger(CrearTablaEvidencias.class.getName());

    public static void crearTabla() {
        String sqlCrear = "CREATE TABLE IF NOT EXISTS evidencias (\n" +
                "    id SERIAL PRIMARY KEY,\n" +
                "    actividad_id INTEGER NOT NULL,\n" +
                "    tarea_id INTEGER,\n" +
                "    usuario_id INTEGER NOT NULL,\n" +
                "    nombre_archivo VARCHAR(255) NOT NULL,\n" +
                "    archivo_data BYTEA,\n" +
                "    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n" +
                "    CONSTRAINT fk_evidencias_actividad\n" +
                "        FOREIGN KEY (actividad_id)\n" +
                "        REFERENCES actividades(id)\n" +
                "        ON DELETE CASCADE,\n" +
                "    CONSTRAINT fk_evidencias_tarea\n" +
                "        FOREIGN KEY (tarea_id)\n" +
                "        REFERENCES tareas(id)\n" +
                "        ON DELETE CASCADE,\n" +
                "    CONSTRAINT fk_evidencias_usuario\n" +
                "        FOREIGN KEY (usuario_id)\n" +
                "        REFERENCES usuarios(id)\n" +
                "        ON DELETE CASCADE\n" +
                ")";

        String[] indices = {
                "CREATE INDEX IF NOT EXISTS idx_evidencias_actividad_id ON evidencias(actividad_id)",
                "CREATE INDEX IF NOT EXISTS idx_evidencias_tarea_id ON evidencias(tarea_id)",
                "CREATE INDEX IF NOT EXISTS idx_evidencias_usuario_id ON evidencias(usuario_id)"
        };

        try (Connection conn = Conexion.getConexion();
             Statement stmt = conn.createStatement()) {

            // Crear tabla
            stmt.execute(sqlCrear);
            System.out.println("✓ Tabla 'evidencias' creada o verificada");

            // Crear índices
            for (String indice : indices) {
                stmt.execute(indice);
            }
            System.out.println("✓ Índices creados");

        } catch (SQLException e) {
            System.err.println("✗ Error al crear tabla evidencias: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        crearTabla();
    }
}

