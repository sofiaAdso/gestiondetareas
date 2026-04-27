package com.sena.gestion.controller;

import com.sena.gestion.repository.Conexion;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet para diagnosticar problemas con la creación de actividades
 */
@WebServlet("/DiagnosticoServlet")
public class DiagnosticoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang='es'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Diagnóstico de Actividades</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }");
        out.println(".container { background: white; padding: 30px; border-radius: 10px; max-width: 900px; margin: 0 auto; }");
        out.println("h1 { color: #667eea; border-bottom: 3px solid #667eea; padding-bottom: 10px; }");
        out.println("h2 { color: #333; margin-top: 30px; }");
        out.println(".success { color: green; font-weight: bold; }");
        out.println(".error { color: red; font-weight: bold; }");
        out.println(".warning { color: orange; font-weight: bold; }");
        out.println("table { width: 100%; border-collapse: collapse; margin: 15px 0; }");
        out.println("th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }");
        out.println("th { background: #667eea; color: white; }");
        out.println(".btn { background: #667eea; color: white; padding: 10px 20px; ");
        out.println("text-decoration: none; border-radius: 5px; display: inline-block; margin: 10px 5px; }");
        out.println(".btn:hover { background: #5568d3; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1> Diagnóstico del Sistema de Actividades</h1>");

        try (Connection conn = Conexion.getConexion()) {
            if (conn != null) {
                out.println("<p class='success'>✓ Conexión a la base de datos: EXITOSA</p>");

                // 1. Verificar tabla actividades
                out.println("<h2>1. Tabla Actividades</h2>");
                verificarTablaActividades(conn, out);

                // 2. Verificar usuarios
                out.println("<h2>2. Usuarios del Sistema</h2>");
                verificarUsuarios(conn, out);

                // 3. Verificar actividades existentes
                out.println("<h2>3. Actividades Existentes</h2>");
                verificarActividades(conn, out);

                // 4. Prueba de inserción
                out.println("<h2>4. Prueba de Creación</h2>");
                pruebaCreacion(conn, out);

            } else {
                out.println("<p class='error'>✗ Error: No se pudo conectar a la base de datos</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }

        out.println("<br><br>");
        out.println("<a href='dashboard.jsp' class='btn'>Volver al Dashboard</a>");
        out.println("<a href='ActividadServlet?accion=listar' class='btn'>Ver Actividades</a>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }

    private void verificarTablaActividades(Connection conn, PrintWriter out) throws SQLException {
        String sql = "SELECT column_name, data_type, is_nullable " +
                     "FROM information_schema.columns " +
                     "WHERE table_name = 'actividades' " +
                     "ORDER BY ordinal_position";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            out.println("<table>");
            out.println("<tr><th>Columna</th><th>Tipo</th><th>Nullable</th></tr>");

            boolean existe = false;
            while (rs.next()) {
                existe = true;
                out.println("<tr>");
                out.println("<td>" + rs.getString("column_name") + "</td>");
                out.println("<td>" + rs.getString("data_type") + "</td>");
                out.println("<td>" + rs.getString("is_nullable") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");

            if (existe) {
                out.println("<p class='success'>✓ La tabla 'actividades' existe con estructura correcta</p>");
            } else {
                out.println("<p class='error'>✗ La tabla 'actividades' NO EXISTE</p>");
                out.println("<p class='warning'>⚠ Necesitas ejecutar el script: crear_tabla_actividades.sql</p>");
            }
        }
    }

    private void verificarUsuarios(Connection conn, PrintWriter out) throws SQLException {
        String sql = "SELECT id, username, email, rol FROM usuarios LIMIT 10";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            out.println("<table>");
            out.println("<tr><th>ID</th><th>Username</th><th>Email</th><th>Rol</th></tr>");

            boolean hayUsuarios = false;
            while (rs.next()) {
                hayUsuarios = true;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("username") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getString("rol") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");

            if (hayUsuarios) {
                out.println("<p class='success'>✓ Hay usuarios registrados en el sistema</p>");
            } else {
                out.println("<p class='error'>✗ NO hay usuarios en el sistema</p>");
            }
        }
    }

    private void verificarActividades(Connection conn, PrintWriter out) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM actividades";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int total = rs.getInt("total");
                out.println("<p>Total de actividades: <strong>" + total + "</strong></p>");

                if (total > 0) {
                    // Mostrar algunas actividades
                    String sqlActividades = "SELECT id, titulo, estado, usuario_id, fecha_creacion " +
                                           "FROM actividades ORDER BY fecha_creacion DESC LIMIT 5";
                    try (PreparedStatement ps2 = conn.prepareStatement(sqlActividades);
                         ResultSet rs2 = ps2.executeQuery()) {

                        out.println("<table>");
                        out.println("<tr><th>ID</th><th>Título</th><th>Estado</th><th>Usuario ID</th><th>Fecha</th></tr>");

                        while (rs2.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rs2.getInt("id") + "</td>");
                            out.println("<td>" + rs2.getString("titulo") + "</td>");
                            out.println("<td>" + rs2.getString("estado") + "</td>");
                            out.println("<td>" + rs2.getInt("usuario_id") + "</td>");
                            out.println("<td>" + rs2.getTimestamp("fecha_creacion") + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");
                    }
                }
            }
        }
    }

    private void pruebaCreacion(Connection conn, PrintWriter out) throws SQLException {
        out.println("<p>Intentando crear una actividad de prueba...</p>");

        // Obtener el primer usuario disponible
        String sqlUsuario = "SELECT id FROM usuarios LIMIT 1";
        int usuarioId = 0;

        try (PreparedStatement ps = conn.prepareStatement(sqlUsuario);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                usuarioId = rs.getInt("id");
            }
        }

        if (usuarioId == 0) {
            out.println("<p class='error'>✗ No se puede hacer la prueba: no hay usuarios en el sistema</p>");
            return;
        }

        String sql = "INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, " +
                     "prioridad, estado, color) VALUES (?, ?, ?, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', " +
                     "'Media', 'En Progreso', '#3498db') RETURNING id";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setString(2, "Actividad de Prueba - Diagnóstico");
            ps.setString(3, "Esta es una actividad creada automáticamente para probar el sistema");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int newId = rs.getInt(1);
                out.println("<p class='success'>✓ ÉXITO: Se creó una actividad de prueba con ID: " + newId + "</p>");

                // Eliminar la actividad de prueba
                String sqlDelete = "DELETE FROM actividades WHERE id = ?";
                try (PreparedStatement psDelete = conn.prepareStatement(sqlDelete)) {
                    psDelete.setInt(1, newId);
                    psDelete.executeUpdate();
                    out.println("<p class='success'>✓ Actividad de prueba eliminada correctamente</p>");
                }
            }
        } catch (SQLException e) {
            out.println("<p class='error'>✗ ERROR al crear actividad: " + e.getMessage() + "</p>");
            out.println("<p class='warning'>Código de error SQL: " + e.getSQLState() + "</p>");
        }
    }
}

