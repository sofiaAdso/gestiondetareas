<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.repository.CategoriaDao" %>
<%@ page import="com.sena.gestion.model.Categoria" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test de Categorías</title>
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
    <h1>🔍 Test de Categorías - Base de Datos</h1>

    <%
        CategoriaDao categoriaDao = new CategoriaDao();
        List<Categoria> categorias = null;
        String mensaje = "";
        String clase = "";

        try {
            categorias = categoriaDao.listar();
            if (categorias != null) {
                mensaje = "✓ Conexión exitosa. Categorías encontradas: " + categorias.size();
                clase = "success";
            } else {
                mensaje = "✗ La lista de categorías es NULL";
                clase = "error";
            }
        } catch (Exception e) {
            mensaje = "✗ Error: " + e.getMessage();
            clase = "error";
            e.printStackTrace();
        }
    %>

    <p class="<%= clase %>"><%= mensaje %></p>

    <% if (categorias != null && categorias.size() > 0) { %>
        <h2>Categorías en la Base de Datos:</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                </tr>
            </thead>
            <tbody>
                <% for (Categoria c : categorias) { %>
                <tr>
                    <td><%= c.getId() %></td>
                    <td><%= c.getNombre() %></td>
                    <td><%= c.getDescripcion() != null ? c.getDescripcion() : "<i>Sin descripción</i>" %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } else if (categorias != null) { %>
        <p class="error">No hay categorías en la base de datos. Necesitas crear algunas categorías primero.</p>
    <% } %>

    <br><br>
    <a href="Categoriaservlet?accion=listar" style="color: #6a11cb; text-decoration: none;">← Volver a Gestión de Categorías</a>
</body>
</html>

