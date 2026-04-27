<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reportes y Estadísticas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0eef8;
            display: flex;
            min-height: 100vh;
        }

        /* ── CONTENIDO PRINCIPAL ── */
        .main-content {
            margin-left: 260px;          /* mismo ancho que tu sidebar */
            width: calc(100% - 260px);
            padding: 32px 36px;
            overflow-y: auto;
        }

        /* ── CABECERA DE PÁGINA ── */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
        }
        .page-header h1 {
            font-size: 20px;
            font-weight: 600;
            color: #3c2f8f;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .page-header h1 i { font-size: 18px; color: #7c6fd4; }
        .page-subtitle {
            font-size: 13px;
            color: #8e8aab;
        }

        /* ── TARJETAS DE ESTADÍSTICAS ── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 20px 22px;
            display: flex;
            align-items: center;
            gap: 16px;
            border-top: 4px solid transparent;
            box-shadow: 0 2px 8px rgba(100, 80, 180, 0.08);
            transition: transform 0.15s;
        }
        .stat-card:hover { transform: translateY(-2px); }

        .stat-card.total     { border-top-color: #7c6fd4; }
        .stat-card.completas { border-top-color: #27ae60; }
        .stat-card.proceso   { border-top-color: #e6a817; }
        .stat-card.pendiente { border-top-color: #e05252; }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #fff;
            flex-shrink: 0;
        }
        .icon-total     { background: #7c6fd4; }
        .icon-completas { background: #27ae60; }
        .icon-proceso   { background: #e6a817; }
        .icon-pendiente { background: #e05252; }

        .stat-info h3 {
            font-size: 11px;
            font-weight: 600;
            color: #9e99bb;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 4px;
        }
        .stat-info p {
            font-size: 26px;
            font-weight: 700;
            color: #2d2260;
            line-height: 1;
        }
        .stat-info small {
            font-size: 11px;
            color: #b0acca;
        }

        /* ── FILA DE GRÁFICA + TABLA ── */
        .charts-row {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 20px;
            align-items: start;
        }

        /* ── TARJETA GENÉRICA ── */
        .card {
            background: #ffffff;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(100, 80, 180, 0.08);
        }
        .card-title {
            font-size: 14px;
            font-weight: 600;
            color: #3c2f8f;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .card-title i { color: #7c6fd4; font-size: 14px; }

        /* ── GRÁFICA ── */
        .chart-wrap {
            position: relative;
            width: 100%;
            height: 210px;
        }

        /* ── LEYENDA PERSONALIZADA ── */
        .chart-legend {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 18px;
        }
        .legend-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
            color: #555;
        }
        .legend-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 3px;
            flex-shrink: 0;
        }
        .legend-val {
            font-size: 12px;
            font-weight: 600;
            color: #2d2260;
        }

        /* ── TABLA ── */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 4px;
        }
        thead th {
            text-align: left;
            padding: 10px 14px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #9e99bb;
            background: #f7f5ff;
            border-bottom: 1px solid #ebe8f8;
        }
        thead th:first-child { border-radius: 8px 0 0 0; }
        thead th:last-child  { border-radius: 0 8px 0 0; }

        tbody td {
            padding: 12px 14px;
            font-size: 13px;
            color: #333;
            border-bottom: 1px solid #f0eef8;
        }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #faf9ff; }

        .titulo-act { font-weight: 600; color: #2d2260; }

        /* ── BADGES ── */
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .bg-success  { background: #d4f0e2; color: #1a6b3e; }
        .bg-warning  { background: #fef3d0; color: #8a5f00; }
        .bg-danger   { background: #fde0e0; color: #8a1f1f; }

        .badge-prioridad {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .p-alta   { background: #fde0e0; color: #8a1f1f; }
        .p-media  { background: #fef3d0; color: #8a5f00; }
        .p-baja   { background: #d4f0e2; color: #1a6b3e; }

        /* ── VACÍO ── */
        .empty-row td {
            text-align: center;
            padding: 40px;
            color: #b0acca;
            font-size: 13px;
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .charts-row { grid-template-columns: 1fr; }
            .main-content { margin-left: 0; width: 100%; padding: 20px; }
        }
        @media (max-width: 600px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <jsp:include page="components/header.jsp" />

    <div class="main-content">

        <!-- Cabecera -->
        <div class="page-header">
            <h1><i class="fas fa-chart-line"></i> Reporte de Gestión</h1>
            <span class="page-subtitle">Vista general de actividades</span>
        </div>

        <!-- Tarjetas de estadísticas -->
        <div class="stats-grid">
            <div class="stat-card total">
                <div class="stat-icon icon-total"><i class="fas fa-layer-group"></i></div>
                <div class="stat-info">
                    <h3>Total</h3>
                    <p>${totalActividades != null ? totalActividades : 0}</p>
                    <small>actividades</small>
                </div>
            </div>
            <div class="stat-card completas">
                <div class="stat-icon icon-completas"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info">
                    <h3>Completadas</h3>
                    <p>${completadas != null ? completadas : 0}</p>
                    <small>finalizadas</small>
                </div>
            </div>
            <div class="stat-card proceso">
                <div class="stat-icon icon-proceso"><i class="fas fa-spinner"></i></div>
                <div class="stat-info">
                    <h3>En Progreso</h3>
                    <p>${enProceso != null ? enProceso : 0}</p>
                    <small>en curso</small>
                </div>
            </div>
            <div class="stat-card pendiente">
                <div class="stat-icon icon-pendiente"><i class="fas fa-exclamation-circle"></i></div>
                <div class="stat-info">
                    <h3>Pendientes</h3>
                    <p>${pendientes != null ? pendientes : 0}</p>
                    <small>por iniciar</small>
                </div>
            </div>
        </div>

        <!-- Gráfica + Tabla -->
        <div class="charts-row">

            <!-- Gráfica de dona -->
            <div class="card">
                <p class="card-title"><i class="fas fa-chart-pie"></i> Estado de Tareas</p>
                <div class="chart-wrap">
                    <canvas id="graficaCumplimiento"
                            role="img"
                            aria-label="Gráfica de dona con estado de actividades">
                        Completadas: ${completadas}, En Proceso: ${enProceso}, Pendientes: ${pendientes}
                    </canvas>
                </div>
                <div class="chart-legend">
                    <div class="legend-item">
                        <div class="legend-left">
                            <span class="legend-dot" style="background:#27ae60;"></span>
                            <span>Completadas</span>
                        </div>
                        <span class="legend-val">${completadas != null ? completadas : 0}</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-left">
                            <span class="legend-dot" style="background:#e6a817;"></span>
                            <span>En Progreso</span>
                        </div>
                        <span class="legend-val">${enProceso != null ? enProceso : 0}</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-left">
                            <span class="legend-dot" style="background:#e05252;"></span>
                            <span>Pendientes</span>
                        </div>
                        <span class="legend-val">${pendientes != null ? pendientes : 0}</span>
                    </div>
                </div>
            </div>

            <!-- Tabla de actividades -->
            <div class="card">
                <p class="card-title"><i class="fas fa-list-ul"></i> Detalle de Actividades Recientes</p>
                <table>
                    <thead>
                        <tr>
                            <th>Título</th>
                            <th>Prioridad</th>
                            <th>Fecha Inicio</th>
                            <th>Fecha Fin</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${listaActividades}">
                            <tr>
                                <td class="titulo-act">${a.titulo}</td>
                                <td>
                                    <span class="badge-prioridad
                                        ${a.prioridad == 'Alta' ? 'p-alta' :
                                          a.prioridad == 'Media' ? 'p-media' : 'p-baja'}">
                                        ${a.prioridad}
                                    </span>
                                </td>
                                <td>${a.fechaInicio != null ? a.fechaInicio : 'Sin fecha'}</td>
                                <td>${a.fechaFin   != null ? a.fechaFin   : 'Sin fecha'}</td>
                                <td>
                                    <span class="badge
                                        ${a.estado == 'Completada' ? 'bg-success' :
                                         (a.estado == 'En Progreso' || a.estado == 'En Proceso' ||
                                          a.estado == 'En curso'   || a.estado == 'Proceso'
                                          ? 'bg-warning' : 'bg-danger')}">
                                        ${a.estado}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaActividades}">
                            <tr class="empty-row">
                                <td colspan="5">
                                    <i class="fas fa-inbox" style="font-size:24px; display:block; margin-bottom:8px; color:#c8c3e8;"></i>
                                    No se encontraron actividades registradas.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div><!-- /charts-row -->

    </div><!-- /main-content -->

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('graficaCumplimiento').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Completadas', 'En Proceso', 'Pendientes'],
                datasets: [{
                    data: [${completadas != null ? completadas : 0},
                           ${enProceso  != null ? enProceso  : 0},
                           ${pendientes != null ? pendientes : 0}],
                    backgroundColor: ['#27ae60', '#e6a817', '#e05252'],
                    borderWidth: 0,
                    hoverOffset: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: (ctx) => ' ' + ctx.label + ': ' + ctx.parsed
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>