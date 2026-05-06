<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Actividades</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; }
        .info { background: #e3f2fd; padding: 15px; border-radius: 5px; margin: 10px 0; }
        .error { background: #ffebee; padding: 15px; border-radius: 5px; margin: 10px 0; color: #c62828; }
        .success { background: #e8f5e9; padding: 15px; border-radius: 5px; margin: 10px 0; color: #2e7d32; }
        ul { list-style: none; padding: 0; }
        li { padding: 10px; background: #f5f5f5; margin: 5px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Test de Actividades</h1>

        <%
            System.out.println("=== TEST JSP: INICIO ===");

            // Verificar usuario
            Usuario user = (Usuario) session.getAttribute("usuario");
            if (user == null) {
        %>
                <div class="error">
                    <strong>❌ ERROR:</strong> No hay usuario en sesión
                    <br><a href="index.jsp">Ir al login</a>
                </div>
        <%
                return;
            }
        %>

        <div class="success">
            <strong>✓ Usuario autenticado:</strong> <%= user.getUsername() %>
            (ID: <%= user.getId() %>, Rol: <%= user.getRol() %>)
        </div>

        <%
            // Verificar si hay lista de actividades
            List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");

            if (listaActividades == null) {
        %>
                <div class="error">
                    <strong>❌ ERROR:</strong> listaActividades es NULL
                    <br>El servlet no pasó los datos correctamente
                </div>
        <%
            } else if (listaActividades.isEmpty()) {
        %>
                <div class="info">
                    <strong>ℹ️ INFO:</strong> La lista de actividades está vacía
                    <br>No hay actividades para este usuario
                    <br><a href="ActividadServlet?accion=nuevo">Crear primera actividad</a>
                </div>
        <%
            } else {
        %>
                <div class="success">
                    <strong>✓ Actividades encontradas:</strong> <%= listaActividades.size() %>
                </div>

                <h2>📋 Lista de Actividades:</h2>
                <ul>
        <%
                for (Actividad act : listaActividades) {
        %>
                    <li>
                        <strong><%= act.getTitulo() %></strong>
                        <br>ID: <%= act.getId() %>
                        <br>Estado: <%= act.getEstado() %>
                        <br>Prioridad: <%= act.getPrioridad() %>
                        <br>Tareas: <%= act.getTotalTareas() %> (Completadas: <%= act.getTareasCompletadas() %>)
                        <br>Progreso: <%= String.format("%.1f", act.getPorcentajeCompletado()) %>%
                    </li>
        <%
                }
        %>
                </ul>
        <%
            }

            System.out.println("=== TEST JSP: FIN ===");
        %>

        <hr>
        <p>
            <a href="ActividadServlet?accion=listar">← Volver a Mis Actividades</a> |
            <a href="dashboard.jsp">🏠 Inicio</a>
        </p>
    </div>
</body>
</html>

