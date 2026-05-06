<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("index.jsp"); return; }
    Actividad actividad = (Actividad) request.getAttribute("actividad");
    List<Tarea> listaTareas = (List<Tarea>) request.getAttribute("listaTareas");

    if (actividad == null) {
        response.sendRedirect("ActividadServlet?accion=listar");
        return;
    }

    // Solo el administrador puede editar y agregar tareas
    boolean esAdministrador = "Administrador".equals(user.getRol());

    int totalTareas = listaTareas != null ? listaTareas.size() : 0;
    int tareasCompletadas = 0;
    if (listaTareas != null) {
        for (Tarea t : listaTareas) {
            if ("Completada".equals(t.getEstado())) tareasCompletadas++;
        }
    }
    int porcentaje = totalTareas > 0 ? (tareasCompletadas * 100) / totalTareas : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= actividad.getTitulo() %> - Detalles</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
        }
        .container {
            margin-left: 300px;
            width: calc(100% - 300px);
            max-width: 100%;
            padding: 20px;
        }
        .actividad-header {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border-left: 8px solid <%= actividad.getColor() %>;
        }
        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        .titulo-principal {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .titulo-principal i {
            color: <%= actividad.getColor() %>;
        }
        .badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
        .badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .badge-alta { background: #fee; color: #c00; }
        .badge-media { background: #ffe; color: #c60; }
        .badge-baja { background: #efe; color: #060; }
        .descripcion {
            font-size: 1.1rem;
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .info-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-item i {
            font-size: 1.5rem;
            color: <%= actividad.getColor() %>;
        }
        .info-item-content {
            flex: 1;
        }
        .info-label {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 3px;
        }
        .info-value {
            font-weight: bold;
            color: #333;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-secondary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
        }
        .tareas-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .tareas-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #eee;
        }
        .tareas-header h2 {
            color: #333;
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .tarea-card {
            background: #f8f9fa;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 10px;
            border-left: 4px solid;
            transition: all 0.3s;
        }
        .tarea-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .tarea-card.prioridad-alta { border-left-color: #dc3545; }
        .tarea-card.prioridad-media { border-left-color: #ffc107; }
        .tarea-card.prioridad-baja { border-left-color: #28a745; }
        .tarea-titulo {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        .tarea-info {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            font-size: 0.9rem;
            color: #666;
        }
        .tarea-info span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .empty-tareas {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-tareas i {
            font-size: 4rem;
            margin-bottom: 15px;
            opacity: 0.3;
        }
    </style>
</head>
<body>
    <%
        // Mostrar mensaje de éxito si la actividad fue recién creada
        String resultado = request.getParameter("res");
        if ("creada".equals(resultado)) {
    %>
    <script>
        Swal.fire({
            icon: 'success',
            title: '¡Actividad Creada!',
            html: '<p>La actividad se ha creado exitosamente.</p>' +
                  '<p style="margin-top: 10px;"><strong>¿Qué deseas hacer ahora?</strong></p>',
            showDenyButton: true,
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-plus"></i> Agregar Tareas',
            denyButtonText: '<i class="fas fa-list"></i> Ver Todas las Actividades',
            cancelButtonText: '<i class="fas fa-eye"></i> Quedarse Aquí',
            confirmButtonColor: '#667eea',
            denyButtonColor: '#6c757d',
            cancelButtonColor: '#95a5a6'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'Tareaservlet?accion=nuevo&actividad_id=<%= actividad.getId() %>';
            } else if (result.isDenied) {
                window.location.href = 'ActividadServlet?accion=listar';
            }
        });
    </script>
    <% } %>

    <jsp:include page="components/header.jsp" />

    <div class="container">
        <!-- Cabecera de la Actividad -->
        <div class="actividad-header">
            <div class="header-top">
                <div class="header-info">
                    <h1 class="titulo-principal">
                        <%= actividad.getTitulo() %>
                    </h1>

                    <div class="badges">
                        <% if ("Alta".equals(actividad.getPrioridad())) { %>
                            <span class="badge badge-alta"><i class="fas fa-exclamation-circle"></i> Prioridad Alta</span>
                        <% } else if ("Media".equals(actividad.getPrioridad())) { %>
                            <span class="badge badge-media"><i class="fas fa-minus-circle"></i> Prioridad Media</span>
                        <% } else { %>
                            <span class="badge badge-baja"><i class="fas fa-check-circle"></i> Prioridad Baja</span>
                        <% } %>
                        <span class="badge" style="background: <%= actividad.getColor() %>22; color: <%= actividad.getColor() %>; border: 2px solid <%= actividad.getColor() %>;">
                            <%= actividad.getEstado() %>
                        </span>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                    <a href="ActividadServlet?accion=listar" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Volver
                    </a>
                    <% if (esAdministrador) { %>
                    <a href="ActividadServlet?accion=editar&id=<%= actividad.getId() %>" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Editar
                    </a>
                    <% } %>
                </div>
            </div>

            <% if (actividad.getDescripcion() != null && !actividad.getDescripcion().isEmpty()) { %>
                <div class="descripcion">
                    <i class="fas fa-align-left" style="color: <%= actividad.getColor() %>; margin-right: 10px;"></i>
                    <%= actividad.getDescripcion() %>
                </div>
            <% } %>

            <div class="info-grid">
                <div class="info-item">
                    <i class="far fa-calendar"></i>
                    <div class="info-item-content">
                        <div class="info-label">Fecha Inicio</div>
                        <div class="info-value"><%= actividad.getFecha_inicio() %></div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="far fa-calendar-check"></i>
                    <div class="info-item-content">
                        <div class="info-label">Fecha Fin</div>
                        <div class="info-value"><%= actividad.getFecha_fin() %></div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-tasks"></i>
                    <div class="info-item-content">
                        <div class="info-label">Total Tareas</div>
                        <div class="info-value"><%= totalTareas %></div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-check-double"></i>
                    <div class="info-item-content">
                        <div class="info-label">Completadas</div>
                        <div class="info-value"><%= tareasCompletadas %></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sección de Tareas -->
        <div class="tareas-section">
            <div class="tareas-header">
                <h2>
                    <i class="fas fa-list-check"></i>
                    Tareas de esta Actividad
                </h2>
                <% if (esAdministrador) { %>
                <a href="Tareaservlet?accion=nuevo&idActividad=<%= actividad.getId() %>" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Agregar Tarea
                </a>
                <% } %>
            </div>

            <% if (listaTareas != null && !listaTareas.isEmpty()) { %>
                <% for (Tarea tarea : listaTareas) {
                    String clasePrioridad = "prioridad-" + tarea.getPrioridad().toLowerCase();
                %>
                <div class="tarea-card <%= clasePrioridad %>">
                    <div class="tarea-titulo">
                        <%= tarea.getTitulo() %>
                        <% if ("Completada".equals(tarea.getEstado())) { %>
                            <i class="fas fa-check-circle" style="color: #28a745;"></i>
                        <% } %>
                    </div>

                    <% if (tarea.getDescripcion() != null && !tarea.getDescripcion().isEmpty()) { %>
                    <div style="color: #555; font-size: 0.95rem; margin: 10px 0; line-height: 1.5; padding: 10px; background: white; border-radius: 6px;">
                        <i class="fas fa-align-left" style="color: #667eea; margin-right: 8px;"></i>
                        <%= tarea.getDescripcion() %>
                    </div>
                    <% } %>

                    <div class="tarea-info">
                        <span>
                            <i class="fas fa-tag"></i>
                            <%= tarea.getNombreCategoria() != null ? tarea.getNombreCategoria() : "Sin categoría" %>
                        </span>
                        <span>
                            <i class="fas fa-exclamation-triangle"></i>
                            <%= tarea.getPrioridad() %>
                        </span>
                        <span>
                            <i class="fas fa-info-circle"></i>
                            <%= tarea.getEstado() %>
                        </span>
                        <span>
                            <i class="far fa-calendar"></i>
                            Vence: <%= tarea.getFecha_vencimiento() %>
                        </span>
                        <% if (esAdministrador) { %>
                        <a href="Tareaservlet?accion=editar&id=<%= tarea.getId() %>"
                           style="color: #667eea; text-decoration: none; font-weight: bold;">
                            <i class="fas fa-edit"></i> Editar
                        </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <div class="empty-tareas">
                    <i class="fas fa-tasks"></i>
                    <h3>No hay tareas en esta actividad</h3>
                    <% if (esAdministrador) { %>
                    <p>Agrega la primera tarea para comenzar a organizar el trabajo</p>
                    <a href="Tareaservlet?accion=nuevo&actividad_id=<%= actividad.getId() %>"
                       class="btn btn-primary"
                       style="margin-top: 20px;">
                        <i class="fas fa-plus"></i> Crear Primera Tarea
                    </a>
                    <% } else { %>
                    <p>Esta actividad aún no tiene tareas asignadas</p>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>

