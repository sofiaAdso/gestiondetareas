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
    if (listaCategorias == null) listaCategorias = new ArrayList<>();

    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    if (listaActividades == null) listaActividades = new ArrayList<>();

    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");
    if (listaUsuarios == null) listaUsuarios = new ArrayList<>();

    String idActividadParam = request.getParameter("idActividad");
    Object idActividadAttr  = request.getAttribute("idActividadPre");
    Integer idActPre = null;
    try {
        if (idActividadParam != null && !idActividadParam.isEmpty())
            idActPre = Integer.parseInt(idActividadParam);
        else if (idActividadAttr != null)
            idActPre = Integer.parseInt(idActividadAttr.toString());
    } catch (Exception e) { }

    boolean isAdmin = "Administrador".equals(user.getRol());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= esEdicion ? "Editar Tarea" : "Nueva Tarea" %> | Gestión de Tareas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; display: flex;
        }
        .container {
            margin-left: 300px; width: calc(100% - 300px);
            background: rgba(255,255,255,0.97);
            padding: 30px; min-height: 100vh;
        }
        .card {
            background: white; border-radius: 16px; padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1); max-width: 700px; margin: 0 auto;
        }
        .card h2 {
            font-size: 1.5rem; color: #333; margin-bottom: 24px;
            border-bottom: 3px solid #667eea; padding-bottom: 12px;
        }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block; font-weight: 600; color: #555;
            margin-bottom: 6px; font-size: 0.9rem;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%; padding: 10px 14px; border: 2px solid #e0e0e0;
            border-radius: 8px; font-size: 0.95rem; transition: border-color 0.2s;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none; border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .btn-submit {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; border: none; padding: 12px 28px;
            border-radius: 10px; font-size: 1rem; font-weight: 600;
            cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(102,126,234,0.4); }
        .btn-cancel {
            background: #f0f0f0; color: #555; border: none; padding: 12px 20px;
            border-radius: 10px; font-size: 1rem; font-weight: 600;
            cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: 8px; margin-left: 10px;
        }
        .btn-cancel:hover { background: #e0e0e0; }
        .actions { display: flex; align-items: center; margin-top: 24px; }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="container">
        <div class="card">
            <h2>
                <i class="fas fa-<%= esEdicion ? "edit" : "plus-circle" %>" style="color:#667eea;margin-right:10px;"></i>
                <%= esEdicion ? "Editar Tarea" : "Nueva Tarea" %>
            </h2>

            <form action="Tareaservlet" method="POST">
                <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "registrar" %>">
                <% if (esEdicion) { %>
                    <input type="hidden" name="txtid" value="<%= tareaEditar.getId() %>">
                <% } %>

                <%-- Actividad preseleccionada (hidden si viene de una actividad específica) --%>
                <% if (idActPre != null) { %>
                    <input type="hidden" name="txtactividad" value="<%= idActPre %>">
                <% } else if (esEdicion) { %>
                    <input type="hidden" name="txtactividad" value="<%= tareaEditar.getActividadId() %>">
                <% } %>

                <%-- Título --%>
                <div class="form-group">
                    <label><i class="fas fa-heading"></i> Título *</label>
                    <input type="text" name="txttitulo"
                           value="<%= esEdicion && tareaEditar.getTitulo() != null ? tareaEditar.getTitulo() : "" %>"
                           placeholder="Nombre de la tarea" required>
                </div>

                <%-- Actividad (select visible solo si no viene preseleccionada) --%>
                <% if (idActPre == null && !esEdicion) { %>
                <div class="form-group">
                    <label><i class="fas fa-folder"></i> Actividad *</label>
                    <select name="txtactividad" required>
                        <option value="">-- Seleccione una actividad --</option>
                        <% for (Actividad act : listaActividades) { %>
                        <option value="<%= act.getId() %>">
                            <%= act.getTitulo() != null ? act.getTitulo() : "Sin título" %>
                        </option>
                        <% } %>
                    </select>
                </div>
                <% } %>

                <%-- Categoría --%>
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Categoría</label>
                    <select name="txtcategoria">
                        <option value="">-- Sin categoría --</option>
                        <% for (Categoria cat : listaCategorias) {
                            boolean sel = esEdicion && tareaEditar.getCategoriaId() == cat.getId();
                        %>
                        <option value="<%= cat.getId() %>" <%= sel ? "selected" : "" %>>
                            <%= cat.getNombre() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <%-- Prioridad --%>
                <div class="form-group">
                    <label><i class="fas fa-exclamation-triangle"></i> Prioridad *</label>
                    <select name="txtprioridad" required>
                        <option value="">-- Seleccione --</option>
                        <option value="Alta"  <%= esEdicion && "Alta".equals(tareaEditar.getPrioridad())  ? "selected" : "" %>>Alta</option>
                        <option value="Media" <%= esEdicion && "Media".equals(tareaEditar.getPrioridad()) ? "selected" : "" %>>Media</option>
                        <option value="Baja"  <%= esEdicion && "Baja".equals(tareaEditar.getPrioridad())  ? "selected" : "" %>>Baja</option>
                    </select>
                </div>

                <%-- Usuario asignado (solo admin) --%>
                <% if (isAdmin && !listaUsuarios.isEmpty()) { %>
                <div class="form-group">
                    <label><i class="fas fa-user"></i> Usuario asignado</label>
                    <select name="txtusuario">
                        <option value="">-- Sin asignar --</option>
                        <% for (Usuario u : listaUsuarios) {
                            boolean sel = esEdicion && tareaEditar.getUsuarioId() == u.getId();
                        %>
                        <option value="<%= u.getId() %>" <%= sel ? "selected" : "" %>>
                            <%= u.getNombre() %>
                        </option>
                        <% } %>
                    </select>
                </div>
                <% } %>

                <%-- Fechas --%>
                <div class="form-row">
                    <div class="form-group">
                        <label><i class="far fa-calendar"></i> Fecha Inicio</label>
                        <input type="date" name="txtfecha_inicio"
                               value="<%= esEdicion && tareaEditar.getFechaInicio() != null ? tareaEditar.getFechaInicio() : "" %>">
                    </div>
                    <div class="form-group">
                        <label><i class="far fa-calendar-check"></i> Fecha Vencimiento</label>
                        <input type="date" name="txtfecha_vencimiento"
                               value="<%= esEdicion && tareaEditar.getFechaVencimiento() != null ? tareaEditar.getFechaVencimiento() : "" %>">
                    </div>
                </div>

                <%-- Descripción --%>
                <div class="form-group">
                    <label><i class="fas fa-align-left"></i> Descripción</label>
                    <textarea name="txtdescripcion" rows="3" placeholder="Descripción opcional"><%= esEdicion && tareaEditar.getDescripcion() != null ? tareaEditar.getDescripcion() : "" %></textarea>
                </div>

                <div class="actions">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> <%= esEdicion ? "Actualizar" : "Guardar" %>
                    </button>
                    <a href="ActividadServlet?accion=listar" class="btn-cancel">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
