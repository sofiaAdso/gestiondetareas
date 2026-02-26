<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reportes y Estadísticas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --success: #2ecc71;
            --warning: #f1c40f;
            --danger: #e74c3c;
            --bg: #f4f7f6;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; }
        .main-content { padding: 30px; max-width: 1200px; margin: auto; }

        .header { margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { color: #333; margin: 0; font-size: 24px; }

        .btn-volver {
            text-decoration: none;
            background: var(--secondary);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-volver:hover { opacity: 0.9; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: white; padding: 20px; border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: flex; align-items: center; gap: 15px;
        }
        .stat-icon {
            width: 50px; height: 50px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; color: white;
        }
        .stat-info h3 { margin: 0; font-size: 13px; color: #7f8c8d; text-transform: uppercase; }
        .stat-info p { margin: 5px 0 0; font-size: 24px; font-weight: bold; color: #2c3e50; }

        .icon-total { background: var(--primary); }
        .icon-completas { background: var(--success); }
        .icon-proceso { background: var(--warning); }
        .icon-pendientes { background: var(--danger); }

        .charts-row { display: grid; grid-template-columns: 1fr 2fr; gap: 20px; margin-bottom: 20px; }

        @media (max-width: 900px) {
            .charts-row { grid-template-columns: 1fr; }
        }

        .report-container {
            background: white; padding: 25px; border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #eee; color: #7f8c8d; font-size: 13px; }
        td { padding: 12px; border-bottom: 1px solid #eee; font-size: 14px; color: #333; }

        .badge { padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .bg-success { background: #d4edda; color: #155724; }
        .bg-warning { background: #fff3cd; color: #856404; }
        .bg-danger { background: #f8d7da; color: #721c24; }

        canvas { max-height: 280px !important; }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="header">
            <h1><i class="fas fa-chart-line"></i> Reporte de Gestión</h1>
            <a href="dashboard.jsp" class="btn-volver"><i class="fas fa-home"></i> Dashboard</a>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon icon-total"><i class="fas fa-tasks"></i></div>
                <div class="stat-info">
                    <h3>Total</h3>
                    <p>${totalTareas != null ? totalTareas : 0}</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-completas"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info">
                    <h3>Completadas</h3>
                    <p>${completadas != null ? completadas : 0}</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-proceso"><i class="fas fa-sync"></i></div>
                <div class="stat-info">
                    <h3>En Proceso</h3>
                    <p>${enProceso != null ? enProceso : 0}</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-pendientes"><i class="fas fa-exclamation-circle"></i></div>
                <div class="stat-info">
                    <h3>Pendientes</h3>
                    <p>${pendientes != null ? pendientes : 0}</p>
                </div>
            </div>
        </div>

        <div class="charts-row">
            <div class="report-container">
                <h3>Estado de Tareas</h3>
                <canvas id="graficaCumplimiento"></canvas>
            </div>

            <div class="report-container">
                <h3>Detalle de Actividades Recientes</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Título</th>
                            <th>Actividad</th>
                            <th>Prioridad</th>
                            <th>Vencimiento</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="t" items="${listaTareas}">
                            <tr>
                                <td><strong>${t.titulo}</strong></td>
                                <td>${t.nombreActividad != null ? t.nombreActividad : 'Sin asignar'}</td>
                                <td>${t.prioridad}</td>
                                <td>${t.fechaVencimiento}</td>
                                <td>
                                    <span class="badge ${t.estado == 'Completada' ? 'bg-success' : (t.estado == 'En Proceso' ? 'bg-warning' : 'bg-danger')}">
                                        ${t.estado}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaTareas}">
                            <tr>
                                <td colspan="5" style="text-align: center; color: #999; padding: 40px;">
                                    No se encontraron tareas registradas.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('graficaCumplimiento').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Completadas', 'En Proceso', 'Pendientes'],
                datasets: [{
                    data: [${completadas}, ${enProceso}, ${pendientes}],
                    backgroundColor: ['#2ecc71', '#f1c40f', '#e74c3c'],
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    </script>
</body>
</html>