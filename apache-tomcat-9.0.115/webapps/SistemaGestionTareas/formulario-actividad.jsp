<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // 1. Verificación de sesión y captura de datos
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    if (listaActividades == null) {
        listaActividades = new ArrayList<>();
    }

    // 2. Control de permisos
    boolean isAdmin = "Administrador".equals(user.getRol());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Actividades | Gestión SENA</title>
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
            background: rgba(255, 255, 255, 0.98);
            padding: 30px;
            min-height: 100vh;
        }
        .header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 30px; padding-bottom: 20px; border-bottom: 3px solid #667eea;
        }

        /* Grid y Tarjetas */
        .actividades-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(380px, 1fr)); gap: 25px; }
        .actividad-card {
            background: white; border-radius: 15px; padding: 20px; border: 1px solid #eee;
            transition: 0.3s; position: relative; overflow: hidden; border-left: 8px solid #667eea;
        }
        .actividad-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }

        /* Bordes por Prioridad (opcional si usas color de la BD) */
        .border-alta { border-left-color: #dc3545 !important; }
        .border-media { border-left-color: #ffc107 !important; }
        .border-baja { border-left-color: #28a745 !important; }

        /* Barra de Progreso */
        .progress-container { background: #eee; border-radius: 10px; height: 10px; margin: 15px 0; overflow: hidden; }
        .progress-bar { background: #667eea; height: 100%; transition: width 0.5s ease; }

        /* Estilos de Botones y Selectores */
        .status-select {
            padding: 10px 12px;
            border-radius: 8px;
            font-weight: bold;
            border: 2px solid #ddd;
            cursor: pointer;
            color: white;
            width: 100%;
            margin-top: 5px;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .status-select:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .status-select:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.3);
        }
        .bg-pendiente { background-color: #f39c12; border-color: #e67e22; }
        .bg-en-progreso { background-color: #3498db; border-color: #2980b9; }
        .bg-completada { background-color: #2ecc71; border-color: #27ae60; }

        .btn {
            padding: 8px 15px; border-radius: 8px; text-decoration: none; font-size: 0.85rem;
            font-weight: 600; transition: 0.3s; display: inline-flex; align-items: center; gap: 5px;
        }
        .btn-view { background: white; color: #17a2b8; border: 2px solid #17a2b8; }
        .btn-view:hover { background: #17a2b8; color: white; }
        .btn-edit { background: white; color: #007bff; border: 2px solid #007bff; }
        .btn-edit:hover { background: #007bff; color: white; }
        .btn-del { background: white; color: #dc3545; border: 2px solid #dc3545; }
        .btn-del:hover { background: #dc3545; color: white; }

        /* Barra de filtros */
        .filter-bar {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
            flex: 1;
            min-width: 200px;
        }
        .filter-group label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #555;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .filter-select {
            padding: 10px 12px;
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
            color: #333;
        }
        .filter-select:hover {
            border-color: #667eea;
        }
        .filter-select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-reset {
            padding: 10px 20px;
            border-radius: 8px;
            background: #f0f0f0;
            color: #555;
            border: 2px solid #e0e0e0;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 22px;
        }
        .btn-reset:hover {
            background: #e0e0e0;
            border-color: #ccc;
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="container">
        <div class="header">
            <h1 style="color: #667eea;">Mis Actividades</h1>
            <div style="display: flex; gap: 10px;">
                <% if (isAdmin) { %>
                    <a href="ActividadServlet?accion=nuevo" class="btn" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                        <i class="fas fa-plus"></i> Nueva Actividad
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Barra de Filtros -->
        <div class="filter-bar">
            <div class="filter-group">
                <label for="filtroEstado">
                    <i class="fas fa-filter"></i> Filtrar por Estado
                </label>
                <select id="filtroEstado" class="filter-select" onchange="filtrarActividades()">
                    <option value="todos"> Todos los estados</option>
                    <option value="Pendiente"> Pendiente</option>
                    <option value="En Progreso"> En Progreso</option>
                    <option value="Completada"> Completada</option>
                </select>
            </div>

            <div class="filter-group">
                <label for="filtroPrioridad">
                    <i class="fas fa-exclamation-circle"></i> Filtrar por Prioridad
                </label>
                <select id="filtroPrioridad" class="filter-select" onchange="filtrarActividades()">
                    <option value="todos"> Todas las prioridades</option>
                    <option value="Alta"> Alta</option>
                    <option value="Media"> Media</option>
                    <option value="Baja"> Baja</option>
                </select>
            </div>

            <button class="btn-reset" onclick="resetearFiltros()">
                <i class="fas fa-redo"></i> Limpiar Filtros
            </button>
        </div>

        <% if (!listaActividades.isEmpty()) { %>
            <div class="actividades-grid">
                <% for (Actividad act : listaActividades) {
                    // Lógica de colores y estados
                    String bgEstado = "bg-pendiente";
                    if ("En Progreso".equalsIgnoreCase(act.getEstado())) bgEstado = "bg-en-progreso";
                    else if ("Completada".equalsIgnoreCase(act.getEstado())) bgEstado = "bg-completada";

                    String claseBorde = "border-baja";
                    if ("Alta".equals(act.getPrioridad())) claseBorde = "border-alta";
                    else if ("Media".equals(act.getPrioridad())) claseBorde = "border-media";
                %>
                <div class="actividad-card <%= claseBorde %>"
                     data-estado="<%= act.getEstado() %>"
                     data-prioridad="<%= act.getPrioridad() %>">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <h2 style="font-size: 1.25rem; color: #333;"><%= act.getTitulo() %></h2>
                        <span style="font-size: 0.7rem; color: #888;">ID: #<%= act.getId() %></span>
                    </div>

                    <p style="color: #666; font-size: 0.85rem; margin: 10px 0; min-height: 40px;">
                        <%= act.getDescripcion() %>
                    </p>

                    <%-- Barra de progreso --%>
                    <div style="display: flex; justify-content: space-between; font-size: 0.75rem; color: #555;">
                        <span>Progreso tareas</span>
                        <span><%= Math.round(act.getPorcentajeCompletado()) %>%</span>
                    </div>
                    <div class="progress-container">
                        <div class="progress-bar" style="width: <%= act.getPorcentajeCompletado() %>%"></div>
                    </div>

                    <%-- Selector de estado - Visible para todos --%>
                    <label style="font-size: 0.8rem; font-weight: bold; color: #555; margin-top: 15px; display: block; margin-bottom: 5px;">
                        <i class="fas fa-tasks"></i> Estado de la actividad:
                    </label>
                    <select class="status-select <%= bgEstado %>"
                            onchange="confirmarCambioEstado(<%= act.getId() %>, this.value)">
                        <option value="Pendiente" <%= "Pendiente".equals(act.getEstado()) ? "selected" : "" %>> Pendiente</option>
                        <option value="En Progreso" <%= "En Progreso".equals(act.getEstado()) ? "selected" : "" %>> En Progreso</option>
                        <option value="Completada" <%= "Completada".equals(act.getEstado()) ? "selected" : "" %>> Completada</option>
                    </select>


                    <%-- Botones de acción --%>
                    <div style="margin-top: 20px; display: flex; gap: 8px; flex-wrap: wrap;">
                        <a href="ActividadServlet?accion=ver&id=<%= act.getId() %>" class="btn btn-view" title="Ver detalle">
                            <i class="fas fa-eye"></i> Ver
                        </a>
                        <% if (isAdmin) { %>
                        <a href="ActividadServlet?accion=editar&id=<%= act.getId() %>" class="btn btn-edit" title="Editar actividad">
                            <i class="fas fa-edit"></i> Editar
                        </a>
                        <a href="javascript:void(0);" onclick="confirmarEliminar(<%= act.getId() %>)" class="btn btn-del" title="Eliminar actividad">
                            <i class="fas fa-trash"></i> Eliminar
                        </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div style="text-align:center; padding: 100px 0; color: #999;">
                <i class="fas fa-folder-open fa-4x"></i>
                <p style="margin-top:20px; font-size: 1.2rem;">No hay actividades disponibles.</p>
            </div>
        <% } %>
    </div>

    <script>
        function confirmarCambioEstado(id, nuevoEstado) {
            Swal.fire({
                title: '¿Actualizar estado?',
                text: "La actividad cambiará a: " + nuevoEstado,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#667eea',
                confirmButtonText: 'Sí, cambiar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'ActividadServlet?accion=cambiarEstado&id=' + id + '&estado=' + encodeURIComponent(nuevoEstado);
                } else {
                    location.reload(); // Revierte el select si cancela
                }
            });
        }

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

        // Función para filtrar actividades
        function filtrarActividades() {
            const filtroEstado = document.getElementById('filtroEstado').value;
            const filtroPrioridad = document.getElementById('filtroPrioridad').value;
            const tarjetas = document.querySelectorAll('.actividad-card');
            let contadorVisibles = 0;

            tarjetas.forEach(tarjeta => {
                const estado = tarjeta.getAttribute('data-estado');
                const prioridad = tarjeta.getAttribute('data-prioridad');

                const cumpleEstado = filtroEstado === 'todos' || estado === filtroEstado;
                const cumplePrioridad = filtroPrioridad === 'todos' || prioridad === filtroPrioridad;

                if (cumpleEstado && cumplePrioridad) {
                    tarjeta.style.display = 'block';
                    contadorVisibles++;
                } else {
                    tarjeta.style.display = 'none';
                }
            });

            // Mostrar mensaje si no hay resultados
            const grid = document.querySelector('.actividades-grid');
            let mensajeNoResultados = document.getElementById('mensajeNoResultados');

            if (contadorVisibles === 0) {
                if (!mensajeNoResultados) {
                    mensajeNoResultados = document.createElement('div');
                    mensajeNoResultados.id = 'mensajeNoResultados';
                    mensajeNoResultados.style.cssText = 'grid-column: 1/-1; text-align:center; padding: 60px 0; color: #999;';
                    mensajeNoResultados.innerHTML = `
                        <i class="fas fa-search" style="font-size: 48px; display: block; margin-bottom: 15px; color: #ddd;"></i>
                        <p style="font-size: 1.1rem; font-weight: 600;">No se encontraron actividades</p>
                        <p style="font-size: 0.9rem; margin-top: 10px;">Intenta con otros filtros</p>
                    `;
                    grid.appendChild(mensajeNoResultados);
                }
            } else {
                if (mensajeNoResultados) {
                    mensajeNoResultados.remove();
                }
            }
        }

        // Función para resetear filtros
        function resetearFiltros() {
            document.getElementById('filtroEstado').value = 'todos';
            document.getElementById('filtroPrioridad').value = 'todos';
            filtrarActividades();
        }
    </script>
</body>
</html>
