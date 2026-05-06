<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.sena.gestion.model.Usuario" %>
<%@ page import="com.sena.gestion.model.Categoria" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null || !"Administrador".equals(user.getRol())) {
        response.sendRedirect("index.jsp");
        return;
    }

    Categoria categoriaEditar = (Categoria) request.getAttribute("categoriaEditar");
    boolean esEdicion = (categoriaEditar != null);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Categorías</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5; display: flex; }

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
        .page-header {
            background: white;
            padding: 30px 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-header h1 { color: #7c3aed; margin: 0; font-size: 2rem; font-weight: 700; }

        .content-area { padding: 40px; }

        .btn-add {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-add:hover { opacity: 0.9; }

        /* Formulario de nueva categoría */
        .form-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .form-card h3 {
            color: #6a11cb;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
            transition: border 0.3s;
        }
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #6a11cb;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        .form-buttons {
            display: flex;
            gap: 10px;
        }
        .btn-cancel {
            background: #e0e0e0;
            color: #333;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-cancel:hover { background: #d0d0d0; }

        /* Tabla de categorías */
        table { width: 100%; border-collapse: collapse; box-shadow: 0 5px 15px rgba(0,0,0,0.05); background: white; }
        th { background-color: #6a11cb; color: white; padding: 12px; text-align: left; white-space: nowrap; }
        td { padding: 12px; border-bottom: 1px solid #eee; color: #444; }
        tr:hover { background-color: #f9f6ff; }

        .btn-edit, .btn-delete {
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            border: 2px solid;
            cursor: pointer;
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
        }
        .btn-delete:hover {
            background: #dc3545;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        .char-counter {
            font-size: 12px;
            color: #666;
            text-align: right;
            margin-top: 5px;
        }
        .char-counter.warning { color: #f39c12; font-weight: bold; }
        .char-counter.limit { color: #e74c3c; font-weight: bold; }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-tags"></i> Gestión de Categorías</h1>
            <% if (!esEdicion) { %>
                <button onclick="mostrarFormulario()" class="btn-add" id="btnMostrarForm">
                    <i class="fas fa-plus"></i> Nueva Categoría
                </button>
            <% } %>
        </div>

        <div class="content-area">
        <!-- Formulario de nueva/editar categoría -->
        <div class="form-card" id="formCard" style="<%= esEdicion ? "" : "display: none;" %>">
            <h3>
                <i class="fas <%= esEdicion ? "fa-edit" : "fa-plus-circle" %>"></i>
                <%= esEdicion ? "Editar Categoría" : "Nueva Categoría" %>
            </h3>
            <form action="Categoriaservlet" method="POST" onsubmit="return validarFormulario()">
                <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "registrar" %>">
                <% if (esEdicion) { %>
                    <input type="hidden" name="txtid" value="<%= categoriaEditar.getId() %>">
                <% } %>

                <div class="form-group">
                    <label for="nombre">Nombre de la Categoría *</label>
                    <input
                        type="text"
                        id="nombre"
                        name="txtnombre"
                        maxlength="50"
                        value="<%= esEdicion ? categoriaEditar.getNombre() : "" %>"
                        required
                        placeholder="Ej: Marketing, Ventas, IT...">
                    <div class="char-counter" id="contador-nombre">0 / 50 caracteres</div>
                </div>

                <div class="form-group">
                    <label for="descripcion">Descripción</label>
                    <textarea
                        id="descripcion"
                        name="txtdescripcion"
                        maxlength="200"
                        placeholder="Descripción de la categoría (opcional)"><%= esEdicion ? categoriaEditar.getDescripcion() : "" %></textarea>
                    <div class="char-counter" id="contador-descripcion">0 / 200 caracteres</div>
                </div>

                <div class="form-buttons">
                    <button type="submit" class="btn-add">
                        <i class="fas fa-save"></i> <%= esEdicion ? "Guardar Cambios" : "Crear Categoría" %>
                    </button>
                    <% if (esEdicion) { %>
                        <a href="Categoriaservlet?accion=listar" class="btn-cancel">
                            <i class="fas fa-times"></i> Cancelar
                        </a>
                    <% } else { %>
                        <button type="button" onclick="ocultarFormulario()" class="btn-cancel">
                            <i class="fas fa-times"></i> Cancelar
                        </button>
                    <% } %>
                </div>
            </form>
        </div>

        <!-- Tabla de categorías -->
        <table>
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th style="width: 240px; text-align: center;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="categoria" items="${listaCategorias}">
                    <tr>
                        <td><strong>${categoria.nombre}</strong></td>
                        <td>${categoria.descripcion != null && !categoria.descripcion.isEmpty() ? categoria.descripcion : '<i style="color: #999;">Sin descripción</i>'}</td>
                        <td style="text-align: center;">
                            <div style="display: flex; justify-content: center; align-items: center; gap: 8px; flex-wrap: wrap;">
                                <a href="Categoriaservlet?accion=editar&id=${categoria.id}" class="btn-edit">
                                    <i class="fas fa-edit"></i> Editar
                                </a>
                                <button onclick="confirmarEliminar(${categoria.id}, '${fn:escapeXml(categoria.nombre)}')" class="btn-delete">
                                    <i class="fas fa-trash"></i> Eliminar
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listaCategorias}">
                    <tr>
                        <td colspan="3" style="text-align: center; padding: 40px; color: #999;">
                            <i class="fas fa-tags" style="font-size: 48px; display: block; margin-bottom: 10px;"></i>
                            No hay categorías registradas. Crea la primera categoría.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <script>
        // Mostrar/ocultar formulario
        function mostrarFormulario() {
            document.getElementById('formCard').style.display = 'block';
            document.getElementById('btnMostrarForm').style.display = 'none';
            document.getElementById('nombre').focus();
        }

        function ocultarFormulario() {
            document.getElementById('formCard').style.display = 'none';
            document.getElementById('btnMostrarForm').style.display = 'inline-flex';
        }

        // Validar formulario
        function validarFormulario() {
            const nombre = document.getElementById('nombre').value.trim();
            if (nombre === '') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Campo requerido',
                    text: 'El nombre de la categoría es obligatorio',
                    confirmButtonColor: '#6a11cb'
                });
                return false;
            }
            return true;
        }

        // Confirmar eliminación
        function confirmarEliminar(id, nombre) {
            Swal.fire({
                title: '¿Eliminar categoría?',
                html: `¿Estás seguro de eliminar la categoría "<strong>${nombre}</strong>"?<br><br>
                       <small style="color: #e74c3c;">Esta acción no se puede deshacer. Si la categoría tiene tareas asignadas, no se podrá eliminar.</small>`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'Categoriaservlet?accion=eliminar&id=' + id;
                }
            });
        }

        // Contador de caracteres
        function actualizarContador(inputId, contadorId, maxLength) {
            const input = document.getElementById(inputId);
            const contador = document.getElementById(contadorId);

            function actualizar() {
                const length = input.value.length;
                contador.textContent = length + ' / ' + maxLength + ' caracteres';
                contador.classList.remove('warning', 'limit');
                if (length >= maxLength) {
                    contador.classList.add('limit');
                } else if (length >= maxLength * 0.8) {
                    contador.classList.add('warning');
                }
            }

            input.addEventListener('input', actualizar);
            input.addEventListener('keyup', actualizar);
            actualizar();
        }

        // Alertas
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);

            if (urlParams.get('res') === 'ok') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Categoría Creada!',
                    text: 'La categoría ha sido registrada exitosamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }

            if (urlParams.get('res') === 'actualizado') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Categoría Actualizada!',
                    text: 'Los cambios se guardaron correctamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }

            if (urlParams.get('res') === 'eliminado') {
                Swal.fire({
                    icon: 'success',
                    title: '¡Categoría Eliminada!',
                    text: 'La categoría ha sido eliminada exitosamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }

            if (urlParams.get('error') === 'tiene_tareas') {
                Swal.fire({
                    icon: 'error',
                    title: 'No se puede eliminar',
                    text: 'Esta categoría tiene tareas asignadas. Reasigna o elimina las tareas primero.',
                    confirmButtonColor: '#6a11cb'
                });
            }

            if (urlParams.get('error') === 'registro' || urlParams.get('error') === 'actualizar') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'No se pudo completar la operación. Intenta nuevamente.',
                    confirmButtonColor: '#6a11cb'
                });
            }

            // Inicializar contadores
            actualizarContador('nombre', 'contador-nombre', 50);
            actualizarContador('descripcion', 'contador-descripcion', 200);
        };
    </script>
    </div>
</body>
</html>

