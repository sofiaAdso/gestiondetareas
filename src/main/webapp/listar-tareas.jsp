<%-- 1. CONFIGURACIÓN Y SEGURIDAD --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.sena.gestion.model.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sena.gestion.model.Tarea" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Tareas - Gestión de Tareas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background-color: #f5f5f5; display: flex; }

        /* Sidebar */
        .sidebar {
            width: 300px;
            height: 100vh;
            background: linear-gradient(180deg, #7c3aed 0%, #5b21b6 100%);
            color: white;
            padding: 0;
            position: fixed;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
        }
        .sidebar h2 {
            font-size: 1.3rem;
            padding: 30px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin: 0;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .sidebar nav { padding: 20px 0; }
        .sidebar a {
            color: rgba(255,255,255,0.9);
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 25px;
            text-decoration: none;
            transition: 0.3s;
            font-size: 0.95rem;
        }
        .sidebar a i {
            font-size: 1.1rem;
            width: 25px;
        }
        .sidebar a:hover {
            background: rgba(255,255,255,0.1);
            color: white;
        }

        .main-content { margin-left: 300px; padding: 0; width: calc(100% - 300px); background: #f5f5f5; }

        /* Header */
        .page-header {
            background: white;
            padding: 30px 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-header h1 { color: #7c3aed; margin: 0; font-size: 2rem; font-weight: 700; }

        .btn-add {
            background: #7c3aed;
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        .btn-add:hover {
            background: #6d28d9;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(124, 58, 237, 0.4);
        }

        /* Content area */
        .content-area { padding: 40px; }

        /* Estilos de la barra de búsqueda */
        .search-container {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .search-box {
            position: relative;
            flex: 1;
            max-width: 500px;
        }
        .search-box input {
            width: 100%;
            padding: 12px 45px 12px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 14px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        .search-box input:focus {
            outline: none;
            border-color: #7c3aed;
            box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1);
        }
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 16px;
        }
        .clear-search {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            cursor: pointer;
            font-size: 18px;
            display: none;
            transition: color 0.3s;
        }
        .clear-search:hover {
            color: #7c3aed;
        }
        .search-results {
            color: #666;
            font-size: 14px;
            font-weight: 500;
        }
        .no-results {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 16px;
        }
        .no-results i {
            font-size: 48px;
            margin-bottom: 10px;
            display: block;
            color: #ddd;
        }

        /* Tabla */
        .table-container {
            background: white;
            border-radius: 12px;
            padding: 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }
        th { background-color: #7c3aed; color: white; padding: 15px; text-align: left; white-space: nowrap; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; }
        td { padding: 15px; border-bottom: 1px solid #f1f2f6; color: #444; background: white; }
        tr:hover td { background-color: #f9f9f9; }

        .badge-cat { background: #f0fdf4; color: #166534; padding: 6px 12px; border-radius: 6px; font-size: 0.8rem; border: 1px solid #bbf7d0; font-weight: 500; }

        /* Estilos para el selector de estado */
        select.estado-selector {
            padding: 6px 12px;
            border-radius: 8px;
            border: 2px solid #f59e0b;
            background: #f59e0b;
            color: white;
            font-weight: 600;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        select.estado-selector:hover {
            background: #d97706;
            border-color: #d97706;
        }
        select.estado-selector:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2);
        }
        select.estado-selector:disabled {
            background: #f0f0f0;
            color: #666;
            cursor: not-allowed;
            border-color: #ddd;
            opacity: 0.7;
        }

        /* Estado readonly para administrador */
        .estado-readonly {
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid #7c3aed;
            background: #f3f4f6;
            color: #7c3aed;
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-block;
            cursor: help;
        }
        .estado-readonly:hover::after {
            content: "Solo el usuario puede modificar este estado";
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: #2c3e50;
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 0.75rem;
            white-space: nowrap;
            margin-bottom: 5px;
            z-index: 1000;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); }
        .modal-content { background: white; margin: 2% auto; padding: 25px; border-radius: 15px; width: 500px; box-shadow: 0 5px 30px rgba(0,0,0,0.3); }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
        .modal-buttons { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn-save { background: #6a11cb; color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: bold; }
        .btn-close { background: #e0e0e0; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; }
    </style>

    <script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('res') === 'ok') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Operación Exitosa!',
                    text: 'La tarea ha sido procesada correctamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }
            if (urlParams.get('msg') === 'ok') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Tarea Creada!',
                    text: 'La tarea fue creada correctamente.',
                    confirmButtonColor: '#6a11cb',
                    timer: 2000
                });
            }
            if (urlParams.get('msg') === 'estado_actualizado') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Estado Actualizado!',
                    text: 'El estado de la tarea ha sido cambiado exitosamente.',
                    confirmButtonColor: '#6a11cb',
                    timer: 2000
                });
            }
            if (urlParams.get('registro') === 'exito') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Usuario Registrado!',
                    text: 'El nuevo usuario ha sido creado exitosamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }
            if (urlParams.get('error') === 'update') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error al Actualizar',
                    text: 'No se pudo actualizar la tarea. Por favor, revisa los datos e intenta nuevamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }
            if (urlParams.get('error') === '1') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error al Registrar',
                    text: 'No se pudo crear la tarea. Por favor, intenta nuevamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }
        };

        function cambiarEstado(id, nuevoEstado) {
            const selector = document.getElementById('estado_' + id);
            const estadoAnterior = selector.getAttribute('data-estado-anterior') || selector.value;
            selector.setAttribute('data-estado-anterior', estadoAnterior);

            let icono = 'question';
            let color = '#6a11cb';
            if (nuevoEstado === 'Completada') {
                icono = 'success';
                color = '#28a745';
            } else if (nuevoEstado === 'En Progreso') {
                icono = 'info';
                color = '#17a2b8';
            } else if (nuevoEstado === 'Pendiente') {
                icono = 'question';
                color = '#ffc107';
            }

            Swal.fire({
                title: '¿Cambiar estado de la tarea?',
                html: `La tarea cambiará a: <br><strong style="font-size: 1.2em; color: ${color};">${nuevoEstado}</strong>`,
                icon: icono,
                showCancelButton: true,
                confirmButtonColor: color,
                cancelButtonColor: '#aaa',
                confirmButtonText: 'Sí, cambiar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'Tareaservlet?accion=cambiarEstado&id=' + id + '&estado=' + encodeURIComponent(nuevoEstado);
                } else {
                    selector.value = estadoAnterior;
                }
            });
        }

        function confirmarEliminar(id) {
            Swal.fire({
                title: '¿Eliminar tarea?',
                text: "No podrás revertir esto",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, eliminar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'Tareaservlet?accion=eliminar&id=' + id;
                }
            });
        }

        function abrirEditarModal(id, titulo, descripcion, prioridad, estado, catId, fVenc) {
            document.getElementById('modalEditar').style.display = 'block';
            document.getElementById('edit_id').value = id || '';
            document.getElementById('edit_titulo').value = titulo || '';
            document.getElementById('edit_desc').value = descripcion || '';
            document.getElementById('edit_prioridad').value = prioridad || 'Media';
            document.getElementById('edit_estado').value = estado || 'Pendiente';
            document.getElementById('edit_categoria').value = catId || '1';

            if (fVenc && fVenc !== 'null' && fVenc !== '') {
                document.getElementById('edit_venc').value = fVenc;
            } else {
                document.getElementById('edit_venc').value = '';
            }
        }

        function cerrarModal() {
            document.getElementById('modalEditar').style.display = 'none';
        }

        function enviarEdicion() {
            const id = document.getElementById('edit_id').value;
            const titulo = document.getElementById('edit_titulo').value.trim();
            const descripcion = document.getElementById('edit_desc').value;
            const prioridad = document.getElementById('edit_prioridad').value;
            const estado = document.getElementById('edit_estado').value;
            const categoria = document.getElementById('edit_categoria').value;
            const venc = document.getElementById('edit_venc').value;

            if (!titulo || !venc) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Atención',
                    text: 'El título y la fecha de vencimiento son obligatorios.',
                    confirmButtonColor: '#6a11cb'
                });
                return;
            }

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'Tareaservlet';

            const addHiddenInput = (name, value) => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            };

            addHiddenInput('accion', 'actualizar');
            addHiddenInput('txtid', id);
            addHiddenInput('txttitulo', titulo);
            addHiddenInput('txtdescripcion', descripcion);
            addHiddenInput('txtprioridad', prioridad);
            addHiddenInput('txtestado', estado);
            addHiddenInput('txtcategoria', categoria);
            addHiddenInput('txtfecha_vencimiento', venc);

            document.body.appendChild(form);
            form.submit();
        }

        function abrirEditarModalFromButton(button) {
            const id = button.getAttribute('data-id');
            const titulo = button.getAttribute('data-titulo');
            const descripcion = button.getAttribute('data-descripcion');
            const prioridad = button.getAttribute('data-prioridad');
            const estado = button.getAttribute('data-estado');
            const catId = button.getAttribute('data-categoria_id');
            const fVenc = button.getAttribute('data-fecha_vencimiento');

            abrirEditarModal(id, titulo, descripcion, prioridad, estado, catId, fVenc);
        }

        function buscarTareas() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase().trim();
            const table = document.querySelector('table tbody');
            const rows = table.getElementsByTagName('tr');
            const clearBtn = document.querySelector('.clear-search');
            const resultsInfo = document.getElementById('searchResults');

            let visibleCount = 0;
            let totalCount = rows.length;

            clearBtn.style.display = filter ? 'block' : 'none';

            for (let i = 0; i < rows.length; i++) {
                const titleCell = rows[i].getElementsByTagName('td')[0];
                if (titleCell) {
                    const titleText = titleCell.textContent || titleCell.innerText;
                    if (titleText.toLowerCase().indexOf(filter) > -1) {
                        rows[i].style.display = '';
                        visibleCount++;
                    } else {
                        rows[i].style.display = 'none';
                    }
                }
            }

            if (filter) {
                resultsInfo.textContent = `Mostrando ${visibleCount} de ${totalCount} tareas`;
                resultsInfo.style.color = visibleCount === 0 ? '#e74c3c' : '#6a11cb';
            } else {
                resultsInfo.textContent = `Total: ${totalCount} tareas`;
                resultsInfo.style.color = '#666';
            }

            let noResultsMsg = document.getElementById('noResultsMessage');
            if (visibleCount === 0 && filter) {
                if (!noResultsMsg) {
                    noResultsMsg = document.createElement('tr');
                    noResultsMsg.id = 'noResultsMessage';
                    noResultsMsg.innerHTML = '<td colspan="100%" class="no-results"><i class="fas fa-search" style="font-size: 48px; color: #ddd;"></i><br><br>No se encontraron tareas con el título "<strong>' + filter + '</strong>"</td>';
                    table.appendChild(noResultsMsg);
                } else {
                    noResultsMsg.style.display = '';
                    noResultsMsg.innerHTML = '<td colspan="100%" class="no-results"><i class="fas fa-search" style="font-size: 48px; color: #ddd;"></i><br><br>No se encontraron tareas con el título "<strong>' + filter + '</strong>"</td>';
                }
            } else if (noResultsMsg) {
                noResultsMsg.style.display = 'none';
            }
        }

        function limpiarBusqueda() {
            document.getElementById('searchInput').value = '';
            buscarTareas();
            document.getElementById('searchInput').focus();
        }

        window.addEventListener('DOMContentLoaded', function() {
            const table = document.querySelector('table tbody');
            const rows = table.getElementsByTagName('tr');
            const resultsInfo = document.getElementById('searchResults');
            if (resultsInfo) {
                resultsInfo.textContent = `Total: ${rows.length} tareas`;
            }
        });
    </script>
</head>
<body>

    <div class="sidebar">
        <h2>GESTIÓN DE TAREAS</h2>
        <p style="font-size: 0.9rem; opacity: 0.7; padding: 15px 25px; margin: 0; border-bottom: 1px solid rgba(255,255,255,0.1);">Bienvenido, <strong><%= user.getUsername() %></strong></p>
        <nav>
            <a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a>
            <a href="Tareaservlet?accion=listar"><i class="fas fa-clipboard-list"></i> <%= "Administrador".equals(user.getRol()) ? "Tareas" : "Mis Tareas" %></a>
            <a href="ActividadServlet?accion=listar"><i class="fas fa-folder"></i> <%= "Administrador".equals(user.getRol()) ? "Actividades" : "Mis Actividades" %></a>
            <% if ("Administrador".equals(user.getRol())) { %>
                <a href="Tareaservlet?accion=reportes"><i class="fas fa-chart-bar"></i> Reportes</a>
                <a href="Categoriaservlet?accion=listar"><i class="fas fa-pencil"></i> Gestión de Categorías</a>
                <a href="registro_usuario.jsp"><i class="fas fa-users"></i> Gestión de Usuarios</a>
            <% } %>
            <div style="height: 1px; background: rgba(255,255,255,0.1); margin: 15px 0;"></div>
            <a href="index.jsp" style="background: rgba(239, 68, 68, 0.2); border-radius: 8px; margin: 0 20px;"><i class="fas fa-door-open"></i> Cerrar Sesión</a>
        </nav>
    </div>

    <div class="main-content">
        <div class="page-header">
            <h1><%= "Administrador".equals(user.getRol()) ? "Todas las Tareas" : "Mis Tareas" %></h1>
            <% if ("Administrador".equals(user.getRol())) { %>
                <c:choose>
                    <%-- ✅ CORRECCIÓN: se cambió "idActividad" por "actividad_id" para que el servlet lo reciba correctamente --%>
                    <c:when test="${not empty idActividadActual}">
                        <a href="Tareaservlet?accion=nuevo&actividad_id=${idActividadActual}" class="btn-add">
                            <i class="fas fa-plus-circle"></i> Crear Nueva Tarea
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="Tareaservlet?accion=nuevo" class="btn-add">
                            <i class="fas fa-plus-circle"></i> Crear Nueva Tarea
                        </a>
                    </c:otherwise>
                </c:choose>
            <% } %>
        </div>

        <div class="content-area">
            <!-- Barra de búsqueda -->
            <div class="search-container">
                <div class="search-box">
                    <i class="fas fa-search search-icon"></i>
                    <input
                        type="text"
                        id="searchInput"
                        placeholder="Buscar tareas por título..."
                        onkeyup="buscarTareas()"
                        autocomplete="off"
                    />
                    <i class="fas fa-times clear-search" onclick="limpiarBusqueda()" title="Limpiar búsqueda"></i>
                </div>
                <div class="search-results" id="searchResults">Total: tareas</div>
            </div>

            <div class="table-container">
                <table>
            <thead>
                <tr>
                    <th>Actividad</th>
                    <th>Título</th>
                    <th>Descripción</th>
                    <th style="text-align: center;">F. Inicio</th>
                    <th style="text-align: center;">F. Venc.</th>
                    <th style="text-align: center;">Categoría</th>
                    <th style="text-align: center;">Prior.</th>
                    <th style="text-align: center;">Estado</th>
                    <% if ("Administrador".equals(user.getRol())) { %>
                        <th>Asignado a</th>
                        <th>Acciones</th>
                    <% } %>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty listaTareas}">
                        <tr>
                            <td colspan="<%= "Administrador".equals(user.getRol()) ? "10" : "8" %>" style="text-align: center; padding: 40px; color: #999;">
                                <i class="fas fa-inbox" style="font-size: 48px; display: block; margin-bottom: 15px; color: #ddd;"></i>
                                <strong>No hay tareas disponibles</strong>
                                <br>
                                <span style="font-size: 0.9rem;">
                                    <% if ("Administrador".equals(user.getRol())) { %>
                                        Primero crea una actividad, luego podrás agregar tareas a ella.
                                        <br><br>
                                        <a href="ActividadServlet?accion=nuevo" style="color: #6a11cb; font-weight: bold;">
                                            <i class="fas fa-plus"></i> Crear Actividad
                                        </a>
                                    <% } else { %>
                                        El administrador aún no te ha asignado ninguna tarea.
                                    <% } %>
                                </span>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="tarea" items="${listaTareas}">
                            <tr>
                                <td>
                                    <strong style="color: #667eea;">
                                        <i class="fas fa-folder"></i>
                                        ${tarea.nombreActividad != null && !tarea.nombreActividad.isEmpty() ? tarea.nombreActividad : '<i style="color: #999;">Sin actividad</i>'}
                                    </strong>
                                </td>
                                <td><strong>${tarea.titulo}</strong></td>
                                <td style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    ${tarea.descripcion != null && !tarea.descripcion.isEmpty() ? tarea.descripcion : '<i>Sin descripción</i>'}
                                </td>
                                <td style="text-align: center;">${tarea.fecha_inicio}</td>
                                <td style="text-align: center;">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty tarea.fecha_vencimiento}">
                                                <fmt:formatDate value="${tarea.fecha_vencimiento}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                <i style="color: #999;">Sin fecha</i>
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </td>
                                <td style="text-align: center;">
                                    <span class="badge-cat">${tarea.nombreCategoria != null ? tarea.nombreCategoria : 'General'}</span>
                                </td>
                                <td style="text-align: center;">${tarea.prioridad}</td>

                        <%-- SELECTOR DE ESTADO DESPLEGABLE --%>
                        <td style="text-align: center;">
                            <% if ("Usuario".equals(user.getRol())) { %>
                                <select id="estado_${tarea.id}"
                                        class="estado-selector"
                                        onchange="cambiarEstado(${tarea.id}, this.value)">
                                    <option value="Pendiente" <c:if test="${tarea.estado eq 'Pendiente'}">selected</c:if>>📋 Pendiente</option>
                                    <option value="En Progreso" <c:if test="${tarea.estado eq 'En Progreso'}">selected</c:if>>⏳ En Progreso</option>
                                    <option value="Completada" <c:if test="${tarea.estado eq 'Completada'}">selected</c:if>>✅ Completada</option>
                                </select>
                            <% } else { %>
                                <select class="estado-selector"
                                        disabled
                                        title="Solo el usuario asignado puede modificar el estado">
                                    <option value="Pendiente" <c:if test="${tarea.estado eq 'Pendiente'}">selected</c:if>>📋 Pendiente</option>
                                    <option value="En Progreso" <c:if test="${tarea.estado eq 'En Progreso'}">selected</c:if>>⏳ En Progreso</option>
                                    <option value="Completada" <c:if test="${tarea.estado eq 'Completada'}">selected</c:if>>✅ Completada</option>
                                </select>
                            <% } %>
                        </td>

                        <% if ("Administrador".equals(user.getRol())) { %>
                            <td>${tarea.nombreUsuario}</td>
                            <td style="white-space: nowrap;">
                                <button class="btn-edit"
                                        data-id="${tarea.id}"
                                        data-titulo="${fn:escapeXml(tarea.titulo)}"
                                        data-descripcion="${fn:escapeXml(tarea.descripcion)}"
                                        data-prioridad="${tarea.prioridad}"
                                        data-estado="${tarea.estado}"
                                        data-categoria_id="${tarea.categoria_id}"
                                        data-fecha_vencimiento="${tarea.fecha_vencimiento}"
                                        onclick="abrirEditarModalFromButton(this)"
                                        style="background:#2196F3; color:white; border:none; padding:5px 10px; border-radius:4px; cursor:pointer;">✏️ Editar</button>
                                <button onclick="confirmarEliminar(${tarea.id})"
                                        style="background:#f44336; color:white; border:none; padding:5px 10px; border-radius:4px; cursor:pointer;">🗑️ Borrar</button>
                            </td>
                        <% } %>
                    </tr>
                </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <%-- MODAL DE EDICIÓN --%>
    <div id="modalEditar" class="modal">
        <div class="modal-content">
            <h3>✏️ Editar Tarea</h3>
            <input type="hidden" id="edit_id">

            <div class="form-group">
                <label>Título</label>
                <input type="text" id="edit_titulo" required>
            </div>

            <div class="form-group">
                <label>Descripción</label>
                <textarea id="edit_desc" rows="3"></textarea>
            </div>

            <div class="form-group">
                <label>Categoría</label>
                <select id="edit_categoria" required>
                    <c:forEach var="cat" items="${listaCategorias}">
                        <option value="${cat.id}">${cat.nombre}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Prioridad</label>
                <select id="edit_prioridad" required>
                    <option value="Baja">Baja</option>
                    <option value="Media">Media</option>
                    <option value="Alta">Alta</option>
                </select>
            </div>

            <div class="form-group">
                <label>Estado</label>
                <select id="edit_estado" required>
                    <option value="Pendiente">Pendiente</option>
                    <option value="En Proceso">En Proceso</option>
                    <option value="Completada">Completada</option>
                </select>
            </div>

            <div class="form-group">
                <label>F. Vencimiento</label>
                <input type="date" id="edit_venc" required>
            </div>

            <div class="modal-buttons">
                <button class="btn-close" onclick="cerrarModal()">Cancelar</button>
                <button class="btn-save" onclick="enviarEdicion()">💾 Guardar Cambios</button>
            </div>
        </div>
    </div>
</body>
</html>


