<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Actividades - <%= user.getUsername() %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #667eea;
        }
        .header h1 {
            color: #667eea;
            font-size: 2.5rem;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info {
            background: linear-gradient(135deg, #667eea22 0%, #764ba222 100%);
            padding: 12px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #667eea;
            font-weight: 600;
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
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        .actividades-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        .actividad-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 5px solid;
            transition: all 0.3s;
            position: relative;
        }
        .actividad-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        .actividad-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .actividad-titulo {
            font-size: 1.4rem;
            font-weight: bold;
            color: #333;
            flex: 1;
            margin-right: 10px;
        }
        .actividad-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }
        .badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .badge-alta { background: #fee; color: #c00; }
        .badge-media { background: #ffe; color: #c60; }
        .badge-baja { background: #efe; color: #060; }
        .actividad-descripcion {
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        .actividad-fechas {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            font-size: 0.9rem;
            color: #666;
        }
        .fecha-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .tareas-section {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #f0f0f0;
        }
        .tareas-toggle {
            background: #f8f9fa;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            transition: all 0.3s;
        }
        .tareas-toggle:hover {
            background: #e9ecef;
        }
        .tareas-toggle i {
            transition: transform 0.3s;
        }
        .tareas-toggle.active i {
            transform: rotate(180deg);
        }
        .tareas-lista {
            display: none;
            margin-top: 10px;
        }
        .tareas-lista.show {
            display: block;
        }
        .tarea-item {
            background: #f8f9fa;
            padding: 12px;
            margin-bottom: 8px;
            border-radius: 8px;
            border-left: 3px solid;
            transition: all 0.2s;
        }
        .tarea-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }
        .tarea-item.completada {
            opacity: 0.7;
            border-left-color: #28a745 !important;
        }
        .tarea-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }
        .tarea-titulo {
            font-weight: 600;
            color: #333;
            font-size: 0.95rem;
        }
        .tarea-completada .tarea-titulo {
            text-decoration: line-through;
        }
        .tarea-meta {
            font-size: 0.8rem;
            color: #666;
            display: flex;
            gap: 10px;
            margin-top: 5px;
        }
        .tarea-estado {
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .tarea-estado.pendiente { background: #fff3cd; color: #856404; }
        .tarea-estado.en-progreso { background: #cce5ff; color: #004085; }
        .tarea-estado.completada { background: #d4edda; color: #155724; }
        .actividad-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .btn-small {
            padding: 8px 15px;
            font-size: 0.85rem;
            flex: 1;
        }
        .btn-ver { background: #17a2b8; color: white; }
        .btn-ver:hover { background: #138496; }
        .btn-editar { background: #007bff; color: white; }
        .btn-editar:hover { background: #0056b3; }
        .btn-estado { background: #ffc107; color: #000; }
        .btn-estado:hover { background: #e0a800; }
        .btn-eliminar { background: #dc3545; color: white; }
        .btn-eliminar:hover { background: #c82333; }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <i class="fas fa-user-circle"></i>
                Mis Actividades
            </h1>
            <div style="display: flex; gap: 10px;">
                <% if ("Administrador".equals(user.getRol())) { %>
                    <a href="formulario-actividad.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Nueva Actividad
                    </a>
                <% } %>
                <a href="dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-home"></i> Inicio
                </a>
            </div>
        </div>

        <div class="user-info">
            <i class="fas fa-user"></i>
            <span>Viendo actividades de: <strong><%= user.getUsername() %></strong></span>
        </div>


        <%
        // Calcular estadísticas
        int totalActividades = listaActividades != null ? listaActividades.size() : 0;
        int actividadesCompletadas = 0;
        int totalTareas = 0;
        int tareasCompletadas = 0;

        if (listaActividades != null) {
            for (Actividad act : listaActividades) {
                if ("Completada".equals(act.getEstado())) {
                    actividadesCompletadas++;
                }
                totalTareas += act.getTotalTareas();
                tareasCompletadas += act.getTareasCompletadas();
            }
        }
        %>

        <% if (totalActividades > 0) { %>
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-number"><%= totalActividades %></div>
                <div class="stat-label">Total Actividades</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= actividadesCompletadas %></div>
                <div class="stat-label">Completadas</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalTareas %></div>
                <div class="stat-label">Total Tareas</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= tareasCompletadas %></div>
                <div class="stat-label">Tareas Completadas</div>
            </div>
        </div>
        <% } %>

        <% if (listaActividades != null && !listaActividades.isEmpty()) { %>
            <div class="actividades-grid">
                <% for (Actividad act : listaActividades) {
                    String colorBorde = act.getColor() != null ? act.getColor() : "#3498db";
                    int porcentaje = (int) act.getPorcentajeCompletado();
                %>
                <div class="actividad-card" style="border-left-color: <%= colorBorde %>;">
                    <div class="actividad-header">
                        <div class="actividad-titulo"><%= act.getTitulo() %></div>
                    </div>

                    <div class="actividad-badges">
                        <% if ("Alta".equals(act.getPrioridad())) { %>
                            <span class="badge badge-alta"><i class="fas fa-exclamation-circle"></i> Alta</span>
                        <% } else if ("Media".equals(act.getPrioridad())) { %>
                            <span class="badge badge-media"><i class="fas fa-minus-circle"></i> Media</span>
                        <% } else { %>
                            <span class="badge badge-baja"><i class="fas fa-check-circle"></i> Baja</span>
                        <% } %>
                        <span class="badge" style="background: <%= colorBorde %>22; color: <%= colorBorde %>;">
                            <%= act.getEstado() %>
                        </span>
                    </div>

                    <% if (act.getDescripcion() != null && !act.getDescripcion().isEmpty()) { %>
                        <div class="actividad-descripcion">
                            <%= act.getDescripcion().length() > 100 ? act.getDescripcion().substring(0, 100) + "..." : act.getDescripcion() %>
                        </div>
                    <% } %>

                    <div class="actividad-fechas">
                        <div class="fecha-item">
                            <i class="far fa-calendar"></i>
                            <span><%= act.getFecha_inicio() %></span>
                        </div>
                        <div class="fecha-item">
                            <i class="far fa-calendar-check"></i>
                            <span><%= act.getFecha_fin() %></span>
                        </div>
                    </div>


                    <!-- Sección de Tareas -->
                    <% if (act.getTareas() != null && !act.getTareas().isEmpty()) { %>
                    <div class="tareas-section">
                        <div class="tareas-toggle" onclick="toggleTareas(this)">
                            <span><i class="fas fa-list-check"></i> Ver tareas (<%= act.getTareas().size() %>)</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="tareas-lista">
                            <% for (Tarea tarea : act.getTareas()) {
                                String colorTarea = "#3498db";
                                if ("Alta".equals(tarea.getPrioridad())) colorTarea = "#e74c3c";
                                else if ("Media".equals(tarea.getPrioridad())) colorTarea = "#f39c12";
                                else colorTarea = "#27ae60";

                                String estadoClase = "";
                                if ("Completada".equals(tarea.getEstado())) estadoClase = "completada";
                            %>
                            <div class="tarea-item tarea-<%= estadoClase %>" style="border-left-color: <%= colorTarea %>;">
                                <div class="tarea-header">
                                    <div class="tarea-titulo">
                                        <% if ("Completada".equals(tarea.getEstado())) { %>
                                            <i class="fas fa-check-circle" style="color: #28a745;"></i>
                                        <% } %>
                                        <%= tarea.getTitulo() %>
                                    </div>
                                    <% if ("Completada".equals(tarea.getEstado())) { %>
                                        <span class="tarea-estado completada">Completada</span>
                                    <% } else if ("En Progreso".equals(tarea.getEstado())) { %>
                                        <span class="tarea-estado en-progreso">En Progreso</span>
                                    <% } else { %>
                                        <span class="tarea-estado pendiente">Pendiente</span>
                                    <% } %>
                                </div>
                                <div class="tarea-meta">
                                    <span><i class="fas fa-flag"></i> <%= tarea.getPrioridad() %></span>
                                    <% if (tarea.getFecha_vencimiento() != null) { %>
                                        <span><i class="far fa-calendar"></i> <%= tarea.getFecha_vencimiento() %></span>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <div class="actividad-actions">
                        <a href="Tareaservlet?accion=listarPorActividad&idActividad=<%= act.getId() %>" class="btn btn-ver btn-small">
                            <i class="fas fa-list-check"></i> Ver Tareas
                        </a>
                        <% if ("Administrador".equals(user.getRol())) { %>
                            <a href="ActividadServlet?accion=editar&id=<%= act.getId() %>" class="btn btn-primary btn-small">
                                <i class="fas fa-edit"></i> Editar
                            </a>
                            <button onclick="cambiarEstado(<%= act.getId() %>, '<%= act.getEstado() %>')" class="btn btn-estado btn-small">
                                <i class="fas fa-sync-alt"></i> Cambiar Estado
                            </button>
                            <a href="ActividadServlet?accion=eliminar&id=<%= act.getId() %>"
                               class="btn btn-eliminar btn-small"
                               onclick="return confirm('¿Estás seguro de eliminar esta actividad? Todas las tareas asociadas perderán su relación.');">
                                <i class="fas fa-trash"></i> Eliminar
                            </a>
                        <% } else { %>
                            <button onclick="cambiarEstado(<%= act.getId() %>, '<%= act.getEstado() %>')" class="btn btn-estado btn-small">
                                <i class="fas fa-sync-alt"></i> Cambiar Estado
                            </button>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-folder-open"></i>
                <h3>No tienes actividades aún</h3>
                <p>Comienza creando tu primera actividad para organizar tus tareas</p>
                <a href="ActividadServlet?accion=nuevo" class="btn btn-primary" style="margin-top: 20px;">
                    <i class="fas fa-plus"></i> Crear Primera Actividad
                </a>
            </div>
        <% } %>
    </div>

    <script>
        // Función para mostrar/ocultar tareas
        function toggleTareas(element) {
            const tareasLista = element.nextElementSibling;
            tareasLista.classList.toggle('show');
            element.classList.toggle('active');
        }

        // Función para cambiar el estado de una actividad
        function cambiarEstado(actividadId, estadoActual) {
            const estados = ['Pendiente', 'En Progreso', 'Completada', 'Cancelada'];

            const options = estados.map(estado =>
                '<option value="' + estado + '"' + (estado === estadoActual ? ' selected' : '') + '>' + estado + '</option>'
            ).join('');

            Swal.fire({
                title: 'Cambiar Estado',
                html: '<p style="margin-bottom: 15px;">Estado actual: <strong>' + estadoActual + '</strong></p>' +
                      '<select id="nuevoEstado" class="swal2-select" style="width: 100%;">' + options + '</select>',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Cambiar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#667eea',
                cancelButtonColor: '#6c757d',
                preConfirm: () => {
                    const nuevoEstado = document.getElementById('nuevoEstado').value;
                    if (nuevoEstado === estadoActual) {
                        Swal.showValidationMessage('Selecciona un estado diferente');
                        return false;
                    }
                    return nuevoEstado;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    // Enviar la solicitud para cambiar el estado
                    fetch('ActividadServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `accion=cambiarEstado&id=${actividadId}&estado=${encodeURIComponent(result.value)}`
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire({
                                title: '¡Actualizado!',
                                text: 'El estado se ha cambiado correctamente',
                                icon: 'success',
                                confirmButtonColor: '#667eea'
                            }).then(() => {
                                window.location.reload();
                            });
                        } else {
                            Swal.fire('Error', data.message || 'No se pudo cambiar el estado', 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        Swal.fire('Error', 'Ocurrió un error al cambiar el estado', 'error');
                    });
                }
            });
        }

        // Mostrar mensajes de éxito/error
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const error = urlParams.get('error');

        if (msg === 'actividad_creada') {
            Swal.fire('¡Éxito!', 'Actividad creada correctamente', 'success');
        } else if (msg === 'actividad_actualizada') {
            Swal.fire('¡Actualizado!', 'Actividad actualizada correctamente', 'success');
        } else if (msg === 'actividad_eliminada') {
            Swal.fire('¡Eliminado!', 'Actividad eliminada correctamente', 'success');
        } else if (msg === 'estado_cambiado') {
            Swal.fire('¡Actualizado!', 'Estado cambiado correctamente', 'success');
        }

        if (error) {
            Swal.fire('Error', 'Ocurrió un error al procesar la solicitud', 'error');
        }
    </script>
</body>
</html>

