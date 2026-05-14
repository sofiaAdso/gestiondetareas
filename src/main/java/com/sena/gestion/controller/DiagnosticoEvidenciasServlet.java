package com.sena.gestion.controller;

import com.sena.gestion.config.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DiagnosticoEvidencias")
public class DiagnosticoEvidenciasServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DiagnosticoEvidenciasServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset='UTF-8'><title>Diagnóstico Evidencias</title></head>");
        out.println("<body style='font-family:Arial;margin:20px;'>");
        out.println("<h1>🔧 Diagnóstico de Tabla Evidencias</h1>");

        try (Connection conn = Conexion.getConexion()) {
            out.println("<p>✅ <strong>Conexión a BD:</strong> Exitosa</p>");

            // 1. Verificar si existe la tabla
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables(null, "public", "evidencias", null);

            if (tables.next()) {
                out.println("<p>✅ <strong>Tabla evidencias:</strong> Existe</p>");

                // Listar columnas
                out.println("<h3>Columnas:</h3><ul>");
                ResultSet columns = metaData.getColumns(null, "public", "evidencias", null);
                while (columns.next()) {
                    String colName = columns.getString("COLUMN_NAME");
                    String colType = columns.getString("TYPE_NAME");
                    out.println("<li>" + colName + " (" + colType + ")</li>");
                }
                out.println("</ul>");

                // Contar registros
                String sqlCount = "SELECT COUNT(*) as cnt FROM evidencias";
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(sqlCount)) {
                    if (rs.next()) {
                        int count = rs.getInt("cnt");
                        out.println("<p>📊 <strong>Registros en evidencias:</strong> " + count + "</p>");
                    }
                }
            } else {
                out.println("<p>❌ <strong>Tabla evidencias:</strong> NO EXISTE</p>");
                out.println("<h3>Creando tabla...</h3>");

                // Crear tabla
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

                try (Statement stmt = conn.createStatement()) {
                    stmt.execute(sqlCrear);
                    out.println("<p>✅ Tabla creada exitosamente</p>");

                    // Crear índices
                    String[] indices = {
                        "CREATE INDEX IF NOT EXISTS idx_evidencias_actividad_id ON evidencias(actividad_id)",
                        "CREATE INDEX IF NOT EXISTS idx_evidencias_tarea_id ON evidencias(tarea_id)",
                        "CREATE INDEX IF NOT EXISTS idx_evidencias_usuario_id ON evidencias(usuario_id)"
                    };
                    for (String idx : indices) {
                        stmt.execute(idx);
                    }
                    out.println("<p>✅ Índices creados</p>");
                }
            }

            out.println("<hr><p><a href='ActividadServlet?accion=listar'>← Volver a actividades</a></p>");

        } catch (SQLException e) {
            out.println("<p>❌ <strong>Error:</strong> " + e.getMessage() + "</p>");
            out.println("<pre>" + e.toString() + "</pre>");
            e.printStackTrace();
        }

        out.println("</body></html>");
    }
}

