<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("index.jsp"); return; }

    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    if (listaActividades == null) listaActividades = new ArrayList<>();

    String errorMensaje = (String) request.getAttribute("errorMensaje");
    boolean isAdmin = "Administrador".equals(user.getRol());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actividades | Sistema de Gestión</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        .header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 30px; padding-bottom: 20px;
            border-bottom: 3px solid #667eea;
        }
        .header h1 { font-size: 1.6rem; color: #333; }
        .actividades-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 22px;
        }
        .actividad-card {
            background: white; border-radius: 14px; padding: 22px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border-left: 5px solid #667eea;
            display: flex; flex-direction: column;
            transition: transform 0.25s, box-shadow 0.25s;
            animation: fadeInUp 0.4s ease-out;
        }
        .actividad-card:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.12); }
        @keyframes fadeInUp {
            from { opacity:0; transform:translateY(12px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .actividad-titulo {
            font-size: 1.1rem; font-weight: 700; color: #222;
            margin-bottom: 8px; word-break: break-word;
        }
        .actividad-descripcion {
            color: #666; font-size: 0.84rem; line-height: 1.5;
            margin-bottom: 16px; flex-grow: 1;
        }
        .badge {
            padding: 5px 12px; border-radius: 20px;
            font-size: 0.78rem; font-weight: 700;
            display: inline-flex; align-items: center; gap: 5px;
            white-space: nowrap;
        }
        .estado-planificada { background:#e3f2fd; color:#1565c0; border:1px solid #90caf9; }
        .estado-progreso    { background:#fff3e0; color:#e65100; border:1px solid #ffb74d; }
        .estado-completada  { background:#e8f5e9; color:#2e7d32; border:1px solid #81c784; }
        .estado-pendiente   { background:#fff8e1; color:#f57f17; border:1px solid #ffe082; }
        .estado-wrap {
            margin: 12px 0;
            display: flex; align-items: center; gap: 8px;
        }
        .estado-wrap label {
            font-size: 0.78rem; font-weight: 600;
            color: #555; white-space: nowrap;
        }
        .estado-select {
            flex: 1; padding: 8px 12px;
            border-radius: 8px; border: 2px solid #e0e0e0;
            font-size: 0.85rem; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23666' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-color: white;
        }
        .estado-select:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.15); }
        .estado-select:hover { border-color: #667eea; }
        .select-pendiente  { border-color: #ffc107; color: #856404; }
        .select-progreso   { border-color: #fd7e14; color: #e65100; }
        .select-completada { border-color: #28a745; color: #155724; }
        .actividad-actions { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px; }
        .btn-accion {
            text-decoration: none; padding: 8px 14px;
            border-radius: 8px; border: 2px solid;
            font-size: 0.82rem; font-weight: 600;
            display: inline-flex; align-items: center; gap: 5px;
            transition: all 0.25s; cursor: pointer; background: white;
        }
        .btn-ver     { color: #17a2b8; border-color: #17a2b8; }
        .btn-ver:hover { background: #17a2b8; color: white; }
        .btn-editar  { color: #007bff; border-color: #007bff; }
        .btn-editar:hover { background: #007bff; color: white; }
        .btn-eliminar { color: #dc3545; border-color: #dc3545; }
        .btn-eliminar:hover { background: #dc3545; color: white; }
        .alerta {
            padding: 14px 18px; border-radius: 10px;
            margin-bottom: 20px; font-size: 0.9rem;
            display: flex; align-items: center; gap: 10px;
        }
        .alerta-error { background:#f8d7da; color:#721c24; border:1px solid #f5c6cb; }
        .empty-state { text-align:center; padding:60px 20px; color:#999; }
        .empty-state i { font-size:3rem; opacity:0.3; display:block; margin-bottom:14px; }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="container">

        <% if (errorMensaje != null && !errorMensaje.isEmpty()) { %>
        <div class="alerta alerta-error">
            <i class="fas fa-exclamation-circle"></i>
            <strong>Error:</strong> <%= errorMensaje %>
        </div>
        <% } %>

        <div class="header">
            <h1><i class="fas fa-folder" style="color:#667eea;margin-right:10px;"></i>
                <%= isAdmin ? "Todas las Actividades" : "Mis Actividades" %>
            </h1>
            <div style="display:flex;gap:10px;">
                <% if (isAdmin) { %>
                <a href="ActividadServlet?accion=nuevo" class="btn-accion"
                   style="background:linear-gradient(135deg,#667eea,#764ba2);color:white;border-color:transparent;padding:10px 20px;">
                    <i class="fas fa-plus"></i> Nueva Actividad
                </a>
                <% } %>
            </div>
        </div>

        <% if (listaActividades.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-folder-open"></i>
            <p style="font-size:1.1rem;font-weight:600;">No hay actividades para mostrar</p>
            <% if (isAdmin) { %>
            <a href="ActividadServlet?accion=nuevo" style="color:#667eea;font-weight:600;margin-top:10px;display:inline-block;">
                + Crear primera actividad
            </a>
            <% } %>
        </div>
        <% } else { %>
        <div class="actividades-grid">
            <% for (Actividad act : listaActividades) {
                String titulo = act.getTitulo() != null ? act.getTitulo() : "Sin título";
                String desc   = act.getDescripcion() != null ? act.getDescripcion() : "Sin descripción";
                String estado = act.getEstado() != null ? act.getEstado() : "En Progreso";
                String color  = act.getColor() != null ? act.getColor() : "#667eea";

                String claseEstado = "estado-progreso";
                String icono = "fa-spinner fa-spin";
                if (estado.equalsIgnoreCase("Planificada"))  { claseEstado="estado-planificada"; icono="fa-calendar-alt"; }
                else if (estado.equalsIgnoreCase("En Progreso")) { claseEstado="estado-progreso"; icono="fa-spinner fa-spin"; }
                else if (estado.equalsIgnoreCase("Completada"))  { claseEstado="estado-completada"; icono="fa-check-circle"; }
                else if (estado.equalsIgnoreCase("Pendiente"))   { claseEstado="estado-pendiente"; icono="fa-clock"; }

                String claseSelect = "select-progreso";
                if (estado.equalsIgnoreCase("Pendiente"))   claseSelect = "select-pendiente";
                if (estado.equalsIgnoreCase("Completada"))  claseSelect = "select-completada";
            %>
            <div class="actividad-card" style="border-left-color:<%= color %>;">

                <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:10px;margin-bottom:8px;">
                    <h2 class="actividad-titulo"><%= titulo %></h2>
                    <span class="badge <%= claseEstado %>">
                        <i class="fas <%= icono %>"></i> <%= estado %>
                    </span>
                </div>

                <p class="actividad-descripcion"><%= desc %></p>

                <% if (!isAdmin) { %>
                <div class="estado-wrap">
                    <label><i class="fas fa-exchange-alt"></i> Estado:</label>
                    <select id="estado_act_<%= act.getId() %>"
                            class="estado-select <%= claseSelect %>"
                            data-estado-actual="<%= estado %>"
                            onchange="cambiarEstado(<%= act.getId() %>, this)">
                        <option value="Pendiente"   <%= estado.equalsIgnoreCase("Pendiente")   ? "selected" : "" %>>⏳ Pendiente</option>
                        <option value="En Progreso" <%= estado.equalsIgnoreCase("En Progreso") ? "selected" : "" %>>🔄 En Progreso</option>
                        <option value="Completada"  <%= estado.equalsIgnoreCase("Completada")  ? "selected" : "" %>>✅ Completada</option>
                    </select>
                </div>
                <% } %>

                <div class="actividad-actions">
                    <a href="ActividadServlet?accion=ver&id=<%= act.getId() %>" class="btn-accion btn-ver">
                        <i class="fas fa-eye"></i> Ver
                    </a>
                    <% if (isAdmin) { %>
                    <a href="ActividadServlet?accion=editar&id=<%= act.getId() %>" class="btn-accion btn-editar">
                        <i class="fas fa-edit"></i> Editar
                    </a>
                    <button onclick="confirmarEliminar(<%= act.getId() %>)" class="btn-accion btn-eliminar">
                        <i class="fas fa-trash"></i> Eliminar
                    </button>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <script>
        function cambiarEstado(actividadId, selectElement) {
            const nuevoEstado    = selectElement.value;
            const estadoAnterior = selectElement.getAttribute('data-estado-actual');
            if (nuevoEstado === estadoAnterior) return;

            const config = {
                'Pendiente':   { icono:'warning', color:'#ffc107', titulo:'¿Cambiar a Pendiente?',   msg:'La actividad quedará como pendiente.' },
                'En Progreso': { icono:'info',    color:'#fd7e14', titulo:'¿Cambiar a En Progreso?', msg:'La actividad se marcará en progreso.' },
                'Completada':  { icono:'success', color:'#28a745', titulo:'¿Marcar como Completada?',msg:'¡La actividad se marcará como terminada!' }
            };
            const cfg = config[nuevoEstado] || { icono:'question', color:'#667eea', titulo:'¿Cambiar estado?', msg:'' };

            Swal.fire({
                title: cfg.titulo, text: cfg.msg, icon: cfg.icono,
                showCancelButton: true,
                confirmButtonColor: cfg.color, cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, cambiar', cancelButtonText: 'Cancelar'
            }).then(result => {
                if (result.isConfirmed) {
                    Swal.fire({ title:'Actualizando...', allowOutsideClick:false, didOpen:()=>Swal.showLoading() });
                    fetch('ActividadServlet?accion=cambiarEstado&id=' + actividadId +
                          '&estado=' + encodeURIComponent(nuevoEstado))
                    .then(res => res.json())
                    .then(data => {
                        if (data.ok) {
                            const card   = selectElement.closest('.actividad-card');
                            const badge  = card.querySelector('.badge');
                            const iconos = { 'Pendiente':'fa-clock', 'En Progreso':'fa-spinner fa-spin', 'Completada':'fa-check-circle' };
                            const clases = { 'Pendiente':'estado-pendiente', 'En Progreso':'estado-progreso', 'Completada':'estado-completada' };
                            badge.className = 'badge ' + (clases[nuevoEstado] || 'estado-progreso');
                            badge.innerHTML = '<i class="fas ' + (iconos[nuevoEstado] || 'fa-circle') + '"></i> ' + nuevoEstado;
                            selectElement.setAttribute('data-estado-actual', nuevoEstado);
                            Swal.fire({ icon:'success', title:'¡Listo!', text:'Estado actualizado.', timer:1800, showConfirmButton:false });
                        } else {
                            selectElement.value = estadoAnterior;
                            Swal.fire('Error', data.mensaje || 'No se pudo actualizar', 'error');
                        }
                    })
                    .catch(() => {
                        selectElement.value = estadoAnterior;
                        Swal.fire('Error', 'Fallo en la conexión', 'error');
                    });
                } else {
                    selectElement.value = estadoAnterior;
                }
            });
        }

        function confirmarEliminar(id) {
            Swal.fire({
                title: '¿Eliminar actividad?',
                text: 'Se borrarán todas las tareas asociadas. Esta acción no se puede deshacer.',
                icon: 'warning', showCancelButton: true,
                confirmButtonColor: '#dc3545',
                confirmButtonText: 'Sí, eliminar', cancelButtonText: 'Cancelar'
            }).then(r => {
                if (r.isConfirmed) window.location.href = 'ActividadServlet?accion=eliminar&id=' + id;
            });
        }

        // ✅ Mapa completo de todos los códigos de error posibles
        const params = new URLSearchParams(window.location.search);
        if (params.get('msg') === 'ok') {
            Swal.fire({ icon:'success', title:'¡Hecho!', text:'Operación exitosa', timer:2000, showConfirmButton:false });
        }
        if (params.get('msg') === 'eliminado') {
            Swal.fire({ icon:'success', title:'Eliminado', text:'La actividad fue eliminada.', timer:2000, showConfirmButton:false });
        }
        if (params.get('error')) {
            const msgs = {
                sin_permiso:    'No tienes permiso para realizar esta acción',
                no_encontrada:  'La actividad no fue encontrada',
                actualizar:     'Error al actualizar el estado',
                datos_invalidos:'Error al cargar la actividad',
                eliminar:       'Error al eliminar la actividad',
                proceso:        'Error interno al procesar la solicitud',
                crear_actividad:'Error al crear la actividad',
                crear:          'Error al crear el elemento',
                id:             'ID inválido',
                del:            'Error al eliminar',
                // ✅ Claves genéricas para no mostrar código crudo
                true:           'Ocurrió un error. Por favor intenta de nuevo.',
                false:          'La operación no pudo completarse.'
            };
            const codigo = params.get('error');
            const mensaje = msgs[codigo] || 'Ocurrió un error inesperado (' + codigo + ')';
            Swal.fire({ icon:'error', title:'Error', text: mensaje });
        }
    </script>
</body>
</html>
