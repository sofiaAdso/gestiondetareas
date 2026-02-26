<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("index.jsp"); return; }
    Actividad actividadEditar = (Actividad) request.getAttribute("actividad");
    boolean esEdicion = (actividadEditar != null);
    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");

    // Obtener parámetros de error
    String error = request.getParameter("error");
    String errorMsg = "";
    if (error != null) {
        switch(error) {
            case "titulo_vacio":
                errorMsg = "El título es obligatorio";
                break;
            case "fechas_requeridas":
            case "fecha_inicio_requerida":
            case "fecha_fin_requerida":
                errorMsg = "Las fechas de inicio y fin son obligatorias";
                break;
            case "fecha_invalida":
                errorMsg = "El formato de fecha es inválido";
                break;
            case "crear_actividad":
                errorMsg = "No se pudo crear la actividad. Verifica los datos e intenta nuevamente";
                break;
            case "datos_invalidos":
                errorMsg = "Los datos proporcionados son inválidos";
                break;
            default:
                errorMsg = "Ocurrió un error. Intenta nuevamente";
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= esEdicion ? "Editar" : "Nueva" %> Actividad</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        .form-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            width: 100%;
            max-width: 600px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h2 {
            color: #667eea;
            margin-bottom: 30px;
            font-size: 2rem;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-error {
            background: #fee;
            border: 1px solid #fcc;
            color: #c33;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 10px;
            box-sizing: border-box;
            font-size: 1rem;
            transition: all 0.3s;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        textarea {
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        .color-picker-group {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .color-picker-group input[type="color"] {
            width: 80px;
            height: 45px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
        }
        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1rem;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
        }
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-top: 10px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-back {
            background: #6c757d;
            color: white;
            text-decoration: none;
            margin-bottom: 20px;
            display: inline-flex;
        }
        .btn-back:hover {
            background: #5a6268;
        }
        .char-counter {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            text-align: right;
        }
        .required {
            color: #dc3545;
        }
...        .user-select-wrapper {
            background: linear-gradient(135deg, #e8f4f8 0%, #f0e6f6 100%);
            padding: 15px;
            border-radius: 12px;
            border: 2px solid #b8daff;
        }
        .user-select-wrapper select {
            background: white;
            border: 2px solid #667eea;
        }
        .user-select-wrapper label {
            color: #495057;
            font-size: 1.05rem;
        }
        .user-select-wrapper small {
            color: #495057 !important;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <a href="ActividadServlet?accion=listar" class="btn btn-back">
            <i class="fas fa-arrow-left"></i> Volver
        </a>

        <h2>
            <i class="fas fa-<%= esEdicion ? "edit" : "plus-circle" %>"></i>
            <%= esEdicion ? "Editar Actividad" : "Nueva Actividad" %>
        </h2>

        <% if (error != null && !errorMsg.isEmpty()) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <strong><%= errorMsg %></strong>
        </div>
        <% } %>

        <form action="ActividadServlet" method="POST" id="formActividad">
            <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "crear" %>">
            <% if(esEdicion){ %>
                <input type="hidden" name="id" value="<%= actividadEditar.getId() %>">
            <% } %>

            <div class="form-group">
                <label>
                    <i class="fas fa-heading"></i>
                    Título <span class="required">*</span>
                </label>
                <input
                    type="text"
                    id="titulo"
                    name="titulo"
                    maxlength="200"
                    value="<%= esEdicion ? actividadEditar.getTitulo() : "" %>"
                    required
                    placeholder="Ej: Proyecto de Desarrollo Web">
                <div class="char-counter" id="contador-titulo">0 / 200 caracteres</div>
            </div>

            <% if (listaUsuarios != null && !listaUsuarios.isEmpty()) { %>
            <div class="form-group user-select-wrapper">
                <label>
                    <i class="fas fa-user-circle"></i>
                    Asignar a Usuario <span class="required">*</span>
                </label>
                <select name="usuario_id" required style="padding: 12px; font-size: 1rem;">
                    <%
                    int usuarioAsignadoId = esEdicion ? actividadEditar.getUsuario_id() : user.getId();
                    for(Usuario u : listaUsuarios) {
                    %>
                        <option value="<%= u.getId() %>" <%= u.getId() == usuarioAsignadoId ? "selected" : "" %>>
                            <%= u.getUsername() %><%= u.getEmail() != null && !u.getEmail().isEmpty() ? " (" + u.getEmail() + ")" : "" %>
                        </option>
                    <% } %>
                </select>
                <small style="display: block; margin-top: 8px; font-weight: 500;">
                    <i class="fas fa-info-circle"></i> Selecciona el usuario al que deseas asignar esta actividad
                </small>
            </div>
            <% } else { %>
                <!-- Si no hay lista de usuarios, usar el usuario actual -->
                <input type="hidden" name="usuario_id" value="<%= user.getId() %>">
            <% } %>

            <div class="form-group">
                <label>
                    <i class="fas fa-align-left"></i>
                    Descripción
                </label>
                <textarea
                    id="descripcion"
                    name="descripcion"
                    maxlength="500"
                    placeholder="Describe los objetivos de esta actividad..."><%= esEdicion && actividadEditar.getDescripcion() != null ? actividadEditar.getDescripcion() : "" %></textarea>
                <div class="char-counter" id="contador-descripcion">0 / 500 caracteres</div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>
                        <i class="far fa-calendar"></i>
                        Fecha Inicio <span class="required">*</span>
                    </label>
                    <input
                        type="date"
                        id="fecha_inicio"
                        name="fecha_inicio"
                        value="<%= esEdicion && actividadEditar.getFecha_inicio() != null ? actividadEditar.getFecha_inicio() : "" %>"
                        required>
                </div>

                <div class="form-group">
                    <label>
                        <i class="far fa-calendar-check"></i>
                        Fecha Fin <span class="required">*</span>
                    </label>
                    <input
                        type="date"
                        id="fecha_fin"
                        name="fecha_fin"
                        value="<%= esEdicion && actividadEditar.getFecha_fin() != null ? actividadEditar.getFecha_fin() : "" %>"
                        required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>
                        <i class="fas fa-exclamation-triangle"></i>
                        Prioridad <span class="required">*</span>
                    </label>
                    <select name="prioridad" required>
                        <option value="Baja" <%= esEdicion && "Baja".equals(actividadEditar.getPrioridad()) ? "selected" : "" %>>Baja</option>
                        <option value="Media" <%= esEdicion && "Media".equals(actividadEditar.getPrioridad()) ? "selected" : "" %> <%= !esEdicion ? "selected" : "" %>>Media</option>
                        <option value="Alta" <%= esEdicion && "Alta".equals(actividadEditar.getPrioridad()) ? "selected" : "" %>>Alta</option>
                    </select>
                </div>

                <% if (!"Administrador".equals(user.getRol())) { %>
                <div class="form-group">
                    <label>
                        <i class="fas fa-check-circle"></i>
                        ¿Marcar como Completada?
                    </label>
                    <select name="estado" required style="padding: 12px; font-size: 1rem;">
                        <option value="En Progreso" <%= !esEdicion || (esEdicion && !"Completada".equals(actividadEditar.getEstado())) ? "selected" : "" %>>
                            No, aún en progreso
                        </option>
                        <option value="Completada" <%= esEdicion && "Completada".equals(actividadEditar.getEstado()) ? "selected" : "" %>>
                            Sí, marcar como completada
                        </option>
                    </select>
                    <small style="color: #666; font-size: 12px; display: block; margin-top: 5px;">
                        <i class="fas fa-info-circle"></i> Puedes marcar la actividad como completada cuando hayas terminado todas las tareas
                    </small>
                </div>
                <% } else { %>
                    <!-- Admin: No ve ni puede modificar el estado, se establece por defecto -->
                    <input type="hidden" name="estado" value="<%= esEdicion ? actividadEditar.getEstado() : "En Progreso" %>">
                <% } %>
            </div>

            <div class="form-group" style="<%= "Administrador".equals(user.getRol()) ? "" : "display:none;" %>">
                <!-- Espacio para mantener el layout -->
            </div>

            <div class="form-group">
                <label>
                    <i class="fas fa-palette"></i>
                    Color de Identificación
                </label>
                <div class="color-picker-group">
                    <input
                        type="color"
                        id="color"
                        name="color"
                        value="<%= esEdicion && actividadEditar.getColor() != null ? actividadEditar.getColor() : "#3498db" %>">
                    <span id="color-hex" style="font-family: monospace; font-weight: bold;">
                        <%= esEdicion && actividadEditar.getColor() != null ? actividadEditar.getColor() : "#3498db" %>
                    </span>
                </div>
                <small style="color: #666; font-size: 0.85rem; display: block; margin-top: 5px;">
                    <i class="fas fa-info-circle"></i> Este color ayudará a identificar visualmente esta actividad
                </small>
            </div>

            <button type="submit" class="btn btn-submit">
                <i class="fas fa-save"></i>
                <%= esEdicion ? "Guardar Cambios" : "Crear Actividad" %>
            </button>
        </form>
    </div>

    <script>
        // Contador de caracteres
        function actualizarContador(inputId, contadorId, maxLength) {
            const input = document.getElementById(inputId);
            const contador = document.getElementById(contadorId);

            function actualizar() {
                const length = input.value.length;
                contador.textContent = length + ' / ' + maxLength + ' caracteres';
            }

            input.addEventListener('input', actualizar);
            actualizar();
        }

        // Actualizar color hex
        const colorPicker = document.getElementById('color');
        const colorHex = document.getElementById('color-hex');

        colorPicker.addEventListener('input', function() {
            colorHex.textContent = this.value.toUpperCase();
        });

        // Validación de fechas
        const fechaInicio = document.getElementById('fecha_inicio');
        const fechaFin = document.getElementById('fecha_fin');

        // Establecer la fecha mínima de inicio como la fecha actual
        const fechaHoy = new Date();
        fechaHoy.setHours(0, 0, 0, 0);
        const fechaHoyStr = fechaHoy.toISOString().split('T')[0];

        // Solo establecer min si no estamos editando o si la fecha de inicio es futura
        <% if (!esEdicion) { %>
        fechaInicio.setAttribute('min', fechaHoyStr);
        <% } else { %>
        // En modo edición, permitir la fecha actual como mínimo
        const fechaInicioActual = fechaInicio.value;
        if (fechaInicioActual) {
            const fechaInicioDate = new Date(fechaInicioActual + 'T00:00:00');
            if (fechaInicioDate >= fechaHoy) {
                fechaInicio.setAttribute('min', fechaHoyStr);
            }
        }
        <% } %>

        fechaInicio.addEventListener('change', function() {
            const fechaSeleccionada = new Date(this.value + 'T00:00:00');

            // Validar que la fecha de inicio no sea anterior a hoy
            if (fechaSeleccionada < fechaHoy) {
                Swal.fire({
                    icon: 'error',
                    title: 'Fecha inválida',
                    text: 'La fecha de inicio no puede ser anterior al día actual'
                });
                this.value = '';
                fechaFin.removeAttribute('min');
                return;
            }

            // Si hay una fecha de fin, validar que sea posterior a la fecha de inicio
            if (fechaFin.value && fechaFin.value <= this.value) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Fecha inválida',
                    text: 'La fecha de fin debe ser posterior a la fecha de inicio'
                });
                fechaFin.value = '';
            }

            // Establecer la fecha mínima de fin como un día después de la fecha de inicio
            if (this.value) {
                const fechaInicioObj = new Date(this.value + 'T00:00:00');
                fechaInicioObj.setDate(fechaInicioObj.getDate() + 1);
                const fechaMinimaFin = fechaInicioObj.toISOString().split('T')[0];
                fechaFin.setAttribute('min', fechaMinimaFin);
            }
        });

        fechaFin.addEventListener('change', function() {
            if (fechaInicio.value && this.value <= fechaInicio.value) {
                Swal.fire({
                    icon: 'error',
                    title: 'Fecha inválida',
                    text: 'La fecha de fin debe ser posterior a la fecha de inicio'
                });
                this.value = '';
            }
        });

        // Validación antes del envío
        document.getElementById('formActividad').addEventListener('submit', function(e) {
            const titulo = document.getElementById('titulo').value.trim();
            const fechaIni = fechaInicio.value;
            const fechaF = fechaFin.value;

            console.log('Validando formulario antes de enviar...');
            console.log('Título:', titulo);
            console.log('Fecha Inicio:', fechaIni);
            console.log('Fecha Fin:', fechaF);

            if (!titulo) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Campo requerido',
                    text: 'El título es obligatorio'
                });
                return false;
            }

            if (!fechaIni || !fechaF) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Campos requeridos',
                    text: 'Las fechas de inicio y fin son obligatorias'
                });
                return false;
            }

            // Validar que la fecha de inicio no sea anterior a hoy (solo en creación)
            <% if (!esEdicion) { %>
            const fechaInicioDate = new Date(fechaIni + 'T00:00:00');
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

            // Validar que la fecha de fin sea posterior a la fecha de inicio
            if (fechaF <= fechaIni) {
                e.preventDefault();
                Swal.fire({
                    icon: 'error',
                    title: 'Fechas inválidas',
                    text: 'La fecha de fin debe ser posterior a la fecha de inicio'
                });
                return false;
            }

            console.log('✓ Validación exitosa, enviando formulario...');
        });

        // Inicializar contadores
        document.addEventListener('DOMContentLoaded', function() {
            actualizarContador('titulo', 'contador-titulo', 200);
            actualizarContador('descripcion', 'contador-descripcion', 500);
        });
    </script>
</body>
</html>

