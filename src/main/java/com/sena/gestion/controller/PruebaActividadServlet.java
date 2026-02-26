package com.sena.gestion.controller;

import com.sena.gestion.model.Actividad;
import com.sena.gestion.model.Usuario;
import com.sena.gestion.repository.ActividadDao;
import com.sena.gestion.repository.Conexion;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * Servlet de PRUEBA para crear una actividad con debugging completo
 */
@WebServlet("/PruebaActividadServlet")
public class PruebaActividadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        out.println("<!DOCTYPE html>");
        out.println("<html lang='es'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Prueba de Creación de Actividad</title>");
        out.println("<style>");
        out.println("body { font-family: Arial; margin: 20px; background: #f5f5f5; }");
        out.println(".container { background: white; padding: 30px; border-radius: 10px; max-width: 900px; margin: 0 auto; }");
        out.println("h1 { color: #667eea; }");
        out.println(".success { color: green; font-weight: bold; }");
        out.println(".error { color: red; font-weight: bold; }");
        out.println(".info { color: blue; }");
        out.println("pre { background: #f0f0f0; padding: 15px; border-radius: 5px; overflow-x: auto; }");
        out.println(".btn { background: #667eea; color: white; padding: 10px 20px; text-decoration: none; ");
        out.println("border-radius: 5px; display: inline-block; margin: 10px 5px; border: none; cursor: pointer; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>🧪 Prueba de Creación de Actividad</h1>");

        // Verificar sesión
        if (user == null) {
            out.println("<p class='error'>✗ ERROR: No hay usuario en sesión</p>");
            out.println("<p><a href='index.jsp' class='btn'>Ir a Login</a></p>");
            out.println("</div></body></html>");
            return;
        }

        out.println("<p class='success'>✓ Usuario en sesión: " + user.getUsername() + " (ID: " + user.getId() + ")</p>");
        out.println("<hr>");

        // PRUEBA 1: Verificar conexión
        out.println("<h2>1. Verificar Conexión a Base de Datos</h2>");
        try (Connection conn = Conexion.getConexion()) {
            if (conn != null && !conn.isClosed()) {
                out.println("<p class='success'>✓ Conexión exitosa</p>");
                out.println("<p class='info'>AutoCommit: " + conn.getAutoCommit() + "</p>");
            } else {
                out.println("<p class='error'>✗ Conexión fallida</p>");
                out.println("</div></body></html>");
                return;
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error de conexión: " + e.getMessage() + "</p>");
            out.println("</div></body></html>");
            return;
        }

        // PRUEBA 2: Verificar tabla actividades
        out.println("<h2>2. Verificar Tabla Actividades</h2>");
        try (Connection conn = Conexion.getConexion()) {
            String sql = "SELECT column_name, data_type FROM information_schema.columns " +
                        "WHERE table_name = 'actividades' ORDER BY ordinal_position";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                out.println("<pre>");
                boolean existe = false;
                while (rs.next()) {
                    existe = true;
                    out.println(rs.getString("column_name") + " - " + rs.getString("data_type"));
                }
                out.println("</pre>");

                if (existe) {
                    out.println("<p class='success'>✓ Tabla actividades existe</p>");
                } else {
                    out.println("<p class='error'>✗ Tabla actividades NO existe</p>");
                    out.println("</div></body></html>");
                    return;
                }
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error: " + e.getMessage() + "</p>");
        }

        // PRUEBA 3: Crear actividad usando SQL directo
        out.println("<h2>3. Prueba de Creación con SQL Directo</h2>");
        try (Connection conn = Conexion.getConexion()) {
            String sql = "INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, " +
                        "prioridad, estado, color) VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, user.getId());
                ps.setString(2, "PRUEBA AUTOMÁTICA - " + System.currentTimeMillis());
                ps.setString(3, "Esta es una actividad de prueba creada automáticamente");
                ps.setDate(4, new java.sql.Date(System.currentTimeMillis()));
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000));
                ps.setString(6, "Media");
                ps.setString(7, "En Progreso");
                ps.setString(8, "#3498db");

                out.println("<p class='info'>Ejecutando SQL...</p>");
                out.println("<pre>");
                out.println("Usuario ID: " + user.getId());
                out.println("Título: PRUEBA AUTOMÁTICA");
                out.println("</pre>");

                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    out.println("<p class='success'>✓ ¡ÉXITO! Actividad creada con ID: " + newId + "</p>");

                    // Eliminar la prueba
                    String deleteSql = "DELETE FROM actividades WHERE id = ?";
                    try (PreparedStatement psDelete = conn.prepareStatement(deleteSql)) {
                        psDelete.setInt(1, newId);
                        psDelete.executeUpdate();
                        out.println("<p class='info'>Actividad de prueba eliminada</p>");
                    }
                } else {
                    out.println("<p class='error'>✗ No se retornó ID</p>");
                }
            }
        } catch (SQLException e) {
            out.println("<p class='error'>✗ ERROR SQL:</p>");
            out.println("<pre>");
            out.println("Mensaje: " + e.getMessage());
            out.println("SQL State: " + e.getSQLState());
            out.println("Código: " + e.getErrorCode());
            out.println("</pre>");
            e.printStackTrace(out);
        }

        // PRUEBA 4: Crear usando el DAO
        out.println("<h2>4. Prueba de Creación usando ActividadDao</h2>");
        try {
            Actividad actividad = new Actividad();
            actividad.setUsuario_id(user.getId());
            actividad.setTitulo("PRUEBA DAO - " + System.currentTimeMillis());
            actividad.setDescripcion("Prueba usando el DAO");
            actividad.setFecha_inicio(new java.sql.Date(System.currentTimeMillis()));
            actividad.setFecha_fin(new java.sql.Date(System.currentTimeMillis() + 30L * 24 * 60 * 60 * 1000));
            actividad.setPrioridad("Media");
            actividad.setEstado("En Progreso");
            actividad.setColor("#3498db");

            out.println("<p class='info'>Intentando crear con ActividadDao...</p>");

            ActividadDao dao = new ActividadDao();
            int nuevoId = dao.crearYRetornarId(actividad);

            if (nuevoId > 0) {
                out.println("<p class='success'>✓ ¡ÉXITO! Actividad creada con ID: " + nuevoId + "</p>");

                // Eliminar
                dao.eliminar(nuevoId);
                out.println("<p class='info'>Actividad de prueba eliminada</p>");
            } else {
                out.println("<p class='error'>✗ El DAO retornó 0</p>");
            }

        } catch (Exception e) {
            out.println("<p class='error'>✗ ERROR en DAO:</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }

        out.println("<hr>");
        out.println("<h2>✅ Conclusión</h2>");
        out.println("<p>Si todas las pruebas pasaron, el sistema funciona correctamente.</p>");
        out.println("<p>Si alguna falló, revisa los errores específicos arriba.</p>");

        out.println("<br>");
        out.println("<a href='dashboard.jsp' class='btn'>Ir al Dashboard</a>");
        out.println("<a href='ActividadServlet?accion=nuevo' class='btn'>Crear Actividad Real</a>");
        out.println("<a href='ActividadServlet?accion=listar' class='btn'>Ver Actividades</a>");

        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}

