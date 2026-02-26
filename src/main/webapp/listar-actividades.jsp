<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Verificación de sesión
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Capturar la lista enviada por el Servlet
    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    if (listaActividades == null) {
        listaActividades = new ArrayList<>();
    }

    // Capturar mensaje de error si existe
    String errorMensaje = (String) request.getAttribute("errorMensaje");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Actividades | Sistema de Gestión</title>
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
            background: rgba(255, 255, 255, 0.95);
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
        .actividades-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 25px;
        }
        .actividad-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 8px solid #667eea;
            transition: transform 0.3s;
        }
        .actividad-card:hover { transform: translateY(-5px); }

        .actividad-titulo { color: #333; margin-bottom: 10px; font-size: 1.5rem; }
        .actividad-descripcion { color: #666; font-size: 0.9rem; margin-bottom: 15px; min-height: 40px; }

        .badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        /* Colores por estado */
        .estado-planificada { background: #e3f2fd; color: #1565c0; border: 1px solid #90caf9; }
        .estado-progreso { background: #fff3e0; color: #e65100; border: 1px solid #ffb74d; }
        .estado-pausada { background: #f3e5f5; color: #6a1b9a; border: 1px solid #ce93d8; }
        .estado-completada { background: #e8f5e9; color: #2e7d32; border: 1px solid #81c784; }

        .debug-info {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        /* Estilos de botones que hacían falta */
        .btn-ver:hover { background: #17a2b8; color: white !important; }
        .btn-editar:hover { background: #007bff; color: white !important; }
        .btn-eliminar:hover { background: #dc3545; color: white !important; }
        .btn-estado:hover { opacity: 0.9; transform: scale(1.02); }
    </style>
</head>
<body>
    <div class="container">

        <%-- Mensajes de Error o Información --%>
        <% if (errorMensaje != null && !errorMensaje.isEmpty()) { %>
            <div class="debug-info" style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;">
                <i class="fas fa-exclamation-circle"></i>
                <strong>Error:</strong> <%= errorMensaje %>
            </div>
        <% } %>

        <% if (listaActividades.isEmpty()) { %>
            <div class="debug-info" style="background: #fff3cd; color: #856404; border: 1px solid #ffeeba;">
                <i class="fas fa-info-circle"></i>
                <strong>Sin datos:</strong> No tienes actividades registradas.
                <small>(Usuario: <%= user.getUsername() %>)</small>
            </div>
        <% } %>

        <div class="header">
            <h1><i class="fas fa-folder-open"></i> Mis Actividades</h1>
            <div style="display: flex; gap: 10px;">
                <% if ("Administrador".equals(user.getRol())) { %>
                    <a href="ActividadServlet?accion=nuevo" class="btn btn-primary" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 12px 24px; border-radius: 10px; text-decoration: none; font-weight: bold; display: inline-flex; align-items: center; gap: 8px;">
                        <i class="fas fa-plus"></i> Nueva Actividad
                    </a>
                <% } %>
                <a href="dashboard.jsp" class="btn btn-secondary" style="background: #6c757d; color: white; padding: 12px 24px; border-radius: 10px; text-decoration: none; font-weight: bold; display: inline-flex; align-items: center; gap: 8px;">
                    <i class="fas fa-home"></i> Inicio
                </a>
            </div>
        </div>

        <% if (!listaActividades.isEmpty()) { %>
            <div class="actividades-grid">
                <% for (Actividad act : listaActividades) {
                    String titulo = act.getTitulo() != null ? act.getTitulo() : "Sin título";
                    String desc = act.getDescripcion() != null ? act.getDescripcion() : "Sin descripción";
                    String estado = act.getEstado() != null ? act.getEstado() : "En Progreso";

                    // Clase dinámica según el estado
                    String claseEstado = "estado-progreso";
                    String iconoEstado = "fa-spinner";

                    if(estado.equalsIgnoreCase("Planificada")) {
                        claseEstado = "estado-planificada";
                        iconoEstado = "fa-calendar-alt";
                    } else if(estado.equalsIgnoreCase("En Progreso")) {
                        claseEstado = "estado-progreso";
                        iconoEstado = "fa-spinner fa-spin";
                    } else if(estado.equalsIgnoreCase("Pausada")) {
                        claseEstado = "estado-pausada";
                        iconoEstado = "fa-pause-circle";
                    } else if(estado.equalsIgnoreCase("Completada")) {
                        claseEstado = "estado-completada";
                        iconoEstado = "fa-check-circle";
                    }
                %>
                <div class="actividad-card" style="border-left-color: <%= act.getColor() != null ? act.getColor() : "#667eea" %>;">
                    <div class="header-card" style="display:flex; justify-content:space-between; align-items:start;">
                        <h2 class="actividad-titulo"><%= titulo %></h2>
                        <span class="badge <%= claseEstado %>">
                            <i class="fas <%= iconoEstado %>"></i> <%= estado %>
                        </span>
                    </div>

                    <p class="actividad-descripcion"><%= desc %></p>

                    <div class="actividad-actions" style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 15px;">
                        <a href="ActividadServlet?accion=ver&id=<%= act.getId() %>" class="btn-ver" style="text-decoration:none; color:#17a2b8; padding: 6px 12px; border-radius: 6px; border: 2px solid #17a2b8; font-size: 0.85rem; font-weight: bold; display: flex; align-items: center; gap: 4px;">
                            <i class="fas fa-eye"></i> Ver
                        </a>

                        <% if (!"Administrador".equals(user.getRol())) { %>
                            <!-- Solo usuarios pueden cambiar el estado con selector desplegable -->
                            <select id="estado_act_<%= act.getId() %>"
                                    onchange="cambiarEstado(<%= act.getId() %>, this.value)"
                                    style="background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%);
                                           color: #000;
                                           padding: 8px 12px;
                                           border-radius: 8px;
                                           border: 2px solid #ffc107;
                                           font-size: 0.9rem;
                                           font-weight: bold;
                                           cursor: pointer;
                                           box-shadow: 0 2px 5px rgba(255, 193, 7, 0.3);
                                           transition: all 0.3s ease;">
                                <option value="Pendiente" <%= "Pendiente".equals(estado) ? "selected" : "" %>>📋 Pendiente</option>
                                <option value="En Progreso" <%= "En Progreso".equals(estado) ? "selected" : "" %>>⏳ En Progreso</option>
                                <option value="Completada" <%= "Completada".equals(estado) ? "selected" : "" %>>✅ Completada</option>
                            </select>
                        <% } %>

                        <% if ("Administrador".equals(user.getRol())) { %>
                            <a href="ActividadServlet?accion=editar&id=<%= act.getId() %>" class="btn-editar" style="text-decoration:none; color:#007bff; padding: 6px 12px; border-radius: 6px; border: 2px solid #007bff; font-size: 0.85rem; font-weight: bold; display: flex; align-items: center; gap: 4px;">
                                <i class="fas fa-edit"></i> Editar
                            </a>
                            <a href="ActividadServlet?accion=eliminar&id=<%= act.getId() %>"
                               onclick="return confirm('¿Eliminar actividad?');"
                               class="btn-eliminar" style="text-decoration:none; color:#dc3545; padding: 6px 12px; border-radius: 6px; border: 2px solid #dc3545; font-size: 0.85rem; font-weight: bold; display: flex; align-items: center; gap: 4px;">
                                <i class="fas fa-trash"></i> Eliminar
                            </a>
                        <% } else { %>
                            <!-- Usuarios también pueden editar sus actividades -->
                            <a href="ActividadServlet?accion=editar&id=<%= act.getId() %>" class="btn-editar" style="text-decoration:none; color:#007bff; padding: 6px 12px; border-radius: 6px; border: 2px solid #007bff; font-size: 0.85rem; font-weight: bold; display: flex; align-items: center; gap: 4px;">
                                <i class="fas fa-edit"></i> Editar
                            </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 50px;">
                <i class="fas fa-folder-open" style="font-size: 4rem; color: #ccc;"></i>
                <h3 style="margin-top: 20px; color: #666;">No hay actividades para mostrar</h3>
                <p>Crea una nueva actividad para comenzar a gestionar tus tareas.</p>
            </div>
        <% } %>
    </div>

    <script>
        function cambiarEstado(actividadId, nuevoEstado) {
            // Obtener el selector para poder revertir si cancela
            const selector = document.getElementById('estado_act_' + actividadId);
            const estadoAnterior = selector.getAttribute('data-estado-anterior') || selector.value;

            // Guardar el estado anterior
            selector.setAttribute('data-estado-anterior', estadoAnterior);

            // Configurar ícono y color según el estado
            let icono = 'question';
            let color = '#6a11cb';
            let titulo = '¿Cambiar estado de la actividad?';

            if (nuevoEstado === 'Completada') {
                icono = 'success';
                color = '#28a745';
                titulo = '¿Marcar como Completada?';
            } else if (nuevoEstado === 'En Progreso') {
                icono = 'info';
                color = '#17a2b8';
                titulo = '¿Cambiar a En Progreso?';
            } else if (nuevoEstado === 'Pendiente') {
                icono = 'question';
                color = '#ffc107';
                titulo = '¿Cambiar a Pendiente?';
            }

            Swal.fire({
                title: titulo,
                html: `La actividad cambiará a: <br><strong style="font-size: 1.2em; color: ${color};">${nuevoEstado}</strong>`,
                icon: icono,
                showCancelButton: true,
                confirmButtonColor: color,
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, cambiar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'ActividadServlet?accion=cambiarEstado&id=' + actividadId + '&estado=' + encodeURIComponent(nuevoEstado);
                } else {
                    // Revertir el selector al estado anterior
                    selector.value = estadoAnterior;
                }
            });
        }

        <%-- Manejo de alertas según la URL --%>
        const params = new URLSearchParams(window.location.search);
        if (params.get('msg') === 'ok') Swal.fire('Hecho', 'Operación exitosa', 'success');
        if (params.get('msg') === 'estado_actualizado') Swal.fire({
            icon: 'success',
            title: '¡Estado Actualizado!',
            text: 'El estado de la actividad ha sido cambiado correctamente.',
            timer: 2000
        });
        if (params.get('error')) Swal.fire('Error', 'No se pudo procesar', 'error');
    </script>
</body>
</html>