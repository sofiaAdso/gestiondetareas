<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.repository.TareaDao" %>
<%@ page import="com.sena.gestion.model.Tarea" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test de Tareas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #6a11cb; color: white; }
    </style>
</head>
<body>
    <h1>🔍 Test de Conexión a Base de Datos</h1>

    <%
        TareaDao tareaDao = new TareaDao();
        List<Tarea> tareas = null;
        String mensaje = "";
        String clase = "";

        try {
            tareas = tareaDao.listar();
            if (tareas != null) {
                mensaje = "✓ Conexión exitosa. Tareas encontradas: " + tareas.size();
                clase = "success";
            } else {
                mensaje = "✗ La lista de tareas es NULL";
                clase = "error";
            }
        } catch (Exception e) {
            mensaje = "✗ Error: " + e.getMessage();
            clase = "error";
        }
    %>

    <p class="<%= clase %>"><%= mensaje %></p>

    <% if (tareas != null && tareas.size() > 0) { %>
        <h2>Tareas en la Base de Datos:</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Descripción</th>
                    <th>Estado</th>
                    <th>Prioridad</th>
                    <th>Usuario ID</th>
                </tr>
            </thead>
            <tbody>
                <% for (Tarea t : tareas) { %>
                <tr>
                    <td><%= t.getId() %></td>
                    <td><%= t.getTitulo() %></td>
                    <td><%= t.getDescripcion() %></td>
                    <td><%= t.getEstado() %></td>
                    <td><%= t.getPrioridad() %></td>
                    <td><%= t.getUsuario_id() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } else if (tareas != null) { %>
        <p class="error">No hay tareas en la base de datos. Necesitas crear algunas tareas primero.</p>
    <% } %>

    <br><br>
    <a href="dashboard.jsp" style="color: #6a11cb; text-decoration: none;">← Volver al Inicio</a>
</body>
</html>

