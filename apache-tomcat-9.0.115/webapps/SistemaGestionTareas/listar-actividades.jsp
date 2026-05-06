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
            display: flex;
        }
        .container {
            margin-left: 300px;
            width: calc(100% - 300px);
            max-width: 100%;
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            min-height: 100vh;
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
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 5px solid #667eea;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .actividad-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }

        .actividad-titulo {
            color: #333;
            margin-bottom: 10px;
            font-size: 1.2rem;
            font-weight: 600;
            word-wrap: break-word;
        }
        .actividad-descripcion {
            color: #666;
            font-size: 0.85rem;
            margin-bottom: 15px;
            flex-grow: 1;
            line-height: 1.4;
        }

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
        .btn-ver:hover {
            background: #17a2b8;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(23, 162, 184, 0.3);
        }
        .btn-editar:hover {
            background: #007bff;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
        }
        .btn-eliminar:hover {
            background: #dc3545;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        /* Estilos mejorados para el selector de estado */
        select[id^="estado_act_"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.25) !important;
        }

        select[id^="estado_act_"]:focus {
            outline: none;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.2), 0 5px 15px rgba(0,0,0,0.25) !important;
        }

        /* Animación al cargar */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .actividad-card {
            animation: fadeInUp 0.5s ease-out;
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

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
            <h1><%= "Administrador".equals(user.getRol()) ? "Actividades" : "Mis Actividades" %></h1>
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
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; margin-bottom: 10px;">
                        <h2 class="actividad-titulo"><%= titulo %></h2>
                        <span class="badge <%= claseEstado %>">
                            <%= estado %>
                        </span>
                    </div>

                    <p class="actividad-descripcion"><%= desc %></p>

                    <div class="actividad-actions" style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: auto;">
                        <a href="ActividadServlet?accion=ver&id=<%= act.getId() %>" class="btn-ver" style="text-decoration:none; color:#17a2b8; padding: 8px 16px; border-radius: 8px; border: 2px solid #17a2b8; font-size: 0.85rem; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; transition: all 0.3s ease;">
                            <i class="fas fa-eye"></i> Ver
                        </a>

                        <% if ("Administrador".equals(user.getRol())) { %>
                            <a href="ActividadServlet?accion=editar&id=<%= act.getId() %>" class="btn-editar" style="text-decoration:none; color:#007bff; padding: 8px 16px; border-radius: 8px; border: 2px solid #007bff; font-size: 0.85rem; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; transition: all 0.3s ease;">
                                <i class="fas fa-edit"></i> Editar
                            </a>
                            <a href="javascript:void(0)" onclick="confirmarEliminar(<%= act.getId() %>)" class="btn-eliminar" style="text-decoration:none; color:#dc3545; padding: 8px 16px; border-radius: 8px; border: 2px solid #dc3545; font-size: 0.85rem; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; transition: all 0.3s ease;">
                                <i class="fas fa-trash"></i> Eliminar
                            </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 50px;">
                <h3 style="margin-top: 20px; color: #666;">No hay actividades para mostrar</h3>
                <p>Crea una nueva actividad para comenzar a gestionar tus tareas.</p>
            </div>
        <% } %>
    </div>

    <script>
        function confirmarEliminar(id) {
            Swal.fire({
                title: '¿Eliminar actividad?',
                text: "Se borrarán todas las tareas asociadas. Esta acción no se puede deshacer.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e74c3c',
                confirmButtonText: 'Sí, eliminar todo',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'ActividadServlet?accion=eliminar&id=' + id;
                }
            });
        }

        function cambiarEstado(actividadId, selectElement) {
            const nuevoEstado = selectElement.value;
            const estadoAnterior = selectElement.getAttribute('data-estado-actual');

            console.log('Cambio detectado:', {
                actividadId: actividadId,
                estadoAnterior: estadoAnterior,
                nuevoEstado: nuevoEstado
            });

            // Si el estado no cambió, no hacer nada
            if (nuevoEstado === estadoAnterior) {
                console.log('Sin cambios, retornando');
                return;
            }

            // Configurar ícono y color según el estado
            let icono = 'question';
            let color = '#6a11cb';
            let titulo = '¿Cambiar estado de la actividad?';
            let mensaje = 'La actividad cambiará de estado.';

            switch(nuevoEstado) {
                case 'Pendiente':
                    icono = 'question';
                    color = '#ffc107';
                    titulo = '¿Cambiar a Pendiente?';
                    mensaje = 'La actividad quedará marcada como pendiente.';
                    break;
                case 'En Progreso':
                    icono = 'info';
                    color = '#e65100';
                    titulo = '¿Cambiar a En Progreso?';
                    mensaje = 'La actividad se marcará como en progreso.';
                    break;
                case 'Completada':
                    icono = 'success';
                    color = '#28a745';
                    titulo = '¿Marcar como Completada?';
                    mensaje = '¡Excelente! La actividad se marcará como terminada.';
                    break;
            }

            Swal.fire({
                title: titulo,
                html: mensaje,
                icon: icono,
                showCancelButton: true,
                confirmButtonColor: color,
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, cambiar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    console.log('Usuario confirmó el cambio');

                    // Actualizar el atributo data con el nuevo estado
                    selectElement.setAttribute('data-estado-actual', nuevoEstado);

                    // Mostrar loading
                    Swal.fire({
                        title: 'Actualizando...',
                        html: 'Por favor espera',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    console.log('Redirigiendo a:', 'ActividadServlet?accion=cambiarEstado&id=' + actividadId + '&estado=' + encodeURIComponent(nuevoEstado));

                    // Redirigir para cambiar el estado
                    window.location.href = 'ActividadServlet?accion=cambiarEstado&id=' + actividadId + '&estado=' + encodeURIComponent(nuevoEstado);
                } else {
                    console.log('Usuario canceló, revirtiendo a:', estadoAnterior);
                    // Revertir el selector al estado anterior
                    selectElement.value = estadoAnterior;
                }
            });
        }

        <%-- Manejo de alertas según la URL --%>
        const params = new URLSearchParams(window.location.search);
        if (params.get('msg') === 'ok') {
            Swal.fire({
                icon: 'success',
                title: '¡Hecho!',
                text: 'Operación exitosa',
                timer: 2000,
                showConfirmButton: false
            });
        }
        if (params.get('msg') === 'estado_actualizado') {
            Swal.fire({
                icon: 'success',
                title: '¡Estado Actualizado!',
                text: 'El estado de la actividad ha sido cambiado correctamente.',
                timer: 2000,
                showConfirmButton: false
            });
        }
        if (params.get('error')) {
            let errorMsg = 'No se pudo procesar la solicitud';
            const error = params.get('error');

            switch(error) {
                case 'sin_permiso':
                    errorMsg = 'No tienes permiso para realizar esta acción';
                    break;
                case 'no_encontrada':
                    errorMsg = 'La actividad no fue encontrada';
                    break;
                case 'datos_invalidos':
                    errorMsg = 'Los datos proporcionados son inválidos';
                    break;
                case 'actualizar':
                    errorMsg = 'Error al actualizar el estado';
                    break;
            }

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: errorMsg
            });
        }
    </script>
</body>
</html>