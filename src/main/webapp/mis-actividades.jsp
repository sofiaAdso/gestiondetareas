<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%
    // Validación de sesión y carga de datos
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    if (listaActividades == null) {
        response.sendRedirect("ActividadServlet?accion=mis-actividades");
        return;
    }
    boolean isAdmin = "Administrador".equals(user.getRol());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Actividades | Gestión de Tareas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .main-content { margin-left: 260px; padding: 30px; transition: all 0.3s; }
        .card-actividad {
            border: none;
            border-radius: 20px;
            border-left: 5px solid #2196F3;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card-actividad:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .btn-pill { border-radius: 50px; font-weight: 600; }
        .progress { height: 10px; border-radius: 10px; background-color: #e9ecef; }
        .badge-estado { padding: 8px 15px; border-radius: 50px; font-size: 0.8rem; }

        @media (max-width: 992px) { .main-content { margin-left: 0; } }
    </style>
</head>
<body>

    <jsp:include page="components/header.jsp" />

    <div class="main-content">
        <div class="container-fluid">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold"><i class="fas fa-layer-group text-primary me-2"></i>Mis Actividades</h2>
                <% if (isAdmin) { %>
                <button class="btn btn-primary btn-pill shadow-sm" onclick="location.href='nueva-actividad.jsp'">
                    <i class="fas fa-plus me-1"></i> Nueva Actividad
                </button>
                <% } %>
            </div>

            <%-- Filtros --%>
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-3">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="small fw-bold text-muted"><i class="fas fa-filter me-1"></i> Estado</label>
                            <select id="filtroEstado" class="form-select border-0 bg-light" onchange="filtrar()">
                                <option value="todos">Todos los estados</option>
                                <option value="Pendiente">Pendiente</option>
                                <option value="En Progreso">En Progreso</option>
                                <option value="Completada">Completada</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="small fw-bold text-muted"><i class="fas fa-bolt me-1"></i> Prioridad</label>
                            <select id="filtroPrioridad" class="form-select border-0 bg-light" onchange="filtrar()">
                                <option value="todos">Todas las prioridades</option>
                                <option value="Alta">Alta</option>
                                <option value="Media">Media</option>
                                <option value="Baja">Baja</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Grid de Actividades --%>
            <div class="row" id="contenedorActividades">
                <% for (Actividad act : listaActividades) {
                    String colorEstado = "bg-secondary";
                    if("Completada".equals(act.getEstado())) colorEstado = "bg-success";
                    else if("En Progreso".equals(act.getEstado())) colorEstado = "bg-warning text-dark";
                %>
                <div class="col-md-6 col-lg-4 mb-4 actividad-item"
                     id="actividad-card-<%= act.getId() %>"
                     data-estado="<%= act.getEstado() %>"
                     data-prioridad="<%= act.getPrioridad() %>">

                    <div class="card h-100 card-actividad shadow-sm">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <h5 class="fw-bold mb-0 text-truncate" style="max-width: 70%;"><%= act.getTitulo() %></h5>
                                <span class="badge badge-estado <%= colorEstado %>">
                                    <%= act.getEstado() %>
                                </span>
                            </div>

                            <p class="text-muted small mb-4" style="height: 45px; overflow: hidden;">
                                <%= act.getDescripcion() != null ? act.getDescripcion() : "Sin descripción." %>
                            </p>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="small fw-bold text-secondary">Progreso</span>
                                    <span class="small fw-bold text-primary"><%= Math.round(act.getPorcentajeCompletado()) %>%</span>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar bg-info" style="width: <%= act.getPorcentajeCompletado() %>%"></div>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <a href="Tareaservlet?accion=listarPorActividad&idActividad=<%= act.getId() %>"
                                   class="btn btn-outline-info btn-pill flex-fill">
                                    <i class="far fa-eye"></i> Ver
                                </a>
                                <button class="btn btn-warning btn-pill flex-fill fw-bold text-dark"
                                        onclick="confirmarEstado(<%= act.getId() %>, '<%= act.getEstado() %>')">
                                    <i class="fas fa-sync-alt"></i> Estado
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function filtrar() {
            const estado = document.getElementById('filtroEstado').value;
            const prioridad = document.getElementById('filtroPrioridad').value;

            document.querySelectorAll('.actividad-item').forEach(item => {
                const matchEstado = estado === 'todos' || item.dataset.estado === estado;
                const matchPrioridad = prioridad === 'todos' || item.dataset.prioridad === prioridad;
                item.style.display = (matchEstado && matchPrioridad) ? 'block' : 'none';
            });
        }

        function confirmarEstado(id, actual) {
            Swal.fire({
                title: 'Actualizar Estado',
                text: 'Selecciona el nuevo estado para esta actividad',
                input: 'select',
                inputOptions: {
                    'Pendiente': 'Pendiente',
                    'En Progreso': 'En Progreso',
                    'Completada': 'Completada'
                },
                inputValue: actual,
                showCancelButton: true,
                confirmButtonColor: '#2196F3',
                confirmButtonText: 'Actualizar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    const nuevoEstado = result.value;

                    // Petición AJAX al Servlet
                    fetch(`ActividadServlet?accion=cambiarEstado&id=${id}&estado=${nuevoEstado}`)
                    .then(response => {
                        if (response.ok) {
                            // Actualización visual sin recargar
                            const card = document.getElementById(`actividad-card-${id}`);
                            const badge = card.querySelector('.badge-estado');

                            // Actualizar texto y datos de filtro
                            badge.innerText = nuevoEstado;
                            card.dataset.estado = nuevoEstado;

                            // Actualizar clases de color
                            badge.className = 'badge badge-estado'; // Reset
                            if(nuevoEstado === 'Completada') {
                                badge.classList.add('bg-success');
                            } else if(nuevoEstado === 'En Progreso') {
                                badge.classList.add('bg-warning', 'text-dark');
                            } else {
                                badge.classList.add('bg-secondary');
                            }

                            Swal.fire({
                                icon: 'success',
                                title: '¡Listo!',
                                text: 'Estado actualizado correctamente',
                                timer: 1500,
                                showConfirmButton: false
                            });
                        } else {
                            Swal.fire('Error', 'No se pudo actualizar en la base de datos', 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        Swal.fire('Error', 'Fallo en la conexión', 'error');
                    });
                }
            });
        }
    </script>
</body>
</html>
