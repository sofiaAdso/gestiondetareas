<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("index.jsp"); return; }

    Actividad actividadEditar = (Actividad) request.getAttribute("actividad");
    boolean esEdicion = (actividadEditar != null);
    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");
    if (listaUsuarios == null) listaUsuarios = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= esEdicion ? "Editar" : "Nueva" %> Actividad | SENA</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --sena-purple: #391d5d;
            --sena-blue: #5c6bc0;
            --bg-gray: #f8fafc;
            --section-bg: #f3f6ff; /* Color de los recuadros de sección */
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', 'Segoe UI', sans-serif; }

        body { background: #e2e8f0; height: 100vh; overflow: hidden; display: flex; }

        /* ── FONDO SIMULADO (Dashboard) ── */
        .sidebar-bg { width: 260px; background: var(--sena-purple); height: 100vh; filter: blur(2px); }
        .content-bg { flex: 1; background: #f0f2f5; padding: 30px; filter: blur(3px); }
        .card-mock { background: white; height: 200px; border-radius: 15px; margin-bottom: 20px; opacity: 0.6; }

        /* ── CAPA OVERLAY (Modal) ── */
        .overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.3);
            display: flex; align-items: center; justify-content: center; z-index: 1000;
        }

        .modal-card {
            background: white; width: 850px; max-height: 92vh;
            border-radius: 20px; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
            display: flex; flex-direction: column; animation: scaleIn 0.3s ease;
        }

        @keyframes scaleIn { from { transform: scale(0.95); opacity: 0; } to { transform: scale(1); opacity: 1; } }

        /* Header */
        .modal-header {
            padding: 25px 35px; border-bottom: 1px solid #eee;
            display: flex; justify-content: space-between; align-items: center;
        }
        .header-title { color: var(--sena-blue); font-size: 1.4rem; font-weight: 800; display: flex; align-items: center; gap: 12px; }
        .btn-close {
            width: 35px; height: 35px; border-radius: 50%; border: 1px solid #e2e8f0;
            display: flex; align-items: center; justify-content: center;
            color: #94a3b8; text-decoration: none; transition: 0.2s;
        }
        .btn-close:hover { background: #f1f5f9; color: #ef4444; }

        /* Form Body */
        .modal-body { padding: 30px 35px; overflow-y: auto; }

        /* RECUADROS DE SECCIÓN (Igual a tu imagen de referencia) */
        .form-section {
            background: var(--section-bg);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #eef2ff;
        }

        .section-title {
            display: flex; align-items: center; gap: 10px;
            color: var(--sena-blue); font-size: 0.75rem; font-weight: 900;
            text-transform: uppercase; margin-bottom: 20px; letter-spacing: 0.5px;
        }

        .input-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .fgroup { display: flex; flex-direction: column; gap: 6px; }
        .fgroup.full { grid-column: span 2; }

        .fgroup label { font-size: 0.85rem; font-weight: 700; color: #475569; }
        .fgroup input, .fgroup select, .fgroup textarea {
            padding: 12px 15px; border: 1px solid #cbd5e1; border-radius: 10px;
            font-size: 0.95rem; background: white; transition: 0.2s;
        }
        .fgroup input:focus { border-color: var(--sena-blue); outline: none; box-shadow: 0 0 0 3px rgba(92,107,192,0.1); }

        /* Footer */
        .modal-footer {
            padding: 20px 35px; border-top: 1px solid #eee;
            display: flex; justify-content: flex-end; gap: 15px;
        }

        .btn { padding: 12px 35px; border-radius: 12px; font-weight: 700; font-size: 0.95rem; cursor: pointer; transition: 0.2s; border: none; }
        .btn-cancel { background: #f8fafc; color: #64748b; text-decoration: none; display: flex; align-items: center; }
        .btn-cancel:hover { background: #f1f5f9; }
        .btn-save { background: #5c6bc0; color: white; box-shadow: 0 10px 15px -3px rgba(92,107,192,0.3); }
        .btn-save:hover { background: #4a59a7; transform: translateY(-1px); }
    </style>
</head>
<body>

    <!-- Dashboard de fondo -->
    <div class="sidebar-bg"></div>
    <div class="content-bg">
        <div class="card-mock"></div>
        <div class="card-mock"></div>
    </div>

    <!-- Modal Principal -->
    <div class="overlay">
        <div class="modal-card">

            <div class="modal-header">
                <div class="header-title">
                    <i class="fas fa-file-signature"></i>
                    <%= esEdicion ? "Editar Actividad" : "Nueva Actividad" %>
                </div>
                <a href="ActividadServlet?accion=listar" class="btn-close"><i class="fas fa-times"></i></a>
            </div>

            <div class="modal-body">
                <form action="ActividadServlet" method="POST" id="formActividad">
                    <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "crear" %>">
                    <% if (esEdicion) { %><input type="hidden" name="id" value="<%= actividadEditar.getId() %>"><% } %>

                    <!-- Estado automático y oculto -->
                    <input type="hidden" name="estado" value="<%= esEdicion ? actividadEditar.getEstado() : "Pendiente" %>">

                    <!-- SECCIÓN 1: INFORMACIÓN GENERAL -->
                    <div class="form-section">
                        <div class="section-title"><i class="fas fa-info-circle"></i> Información General</div>
                        <div class="input-grid">
                            <div class="fgroup full">
                                <label>Título de la Actividad *</label>
                                <input type="text" name="titulo" required placeholder="Ej: Mantenimiento de Servidores"
                                       value="<%= esEdicion ? actividadEditar.getTitulo() : "" %>">
                            </div>
                            <div class="fgroup full">
                                <label>Descripción / Detalle de la Novedad</label>
                                <textarea name="descripcion" rows="3" placeholder="Describe la actividad o novedad presentada..."><%= esEdicion ? actividadEditar.getDescripcion() : "" %></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- SECCIÓN 2: IDENTIFICACIÓN -->
                    <div class="form-section">
                        <div class="section-title"><i class="fas fa-user-tag"></i> Asignación y Prioridad</div>
                        <div class="input-grid">
                            <div class="fgroup">
                                <label>Asignar a Instructor/Usuario *</label>
                                <select name="usuario_id" required>
                                    <% for (Usuario u : listaUsuarios) { %>
                                    <option value="<%= u.getId() %>" <%= (esEdicion && u.getId() == actividadEditar.getUsuario_id()) ? "selected" : "" %>>
                                        <%= u.getNombre() != null ? u.getNombre() : u.getUsername() %>
                                    </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="fgroup">
                                <label>Nivel de Prioridad *</label>
                                <select name="prioridad" required>
                                    <option value="Baja" <%= esEdicion && "Baja".equals(actividadEditar.getPrioridad()) ? "selected" : "" %>>Baja</option>
                                    <option value="Media" <%= (!esEdicion || "Media".equals(actividadEditar.getPrioridad())) ? "selected" : "" %>>Media</option>
                                    <option value="Alta" <%= esEdicion && "Alta".equals(actividadEditar.getPrioridad()) ? "selected" : "" %>>Alta</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- SECCIÓN 3: TIEMPOS -->
                    <div class="form-section">
                        <div class="section-title"><i class="fas fa-calendar-check"></i> Tiempos y Plazos</div>
                        <div class="input-grid">
                            <div class="fgroup">
                                <label>Fecha de Inicio *</label>
                                <input type="date" name="fecha_inicio" id="fechaInicio" required
                                       value="<%= esEdicion ? actividadEditar.getFecha_inicio() : "" %>">
                            </div>
                            <div class="fgroup">
                                <label>Fecha de Vencimiento *</label>
                                <input type="date" name="fecha_fin" id="fechaFin" required
                                       value="<%= esEdicion ? actividadEditar.getFecha_fin() : "" %>">
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <a href="ActividadServlet?accion=listar" class="btn btn-cancel">Cancelar</a>
                <button type="submit" form="formActividad" class="btn btn-save">
                    <%= esEdicion ? "Guardar Cambios" : "Crear" %>
                </button>
            </div>
        </div>
    </div>

    <script>
        // Funcionalidad de validación
        const fIni = document.getElementById('fechaInicio');
        const fFin = document.getElementById('fechaFin');

        // Al cambiar inicio, la fecha fin no puede ser anterior
        fIni.addEventListener('change', function() {
            if(this.value) fFin.min = this.value;
        });

        document.getElementById('formActividad').addEventListener('submit', function(e) {
            if(fFin.value && fIni.value && fFin.value < fIni.value) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Error en fechas',
                    text: 'La fecha de vencimiento debe ser posterior a la de inicio.',
                    confirmButtonColor: '#5c6bc0'
                });
            }
        });
    </script>
</body>
</html>