<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.sena.gestion.model.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sena.gestion.model.Tarea" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Debug - Listado de Tareas</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .debug { background: #f0f0f0; padding: 10px; margin: 10px 0; border-left: 4px solid #6a11cb; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #6a11cb; color: white; }
    </style>
</head>
<body>
    <h1>🔍 Debug - Información de Tareas</h1>

    <%
        Usuario user = (Usuario) session.getAttribute("usuario");
        List<Tarea> listaTareas = (List<Tarea>) request.getAttribute("listaTareas");
    %>

    <div class="debug">
        <h3>Información de Sesión</h3>
        <p><strong>Usuario en sesión:</strong> <%= user != null ? user.getUsername() : "NULL" %></p>
        <p><strong>Rol:</strong> <%= user != null ? user.getRol() : "NULL" %></p>
        <p><strong>ID:</strong> <%= user != null ? user.getId() : "NULL" %></p>
    </div>

    <div class="debug">
        <h3>Información del Atributo listaTareas</h3>
        <p><strong>¿Es null?</strong> <%= listaTareas == null ? "SÍ - ¡ESTE ES EL PROBLEMA!" : "NO" %></p>
        <p><strong>Tamaño:</strong> <%= listaTareas != null ? listaTareas.size() : "N/A" %></p>
        <p><strong>¿Está vacía?</strong> <%= listaTareas != null ? (listaTareas.isEmpty() ? "SÍ" : "NO") : "N/A" %></p>
    </div>

    <div class="debug">
        <h3>Prueba con JSTL</h3>
        <p><strong>¿listaTareas está vacía con JSTL?</strong>
            <c:choose>
                <c:when test="${empty listaTareas}">SÍ - VACÍA O NULL</c:when>
                <c:otherwise>NO - Tiene datos</c:otherwise>
            </c:choose>
        </p>
        <p><strong>Tamaño con EL:</strong> ${listaTareas.size()}</p>
    </div>

    <h2>Tabla de Tareas (usando scriptlet)</h2>
    <%
        if (listaTareas != null && !listaTareas.isEmpty()) {
    %>
        <table>
            <tr>
                <th>ID</th>
                <th>Título</th>
                <th>Descripción</th>
                <th>Estado</th>
                <th>Prioridad</th>
                <th>Usuario ID</th>
            </tr>
            <%
                for (Tarea t : listaTareas) {
            %>
            <tr>
                <td><%= t.getId() %></td>
                <td><%= t.getTitulo() %></td>
                <td><%= t.getDescripcion() %></td>
                <td><%= t.getEstado() %></td>
                <td><%= t.getPrioridad() %></td>
                <td><%= t.getUsuario_id() %></td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        } else {
    %>
        <p style="color: red; font-weight: bold;">NO HAY TAREAS O listaTareas ES NULL</p>
    <%
        }
    %>

    <h2>Tabla de Tareas (usando JSTL)</h2>
    <c:choose>
        <c:when test="${empty listaTareas}">
            <p style="color: red; font-weight: bold;">JSTL: listaTareas está vacía o es NULL</p>
        </c:when>
        <c:otherwise>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Descripción</th>
                    <th>Estado</th>
                    <th>Prioridad</th>
                </tr>
                <c:forEach var="tarea" items="${listaTareas}">
                    <tr>
                        <td>${tarea.id}</td>
                        <td>${tarea.titulo}</td>
                        <td>${tarea.descripcion}</td>
                        <td>${tarea.estado}</td>
                        <td>${tarea.prioridad}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <hr>
    <p><a href="Tareaservlet?accion=listar">🔄 Recargar desde Servlet</a></p>
    <p><a href="dashboard.jsp">📋 Ir a Dashboard (sin servlet)</a></p>
    <p><a href="index.jsp">🏠 Volver al Login</a></p>
</body>
</html>

