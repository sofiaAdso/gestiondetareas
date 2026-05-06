<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%
    System.out.println("=== JSP TEST DEBUG: INICIO ===");
    Usuario user = (Usuario) session.getAttribute("usuario");
    System.out.println("Usuario: " + (user != null ? user.getUsername() : "NULL"));

    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    System.out.println("Lista: " + (listaActividades != null ? listaActividades.size() + " items" : "NULL"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Debug Actividades</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .info { background: white; padding: 20px; margin: 10px 0; border-radius: 5px; }
        .success { border-left: 5px solid #28a745; }
        .error { border-left: 5px solid #dc3545; }
    </style>
</head>
<body>
    <h1>🔍 Diagnóstico de Actividades</h1>

    <div class="info <%= (user != null) ? "success" : "error" %>">
        <h3>1. Sesión de Usuario</h3>
        <% if (user != null) { %>
            <p>✅ Usuario: <strong><%= user.getUsername() %></strong></p>
            <p>✅ ID: <strong><%= user.getId() %></strong></p>
            <p>✅ Rol: <strong><%= user.getRol() %></strong></p>
        <% } else { %>
            <p>❌ No hay usuario en sesión</p>
        <% } %>
    </div>

    <div class="info <%= (listaActividades != null) ? "success" : "error" %>">
        <h3>2. Lista de Actividades</h3>
        <% if (listaActividades != null) { %>
            <p>✅ Lista recibida: <strong><%= listaActividades.size() %> actividades</strong></p>

            <% if (listaActividades.isEmpty()) { %>
                <p>⚠️ La lista está vacía</p>
            <% } else { %>
                <h4>Actividades encontradas:</h4>
                <ul>
                <% for (Actividad act : listaActividades) { %>
                    <li>
                        <strong><%= act.getTitulo() %></strong>
                        - Estado: <%= act.getEstado() %>
                        - Prioridad: <%= act.getPrioridad() %>
                        - Tareas: <%= act.getTotalTareas() %>
                        <% if (act.getNombreUsuario() != null) { %>
                            - Usuario: <%= act.getNombreUsuario() %>
                        <% } %>
                    </li>
                <% } %>
                </ul>
            <% } %>
        <% } else { %>
            <p>❌ listaActividades es NULL</p>
        <% } %>
    </div>

    <div class="info">
        <h3>3. Parámetros de Request</h3>
        <p>Acción: <%= request.getParameter("accion") %></p>
        <p>Mensaje: <%= request.getParameter("msg") %></p>
        <p>Error: <%= request.getParameter("error") %></p>
    </div>

    <div style="margin-top: 20px;">
        <a href="ActividadServlet?accion=listar" style="padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px;">
            🔄 Recargar Lista
        </a>
        <a href="dashboard.jsp" style="padding: 10px 20px; background: #6c757d; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">
            🏠 volver
        </a>
    </div>
</body>
</html>

