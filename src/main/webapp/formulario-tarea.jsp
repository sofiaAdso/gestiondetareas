<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("index.jsp"); return; }

    Tarea tareaEditar = (Tarea) request.getAttribute("tarea");
    boolean esEdicion = (tareaEditar != null);

    // Listas enviadas por el Tareaservlet
    List<Categoria> listaCategorias = (List<Categoria>) request.getAttribute("listaCategorias");
    if(listaCategorias == null) listaCategorias = new ArrayList<>();

    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    if(listaActividades == null) listaActividades = new ArrayList<>();

    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");

    // Lógica para saber si venimos desde una actividad específica
    String idActividadParam = request.getParameter("idActividad");
    Object idActividadAttr = request.getAttribute("idActividadPre");
    Integer idActPre = null;

    try {
        if (idActividadParam != null) idActPre = Integer.parseInt(idActividadParam);
        else if (idActividadAttr != null) idActPre = Integer.parseInt(idActividadAttr.toString());
    } catch (Exception e) { }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= esEdicion ? "Editar" : "Nueva" %> Tarea | Gestión SENA</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex; justify-content: center; align-items: center; padding: 20px; min-height: 100vh;
        }
        .form-container {
            background: white; padding: 30px; border-radius: 20px;
            width: 100%; max-width: 650px; box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }
        h2 { color: #667eea; text-align: center; margin-bottom: 20px; font-weight: 700; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: 600; margin-bottom: 5px; color: #444; font-size: 0.9rem; }
        input, select, textarea {
            width: 100%; padding: 10px 15px; border: 2px solid #eee;
            border-radius: 8px; font-size: 14px; transition: 0.3s;
        }
        input:focus, select:focus, textarea:focus { border-color: #667eea; outline: none; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .btn-submit {
            width: 100%; padding: 12px; background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; border: none; border-radius: 10px; cursor: pointer; font-weight: 700;
            margin-top: 20px; transition: 0.3s;
        }
        .btn-submit:hover { opacity: 0.9; transform: translateY(-2px); }
        .btn-back {
            text-decoration: none;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            padding: 10px 20px;
            border-radius: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
        }
        .actividad-info {
            background: #f0f4ff; padding: 10px; border-radius: 8px;
            border-left: 4px solid #667eea; margin-bottom: 15px; font-size: 0.85rem;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <%
            String urlVolver = idActPre != null ?
                "Tareaservlet?accion=listarPorActividad&idActividad=" + idActPre :
                "Tareaservlet?accion=listar";
        %>
        <a href="<%= urlVolver %>" class="btn-back"><i class="fas fa-arrow-left"></i> Volver</a>

        <h2><i class="fas fa-tasks"></i> <%= esEdicion ? "Editar Tarea" : "Nueva Tarea" %></h2>

        <form action="Tareaservlet" method="POST">
            <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "registrar" %>">
            <% if(esEdicion){ %><input type="hidden" name="txtid" value="<%= tareaEditar.getId() %>"><% } %>

            <%-- Campo oculto para garantizar el envío del actividad_id cuando el select está disabled --%>
            <% if (idActPre != null) { %>
                <input type="hidden" name="txtactividad" value="<%= idActPre %>">
            <% } else if (esEdicion) { %>
                <input type="hidden" name="txtactividad" value="<%= tareaEditar.getActividad_id() %>">
            <% } %>

            <div class="form-group">
                <label>Título de la Tarea *</label>
                <input type="text" name="txttitulo" placeholder="Ej: Realizar pruebas unitarias"
                       value="<%= esEdicion ? tareaEditar.getTitulo() : "" %>" required>
            </div>

            <div class="form-group">
                <label>Actividad Relacionada *</label>
                <%-- name siempre presente; disabled solo cuando viene con actividad preseleccionada --%>
                <select name="txtactividad" <%= (idActPre != null) ? "disabled" : "" %> required>
                    <option value="">-- Seleccione una actividad --</option>
                    <% for (Actividad act : listaActividades) {
                        boolean selected = (esEdicion && tareaEditar.getActividad_id() == act.getId()) ||
                                           (idActPre != null && idActPre.equals(act.getId()));
                    %>
                    <option value="<%= act.getId() %>" <%= selected ? "selected" : "" %>><%= act.getTitulo() %></option>
                    <% } %>
                </select>
                <% if(idActPre != null && !esEdicion) { %>
                    <small style="color: #666;">Tarea vinculada automáticamente a la actividad seleccionada.</small>
                <% } %>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label>Categoría *</label>
                    <select name="txtcategoria" required>
                        <option value="">-- Seleccionar --</option>
                        <% for (Categoria cat : listaCategorias) {
                            boolean selected = esEdicion && tareaEditar.getCategoria_id() == cat.getId();
                        %>
                        <option value="<%= cat.getId() %>" <%= selected ? "selected" : "" %>><%= cat.getNombre() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Prioridad *</label>
                    <select name="txtprioridad" required>
                        <option value="Baja" <%= esEdicion && "Baja".equals(tareaEditar.getPrioridad()) ? "selected":"" %>>Baja</option>
                        <option value="Media" <%= (!esEdicion || (esEdicion && "Media".equals(tareaEditar.getPrioridad()))) ? "selected":"" %>>Media</option>
                        <option value="Alta" <%= esEdicion && "Alta".equals(tareaEditar.getPrioridad()) ? "selected":"" %>>Alta</option>
                    </select>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label><i class="fas fa-calendar-plus"></i> Inicio *</label>
                    <input type="date" id="fecha_inicio" name="txtfecha_inicio"
                           value="<%= esEdicion ? tareaEditar.getFecha_inicio() : new java.sql.Date(System.currentTimeMillis()) %>"
                           <% if (!esEdicion) { %>
                           min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                           <% } %>
                           required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-check"></i> Vencimiento *</label>
                    <input type="date" id="fecha_vencimiento" name="txtfecha_vencimiento"
                           value="<%= esEdicion ? tareaEditar.getFecha_vencimiento() : "" %>" required>
                </div>
            </div>

            <% if ("Administrador".equals(user.getRol())) { %>
            <div class="form-group">
                <label>Responsable de la Tarea *</label>
                <select name="txtusuario" required>
                    <% for (Usuario u : listaUsuarios) {
                        boolean selected = (esEdicion && tareaEditar.getUsuario_id() == u.getId()) || (!esEdicion && u.getId() == user.getId());
                    %>
                    <option value="<%= u.getId() %>" <%= selected ? "selected" : "" %>><%= u.getNombre() %></option>
                    <% } %>
                </select>
            </div>
            <% } else { %>
                <input type="hidden" name="txtusuario" value="<%= user.getId() %>">
            <% } %>

            <div class="form-group">
                <label>Descripción</label>
                <textarea name="txtdescripcion" rows="3" placeholder="Detalles adicionales..."><%= esEdicion ? tareaEditar.getDescripcion() : "" %></textarea>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-save"></i> <%= esEdicion ? "Actualizar Tarea" : "Guardar Tarea" %>
            </button>
        </form>
    </div>

    <script>
        const fechaInicio = document.getElementById('fecha_inicio');
        const fechaVencimiento = document.getElementById('fecha_vencimiento');

        <% if (!esEdicion) { %>
        const fechaHoy = new Date();
        fechaHoy.setHours(0, 0, 0, 0);
        const fechaHoyStr = fechaHoy.toISOString().split('T')[0];
        fechaInicio.setAttribute('min', fechaHoyStr);
        <% } %>

        fechaInicio.addEventListener('change', function() {
            const fechaInicioSeleccionada = new Date(this.value + 'T00:00:00');
            const fechaActual = new Date();
            fechaActual.setHours(0, 0, 0, 0);

            <% if (!esEdicion) { %>
            if (fechaInicioSeleccionada < fechaActual) {
                Swal.fire({
                    icon: 'error',
                    title: 'Fecha inválida',
                    text: 'La fecha de inicio no puede ser anterior al día actual'
                });
                this.value = '';
                fechaVencimiento.removeAttribute('min');
                return;
            }
            <% } %>

            if (fechaVencimiento.value && fechaVencimiento.value <= this.value) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Fecha inválida',
                    text: 'La fecha de vencimiento debe ser posterior a la fecha de inicio'
                });
                fechaVencimiento.value = '';
            }

            if (this.value) {
                const fechaInicioObj = new Date(this.value + 'T00:00:00');
                fechaInicioObj.setDate(fechaInicioObj.getDate() + 1);
                const fechaMinimaVencimiento = fechaInicioObj.toISOString().split('T')[0];
                fechaVencimiento.setAttribute('min', fechaMinimaVencimiento);
            }
        });

        fechaVencimiento.addEventListener('change', function() {
            if (fechaInicio.value && this.value <= fechaInicio.value) {
                Swal.fire({
                    icon: 'error',
                    title: 'Fecha inválida',
                    text: 'La fecha de vencimiento debe ser posterior a la fecha de inicio'
                });
                this.value = '';
            }
        });

        document.querySelector('form').addEventListener('submit', function(e) {
            const inicio = document.getElementById('fecha_inicio').value;
            const vencimiento = document.getElementById('fecha_vencimiento').value;

            if (!inicio || !vencimiento) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Campos requeridos',
                    text: 'Las fechas de inicio y vencimiento son obligatorias'
                });
                return false;
            }

            <% if (!esEdicion) { %>
            const fechaInicioDate = new Date(inicio + 'T00:00:00');
            const fechaActual = new Date();
            fechaActual.setHours(0, 0, 0, 0);

            if (fechaInicioDate < fechaActual) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Fecha inválida',
                    text: 'La fecha de inicio no puede ser anterior al día actual'
                });
                return false;
            }
            <% } %>

            if (vencimiento <= inicio) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Fechas inválidas',
                    text: 'La fecha de vencimiento debe ser posterior a la fecha de inicio'
                });
                return false;
            }

            return true;
        });
    </script>
</body>
</html>