<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultar Datos - Sistema de Gestión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            border-radius: 15px 15px 0 0 !important;
            font-weight: bold;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .table-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stat-card {
            text-align: center;
            padding: 20px;
            border-radius: 10px;
            color: white;
        }
        .stat-card i {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .stat-card h3 {
            font-size: 2rem;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-total { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-completadas { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); }
        .stat-proceso { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .stat-pendientes { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .badge-prioridad {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.85rem;
        }
        .badge-alta { background-color: #dc3545; color: white; }
        .badge-media { background-color: #ffc107; color: black; }
        .badge-baja { background-color: #28a745; color: white; }
        .badge-estado {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.85rem;
        }
        .badge-completada { background-color: #28a745; color: white; }
        .badge-proceso { background-color: #17a2b8; color: white; }
        .badge-pendiente { background-color: #ffc107; color: black; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="dashboard.jsp">
            <i class="bi bi-clipboard-data"></i> Sistema de Gestión de Tareas
        </a>
        <div class="d-flex">
            <span class="navbar-text text-white me-3">
                <i class="bi bi-person-circle"></i> ${sessionScope.usuario.username}
            </span>
            <a href="index.jsp" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right"></i> Salir
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-database"></i> Consultar Datos del Sistema</h2>
        <div class="btn-group" role="group">
            <a href="ConsultarDatosServlet?tipo=todo" class="btn btn-primary">
                <i class="bi bi-list-check"></i> Todo
            </a>
            <a href="ConsultarDatosServlet?tipo=actividades" class="btn btn-outline-primary">
                <i class="bi bi-folder"></i> Actividades
            </a>
            <a href="ConsultarDatosServlet?tipo=tareas" class="btn btn-outline-primary">
                <i class="bi bi-check-square"></i> Tareas
            </a>
        </div>
    </div>

    <!-- Mostrar Actividades -->
    <c:if test="${not empty listaActividades}">
        <!-- Estadísticas de Actividades -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card stat-total">
                    <i class="bi bi-folder-fill"></i>
                    <h3>${totalActividades}</h3>
                    <p>Total Actividades</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card stat-completadas">
                    <i class="bi bi-check-circle-fill"></i>
                    <h3>${actividadesCompletadas}</h3>
                    <p>Completadas</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card stat-proceso">
                    <i class="bi bi-arrow-repeat"></i>
                    <h3>${actividadesEnProceso}</h3>
                    <p>En Proceso</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card stat-pendientes">
                    <i class="bi bi-clock-fill"></i>
                    <h3>${actividadesPendientes}</h3>
                    <p>Pendientes</p>
                </div>
            </div>
        </div>

        <!-- Tabla de Actividades -->
        <div class="table-container mb-4">
            <h3 class="mb-3"><i class="bi bi-folder-fill"></i> Lista de Actividades</h3>
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Título</th>
                            <th>Descripción</th>
                            <th>Prioridad</th>
                            <th>Estado</th>
                            <th>Fecha Inicio</th>
                            <th>Fecha Fin</th>
                            <th>Color</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="actividad" items="${listaActividades}">
                            <tr>
                                <td>${actividad.id}</td>
                                <td><strong>${actividad.titulo}</strong></td>
                                <td>${actividad.descripcion}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${actividad.prioridad == 'Alta'}">
                                            <span class="badge-prioridad badge-alta">${actividad.prioridad}</span>
                                        </c:when>
                                        <c:when test="${actividad.prioridad == 'Media'}">
                                            <span class="badge-prioridad badge-media">${actividad.prioridad}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-prioridad badge-baja">${actividad.prioridad}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${actividad.estado == 'Completada'}">
                                            <span class="badge-estado badge-completada">${actividad.estado}</span>
                                        </c:when>
                                        <c:when test="${actividad.estado == 'En Proceso'}">
                                            <span class="badge-estado badge-proceso">${actividad.estado}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-estado badge-pendiente">${actividad.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${actividad.fecha_inicio}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${actividad.fecha_fin}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <span style="display:inline-block; width:30px; height:30px; background-color:${actividad.color}; border-radius:50%; border:2px solid #ddd;"></span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <!-- Mostrar Tareas -->
    <c:if test="${not empty listaTareas}">
        <!-- Estadísticas de Tareas -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card stat-total">
                    <i class="bi bi-check-square-fill"></i>
                    <h3>${totalTareas}</h3>
                    <p>Total Tareas</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card stat-completadas">
                    <i class="bi bi-check-circle-fill"></i>
                    <h3>${tareasCompletadas}</h3>
                    <p>Completadas</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card stat-proceso">
                    <i class="bi bi-arrow-repeat"></i>
                    <h3>${tareasEnProceso}</h3>
                    <p>En Proceso</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card stat-pendientes">
                    <i class="bi bi-clock-fill"></i>
                    <h3>${tareasPendientes}</h3>
                    <p>Pendientes</p>
                </div>
            </div>
        </div>

        <!-- Tabla de Tareas -->
        <div class="table-container mb-4">
            <h3 class="mb-3"><i class="bi bi-check-square-fill"></i> Lista de Tareas</h3>
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Título</th>
                            <th>Descripción</th>
                            <th>Actividad</th>
                            <th>Prioridad</th>
                            <th>Estado</th>
                            <th>Fecha Inicio</th>
                            <th>Fecha Vencimiento</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tarea" items="${listaTareas}">
                            <tr>
                                <td>${tarea.id}</td>
                                <td><strong>${tarea.titulo}</strong></td>
                                <td>${tarea.descripcion}</td>
                                <td>${tarea.nombreActividad}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tarea.prioridad == 'Alta'}">
                                            <span class="badge-prioridad badge-alta">${tarea.prioridad}</span>
                                        </c:when>
                                        <c:when test="${tarea.prioridad == 'Media'}">
                                            <span class="badge-prioridad badge-media">${tarea.prioridad}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-prioridad badge-baja">${tarea.prioridad}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tarea.estado == 'Completada'}">
                                            <span class="badge-estado badge-completada">${tarea.estado}</span>
                                        </c:when>
                                        <c:when test="${tarea.estado == 'En Proceso'}">
                                            <span class="badge-estado badge-proceso">${tarea.estado}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-estado badge-pendiente">${tarea.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${tarea.fecha_inicio}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${tarea.fecha_vencimiento}" pattern="dd/MM/yyyy"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <!-- Botón para volver -->
    <div class="text-center mb-4">
        <a href="dashboard.jsp" class="btn btn-secondary btn-lg">
            <i class="bi bi-arrow-left"></i> Volver al Inicio
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

