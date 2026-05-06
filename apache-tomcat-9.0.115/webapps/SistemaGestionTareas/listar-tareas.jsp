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

        /* SIDEBAR */
        .sidebar {
            width: 300px; background: linear-gradient(180deg, #7c3aed 0%, #5b21b6 100%);
            position: fixed; height: 100vh; overflow-y: auto; box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar-header { padding: 30px 20px; color: white; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h2 { font-size: 1.3rem; font-weight: 600; letter-spacing: 0.5px; margin: 0; }
        .user-profile { padding: 15px 25px; border-bottom: 1px solid rgba(255,255,255,0.1); color: white; }
        .nav-menu { padding: 20px 0; }
        .nav-item {
            display: flex; align-items: center; gap: 12px; padding: 15px 25px;
            color: rgba(255,255,255,0.9); text-decoration: none; transition: all 0.3s; font-size: 0.95rem;
        }
        .nav-item:hover { background: rgba(255,255,255,0.1); color: white; }
        .nav-item.active { background: rgba(255,255,255,0.15); color: white; border-left: 4px solid white; }
        .nav-item i { font-size: 1.1rem; width: 25px; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 15px 20px; }
        .logout-btn { background: rgba(239, 68, 68, 0.2) !important; color: white !important; margin: 10px 20px; border-radius: 8px; }

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
            overflow-x: auto;
            overflow-y: visible;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
            min-width: 1400px;
        }
        th {
            background-color: #7c3aed;
            color: white;
            padding: 16px 12px;
            text-align: left;
            white-space: nowrap;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.72rem;
            letter-spacing: 0.5px;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        td {
            padding: 14px 12px;
            border-bottom: 1px solid #f1f2f6;
            color: #444;
            background: white;
            vertical-align: middle;
        }
        tr:hover td { background-color: #f9f9f9; }

        /* Anchos específicos para cada columna */
        th:nth-child(1), td:nth-child(1) { width: 180px; min-width: 180px; } /* Actividad */
        th:nth-child(2), td:nth-child(2) { width: 200px; min-width: 200px; } /* Título */
        th:nth-child(3), td:nth-child(3) { width: 280px; min-width: 280px; max-width: 280px; } /* Descripción */
        th:nth-child(4), td:nth-child(4) { width: 110px; min-width: 110px; text-align: center; } /* F. Inicio */
        th:nth-child(5), td:nth-child(5) { width: 110px; min-width: 110px; text-align: center; } /* F. Venc */
        th:nth-child(6), td:nth-child(6) { width: 120px; min-width: 120px; text-align: center; } /* Categoría */
        th:nth-child(7), td:nth-child(7) { width: 90px; min-width: 90px; text-align: center; } /* Prioridad */
        th:nth-child(8), td:nth-child(8) { width: 140px; min-width: 140px; text-align: center; } /* Estado */
        th:nth-child(9), td:nth-child(9) { width: 120px; min-width: 120px; } /* Asignado */
        th:nth-child(10), td:nth-child(10) { width: 150px; min-width: 150px; } /* Acciones */

        /* Mejorar descripción con ellipsis */
        td:nth-child(3) {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }


        .badge-cat {
            background: #f0fdf4;
            color: #166534;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            border: 1px solid #bbf7d0;
            font-weight: 500;
            display: inline-block;
            white-space: nowrap;
        }

        /* Badge de usuario asignado */
        .badge-usuario {
            background: #ede9fe;
            color: #5b21b6;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.82rem;
            border: 1px solid #c4b5fd;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }
        .badge-usuario i {
            font-size: 14px;
        }

        /* Badges de prioridad */
        .badge-prioridad {
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            text-align: center;
            white-space: nowrap;
        }
        .badge-alta { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .badge-media { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
        .badge-baja { background: #dbeafe; color: #1e40af; border: 1px solid #bfdbfe; }

        /* Badges de estado */
        .badge-estado-pendiente,
        .badge-estado-progreso,
        .badge-estado-completada {
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-block;
            text-align: center;
            white-space: nowrap;
        }
        .badge-estado-pendiente { background: #fff9e6; color: #856404; border: 1px solid #ffeaa7; }
        .badge-estado-progreso { background: #e3f2fd; color: #0d47a1; border: 1px solid #90caf9; }
        .badge-estado-completada { background: #e8f5e9; color: #2e7d32; border: 1px solid #81c784; }

        /* Botones de acción */
        .btn-edit, .btn-delete {
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: 2px solid;
            text-decoration: none;
        }
        .btn-edit {
            color: #007bff;
            border-color: #007bff;
            background: transparent;
        }
        .btn-edit:hover {
            background: #007bff;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
        }
        .btn-delete {
            color: #dc3545;
            border-color: #dc3545;
            background: transparent;
            margin-left: 6px;
        }
        .btn-delete:hover {
            background: #dc3545;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

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

    <jsp:include page="components/header.jsp" />

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
                    <th>ACTIVIDAD</th>
                    <th>TÍTULO</th>
                    <th>DESCRIPCIÓN</th>
                    <th>F. INICIO</th>
                    <th>F. VENC.</th>
                    <th>CATEGORÍA</th>
                    <th>PRIOR.</th>
                    <th>ESTADO</th>
                    <% if ("Administrador".equals(user.getRol())) { %>
                        <th>ASIGNADO A</th>
                        <th>ACCIONES</th>
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
                                        ${tarea.nombreActividad != null && !tarea.nombreActividad.isEmpty() ? tarea.nombreActividad : '<i style="color: #999;">Sin actividad</i>'}
                                    </strong>
                                </td>
                                <td><strong style="color: #2c3e50;">${tarea.titulo}</strong></td>
                                <td title="${tarea.descripcion}">
                                    ${tarea.descripcion != null && !tarea.descripcion.isEmpty() ? tarea.descripcion : '<i>Sin descripción</i>'}
                                </td>
                                <td>${tarea.fecha_inicio}</td>
                                <td>
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
                                <td>
                                    <span class="badge-cat">${tarea.nombreCategoria != null ? tarea.nombreCategoria : 'General'}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tarea.prioridad == 'Alta'}">
                                            <span class="badge-prioridad badge-alta">Alta</span>
                                        </c:when>
                                        <c:when test="${tarea.prioridad == 'Media'}">
                                            <span class="badge-prioridad badge-media">Media</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-prioridad badge-baja">Baja</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                        <%-- SELECTOR DE ESTADO DESPLEGABLE --%>
                        <td>
                            <c:choose>
                                <c:when test="${tarea.estado eq 'Pendiente'}">
                                    <span class="badge-estado-pendiente">Pendiente</span>
                                </c:when>
                                <c:when test="${tarea.estado eq 'En Progreso'}">
                                    <span class="badge-estado-progreso">En Progreso</span>
                                </c:when>
                                <c:when test="${tarea.estado eq 'Completada'}">
                                    <span class="badge-estado-completada">Completada</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-estado-pendiente">${tarea.estado}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <% if ("Administrador".equals(user.getRol())) { %>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty tarea.nombreUsuario}">
                                        <span class="badge-usuario">
                                            <i class="fas fa-user-circle"></i>
                                            ${tarea.nombreUsuario}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999; font-style: italic; font-size: 0.85rem;">
                                            <i class="fas fa-user-slash"></i> Sin asignar
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="white-space: nowrap;">
                                <button class="btn-edit"
                                        data-id="${tarea.id}"
                                        data-titulo="${fn:escapeXml(tarea.titulo)}"
                                        data-descripcion="${fn:escapeXml(tarea.descripcion)}"
                                        data-prioridad="${tarea.prioridad}"
                                        data-estado="${tarea.estado}"
                                        data-categoria_id="${tarea.categoria_id}"
                                        data-fecha_vencimiento="${tarea.fecha_vencimiento}"
                                        onclick="abrirEditarModalFromButton(this)">
                                    <i class="fas fa-edit"></i> Editar
                                </button>
                                <button class="btn-delete" onclick="confirmarEliminar(${tarea.id})">
                                    <i class="fas fa-trash"></i> Borrar
                                </button>
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


