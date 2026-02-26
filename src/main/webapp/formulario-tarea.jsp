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

    List<Categoria> listaCategorias = (List<Categoria>) request.getAttribute("listaCategorias");
    if(listaCategorias == null) listaCategorias = new ArrayList<>();

    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    if(listaActividades == null) listaActividades = new ArrayList<>();

    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");

    // Lógica de preselección robusta
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
    <title><%= esEdicion ? "Editar" : "Nueva" %> Tarea</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex; justify-content: center; padding: 20px; min-height: 100vh;
        }
        .form-container {
            background: white; padding: 35px; border-radius: 20px;
            width: 100%; max-width: 600px; box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }
        h2 { color: #667eea; text-align: center; margin-bottom: 25px; font-size: 28px; font-weight: 700; }
        .form-group { margin-bottom: 20px; }
        label { display: flex; align-items: center; gap: 8px; font-weight: 600; margin-bottom: 8px; color: #333; font-size: 14px; }
        input, select, textarea {
            width: 100%; padding: 12px 15px; border: 2px solid #e0e0e0;
            border-radius: 10px; font-size: 14px; transition: all 0.3s ease;
        }
        input:focus, select:focus, textarea:focus {
            outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-submit {
            width: 100%; padding: 14px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; border-radius: 12px; cursor: pointer; font-size: 16px;
            font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 10px;
            margin-top: 25px; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-back {
            display: inline-flex; align-items: center; gap: 10px; margin-bottom: 20px;
            padding: 10px 20px; background: #f8f9fa; color: #667eea; text-decoration: none;
            font-weight: 600; border-radius: 10px; border: 1px solid #667eea;
        }
        .char-counter { font-size: 11px; color: #999; text-align: right; margin-top: 4px; }
        .limit { color: #e74c3c; font-weight: bold; }
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

        <h2><%= esEdicion ? "Editar Tarea" : "Nueva Tarea" %></h2>

        <form action="Tareaservlet" method="POST">
            <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "registrar" %>">
            <% if(esEdicion){ %><input type="hidden" name="txtid" value="<%= tareaEditar.getId() %>"><% } %>

            <%-- SOLUCIÓN AL ERROR: Campo oculto si el select está disabled --%>
            <% if (!esEdicion && idActPre != null) { %>
                <input type="hidden" name="txtactividad" value="<%= idActPre %>">
            <% } %>

            <%-- Título --%>
            <div class="form-group">
                <label><i class="fas fa-heading"></i> Título *</label>
                <input type="text" id="titulo" name="txttitulo" maxlength="60"
                       value="<%= esEdicion ? tareaEditar.getTitulo() : "" %>" required>
                <div class="char-counter" id="contador-titulo">0 / 60</div>
            </div>

            <%-- Actividad --%>
            <div class="form-group">
                <label><i class="fas fa-folder-open"></i> Actividad *</label>
                <%-- Si es nuevo y viene de una actividad, desactivamos el select pero el hidden de arriba envía el dato --%>
                <select <%= (!esEdicion && idActPre != null) ? "disabled" : "name='txtactividad'" %> required>
                    <option value="">-- Seleccionar Actividad --</option>
                    <% for (Actividad act : listaActividades) {
                        boolean isSelected = (esEdicion && tareaEditar.getActividad_id() == act.getId()) ||
                                           (!esEdicion && idActPre != null && idActPre.equals(act.getId()));
                    %>
                    <option value="<%= act.getId() %>" <%= isSelected ? "selected" : "" %>><%= act.getTitulo() %></option>
                    <% } %>
                </select>
            </div>

            <%-- Categoría y Prioridad --%>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label><i class="fas fa-tags"></i> Categoría *</label>
                    <select name="txtcategoria" required>
                        <option value="">-- Categoría --</option>
                        <% for (Categoria cat : listaCategorias) {
                                boolean selected = esEdicion && tareaEditar.getCategoria_id() == cat.getId();
                        %>
                        <option value="<%= cat.getId() %>" <%= selected ? "selected" : "" %>><%= cat.getNombre() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-flag"></i> Prioridad *</label>
                    <select name="txtprioridad" required>
                        <option value="Baja" <%= esEdicion && "Baja".equals(tareaEditar.getPrioridad()) ? "selected":"" %>>Baja</option>
                        <option value="Media" <%= (esEdicion && "Media".equals(tareaEditar.getPrioridad())) || !esEdicion ? "selected":"" %>>Media</option>
                        <option value="Alta" <%= esEdicion && "Alta".equals(tareaEditar.getPrioridad()) ? "selected":"" %>>Alta</option>
                    </select>
                </div>
            </div>

            <%-- Fechas --%>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label><i class="fas fa-calendar-plus"></i> Inicio *</label>
                    <input type="date" id="fecha_inicio" name="txtfecha_inicio"
                           value="<%= esEdicion ? tareaEditar.getFecha_inicio() : new java.sql.Date(System.currentTimeMillis()) %>" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-check"></i> Vencimiento *</label>
                    <input type="date" id="fecha_vencimiento" name="txtfecha_vencimiento"
                           value="<%= esEdicion ? tareaEditar.getFecha_vencimiento() : "" %>" required>
                </div>
            </div>

            <%-- Asignación (Solo Admin) --%>
            <% if ("Administrador".equals(user.getRol())) { %>
            <div class="form-group">
                <label><i class="fas fa-user-tag"></i> Asignar a Usuario *</label>
                <select name="txtusuario" required>
                    <% if (listaUsuarios != null) {
                        for (Usuario u : listaUsuarios) {
                            boolean selected = (esEdicion && tareaEditar.getUsuario_id() == u.getId()) || (!esEdicion && u.getId() == user.getId());
                    %>
                    <option value="<%= u.getId() %>" <%= selected ? "selected" : "" %>><%= u.getNombre() %></option>
                    <% } } %>
                </select>
            </div>
            <% } else { %>
                <input type="hidden" name="txtusuario" value="<%= user.getId() %>">
            <% } %>

            <%-- Estado (Solo en edición) --%>
            <% if (esEdicion) { %>
            <div class="form-group">
                <label><i class="fas fa-spinner"></i> Estado</label>
                <select name="txtestado">
                    <option value="Pendiente" <%= "Pendiente".equals(tareaEditar.getEstado()) ? "selected":"" %>>Pendiente</option>
                    <option value="En Proceso" <%= "En Proceso".equals(tareaEditar.getEstado()) ? "selected":"" %>>En Proceso</option>
                    <option value="Completada" <%= "Completada".equals(tareaEditar.getEstado()) ? "selected":"" %>>Completada</option>
                </select>
            </div>
            <% } %>

            <div class="form-group">
                <label><i class="fas fa-align-left"></i> Descripción</label>
                <textarea id="descripcion" name="txtdescripcion" maxlength="250" rows="2"><%= esEdicion ? tareaEditar.getDescripcion() : "" %></textarea>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-save"></i> <%= esEdicion ? "Guardar Cambios" : "Crear Tarea" %>
            </button>
        </form>
    </div>

    <script>
        // JS simplificado para contadores y validación de fechas
        document.addEventListener('DOMContentLoaded', () => {
            const form = document.querySelector('form');
            form.addEventListener('submit', (e) => {
                const inicio = new Date(document.getElementById('fecha_inicio').value);
                const fin = new Date(document.getElementById('fecha_vencimiento').value);
                if (fin < inicio) {
                    e.preventDefault();
                    Swal.fire('Error', 'La fecha de vencimiento es menor a la de inicio', 'warning');
                }
            });
        });
    </script>
</body>
</html>